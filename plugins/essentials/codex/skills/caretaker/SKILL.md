---
name: caretaker
description: Rewrite tests and fix code to match the contract.
---

# Contract tests

A **contract** is what a unit promises its callers for all valid inputs: outputs, errors, side effects, invariants. A test that checks anything else locks in history or implementation. Replace those tests with contract tests.

## Process

1. Write down the contract of each unit (function, method, endpoint, CLI command, integration surface). Read the code to learn what a unit does; take what it should do from types, docs, specs, issues, and callers. Existing tests are not a source. Ignore caller code that works around a bug. Where no source settles a contract aspect, keep its tests and record an open question.
2. Map each test to the contract aspect it checks.
3. Run the project's tools: tests, line and branch coverage, mutation testing if available. Find tests that came in with bug fixes, and later tests and code that build on them.
4. Check every test against the rules below. Record each finding with file, line, and rule.
5. Replace tests that break a rule with contract tests. Where a contract test fails, fix the code. Remove workarounds for the bug. Run the suite.

Done when every test maps to one contract aspect or open question, every settled aspect has a test, and the suite is green. End with this report, one row per item, and "None" for an empty section. Output it as markdown, without the fence:

```markdown
## Findings
| Test | Rule | Problem |
|---|---|---|
| `file:line` `test_name` | bug-shaped, tautological, fake data, or patchwork | one sentence |

## Changes
| Removed | Added | Code change | Contract aspect |
|---|---|---|---|
| `test_name` or — | `test_name` or — | `file:unit` and one sentence, or — | one sentence |

## Open questions
| Unit | Aspect | What is unclear | Tests kept |
|---|---|---|---|
| `file:unit` | one phrase | one sentence | `test_name`, … |
```

## Rules

### 1. Bug-shaped tests

A **bug-shaped** test is a regression test written from a bug report: one input that broke, one symptom asserted. The fix is written to pass it, so both share the same narrow view. Later edits read the test as a contract and spread the bug into new code, tests, and callers.

Signs: named after an issue or symptom, one hard-coded input, added in the same commit as a fix, a later test or caller works around the same input.

Name the rule the bug broke and the inputs that rule covers. Replace the test with a contract test that covers them, keeping the bug input as one case. Remove tests that lock the bug and workarounds in callers.

<example>
# 1. Code with a bug
def parse(s):
    return s.split(",")

parse("a,b,")   # ["a", "b", ""]   bug report: "trailing comma adds empty field"

# 2. Regression test, shaped by the bug report
def test_trailing_comma():
    assert parse("a,b,") == ["a", "b"]   # red

# 3. Fix, shaped by the test
def parse(s):
    parts = s.split(",")
    return parts[:-1] if parts[-1] == "" else parts
# green

# 4. Shared blind spot. Code and test both carry the bug's framing
parse(",a,b")   # ["", "a", "b"]   still broken
parse("a,,b")   # ["a", "", "b"]   still broken
# Green: the test only checks what the fix covers.

# 5. Code shaped by the test. A later edit reads step 2 as the contract ("only a trailing empty field is dropped")
def parse(s):                                # new: trim whitespace
    parts = [p.strip() for p in s.split(",")]
    return parts[:-1] if parts[-1] == "" else parts   # bug carried over on purpose

def test_leading_comma_keeps_empty_field():  # new test locks the bug as spec
    assert parse(",a,b") == ["", "a", "b"]

def load_row(line):                          # caller works around the bug
    return [f for f in parse(line) if f]
# The bug now lives in new code, tests, and callers.

# 6. Break the loop with a test derived from the contract, not from the bug
@pytest.mark.parametrize("s", ["a,b,", ",a,b", "a,,b", " a , b ", ""])
def test_no_empty_fields(s):
    assert "" not in parse(s)   # red: steps 2–5 never saw these cases
# test_leading_comma_keeps_empty_field contradicts the contract: remove it.

# 7. Fix against the contract
def parse(s):
    return [p for p in (p.strip() for p in s.split(",")) if p]

def load_row(line):
    return parse(line)          # workaround no longer needed
# green; the bug case is now one row in its class
</example>

### 2. Tautological tests

A **tautological** test cannot fail while the code runs. Forms:

- The expected value is computed with the code's own logic.
- The test asserts a mock returns what the test told it to.
- The test asserts the code's internal calls.
- The assertion holds for any result: no assertion, `assert True`, `is not None` on a value that is never `None`.
- A snapshot or golden file generated from current output, never checked by hand.

Write expected values by hand from the contract. Prove each test can fail: break the code or run mutation testing.

### 3. Fake data

Every test value is either contract or filler. Contract values are what the code checks or transforms. Keep them exact.

Make filler obviously fake so contract values stand out.

Fake means a placeholder: `"foo"`, `1`, `example.test`. Fix filler that varies on its own, such as time and randomness.

### 4. Patchwork suites

A **patchwork** suite grows one test per edit. Signs: gaps (aspects with no test), overlaps (several tests on one aspect), tests named after changes instead of behaviour, tests ordered by when they were added.

Build the suite bottom-up from contracts:

- One test checks one contract aspect.
- One group of tests covers one unit's whole contract.
- The suite covers a larger surface: class, module, package, public API, service.

Name each test after the aspect it checks. Merge overlaps into one parametrized test. Fill gaps. Order tests by the contract.
