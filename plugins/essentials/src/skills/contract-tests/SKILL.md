---
name: contract-tests
description: Rewrite tests against the code's contract.
disable-model-invocation: true
---

# Contract tests

A **contract** is what a unit promises its callers for all valid inputs: outputs, errors, side effects, invariants. A test that checks anything else locks in history or implementation. Replace those tests with contract tests.

## Process

1. Write down the contract of each unit (function, method, endpoint, CLI command, integration surface). Read the code to learn what a unit does; take what it should do from types, docs, specs, issues, and callers. Where no source settles a contract aspect, leave its tests as they are and record an open question.
2. Map each test to the contract aspect it checks.
3. Run the project's tools: tests, line and branch coverage, mutation testing if available. Find which tests came in with bug fixes.
4. Check every test against the rules below. Record each finding with file, line, and rule.
5. Replace tests that break a rule with contract tests. Run the suite.

Done when every test maps to one contract aspect or open question, every settled aspect has a test, and the suite is green. End with this report, one row per item, and "None" for an empty section:

<report>
## Findings
| Test | Rule | Problem |
|---|---|---|
| `file:line` `test_name` | bug-shaped, tautological, fake data, or patchwork | one sentence |

## Changes
| Removed | Added | Contract aspect |
|---|---|---|
| `test_name` or — | `test_name` or — | one sentence |

## Open questions
| Unit | Aspect | What is unclear | Tests kept |
|---|---|---|---|
| `file:unit` | one phrase | one sentence | `test_name`, … |
</report>

## Rules

### 1. Bug-shaped tests

A **bug-shaped** test is a regression test written from a bug report: one input that broke, one symptom asserted. The fix is written to pass it, so both share the same narrow view.

Signs: named after an issue or symptom, one hard-coded input, added in the same commit as a fix.

Name the rule the bug broke and the inputs that rule covers. Replace the test with a contract test that covers them, keeping the bug input as one case.

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

# 4. The shared blind spot. Code and test both carry the bug's framing
parse(",a,b")   # ["", "a", "b"]   still broken
parse("a,,b")   # ["a", "", "b"]   still broken
# The suite is green because the test only checks what the fix covers.

# 5. Break the loop with a test derived from the contract, not from the bug
@pytest.mark.parametrize("s", ["a,b,", ",a,b", "a,,b", ""])
def test_no_empty_fields(s):
    assert "" not in parse(s)   # red: steps 2–3 never saw these cases

# 6. Fix against the contract
def parse(s):
    return [p for p in s.split(",") if p]
# green, and the original bug case is now one row in the class it belongs to
</example>

### 2. Tautological tests

A **tautological** test cannot fail while the code runs. Forms:

- The expected value is computed with the code's own logic.
- The test asserts a mock returns what the test told it to.
- The test asserts the code's internal calls.
- The assertion holds for any result: no assertion, `assert True`, `is not None` on a value that is never `None`.
- A snapshot or golden file generated from current output, never checked by hand.

Write expected values by hand from the contract. Prove each test can fail: break the code or run mutation testing, and see it go red.

### 3. Fake data

Every test value is either contract or filler. Contract values are what the code checks or transforms. Keep them exact.

Make filler obviously fake, so the values that matter stand out.

Fake means a placeholder: `"foo"`, `1`, `example.test`. Fix filler that varies on its own, such as time and randomness.

### 4. Patchwork suites

A **patchwork** suite grows one test per edit. Signs: gaps (aspects with no test), overlaps (several tests on one aspect), tests named after changes instead of behaviour, tests ordered by when they were added.

Build the suite bottom-up from contracts:

- One test checks one contract aspect.
- One group of tests covers one unit's whole contract.
- The suite fully covers a larger surface: class, module, package, public API, service.

Name each test after the aspect it checks. Merge overlaps into one parametrized test. Fill gaps. Order tests by the contract.
