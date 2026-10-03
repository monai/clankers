---
name: contract-tests
description: Scrutinize tests against the contract of the code under test and rewrite the ones that fail. Use when writing, reviewing, or refactoring tests, after adding a regression test for a bug fix, or when a test suite has grown by patches.
---

# Contract tests

A **contract** is what a unit promises its callers for all valid inputs: outputs, errors, side effects, invariants. A test checks a contract. A test that checks anything else locks in history or implementation. Find those tests and replace them with contract tests.

## Process

1. Read the source. For each unit (function, method, endpoint, CLI command, integration surface), write down its contract. Take it from types, docs, specs, issues, and callers. Read the code to find each unit and what it does, but settle what it should do from those other sources. Where no source settles a contract aspect, leave its tests as they are and record it as an open question.
2. Read the tests. Map each test to the contract aspect it checks.
3. Run the tools the project has: the test suite, line and branch coverage, and mutation testing if available. Find out which tests came in with bug fixes.
4. Check every test against the four rules below. Record each finding with file, line, and rule.
5. Delete the tests that fail a rule, write contract tests in their place, and run the suite.

Done when every test maps to one contract aspect or an open question, every settled contract aspect has a test, and the suite is green. End with a report: findings, changes, open questions.

## Rules

### 1. Bug-shaped tests

A **bug-shaped** test is a regression test written from a bug report: its input is the one input that broke, its assertion is the one symptom. The fix is then written to pass it, so test and fix share the same narrow view of the bug. Both stay green while the same class of bug lives on in inputs neither looks at.

Signs: a test named after an issue or a symptom, one hard-coded input, a test added in the same commit as a fix.

For each one, name the rule the bug broke and the full class of inputs that rule covers. Replace the test with a contract test that states the rule and covers the class. Keep the original bug input as one case in it.

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

The test in step 2 is bug-shaped. Step 5 is its replacement.

### 2. Tautological tests

A **tautological** test cannot fail while the code runs. Forms:

- The expected value is computed with the same logic as the code under test.
- The test asserts that a mock returns what the test told it to return.
- The test asserts which internal calls the code makes, mirroring the implementation.
- The assertion holds for any result: no assertion, `assert True`, `is not None` on a value that is never `None`.
- A snapshot or golden file generated from current output and never checked by hand.

Write expected values by hand, from the contract. A test proves its worth by failing: break the code on purpose, or run mutation testing, and see the test go red.

### 3. Fake data

Every value in a test is either part of the contract or filler. Contract values are the ones the code checks or transforms: delimiters, boundaries, limits, formats, special cases. Keep them exact.

Make all filler deliberately and obviously fake, so a reader sees at once which values matter. A realistic value makes the reader assume it matters, and it may be real data that leaked in.

- Strings and names: `"foo"`, `"user-a"`, `"Fake Name"`
- Numbers: `1`, `2`, `100`, never a plausible `37.49`
- IDs, keys, tokens, hashes: `"id-1"`, `"key-fake"`, `"0000…"`
- Emails, URLs, hosts: reserved names such as `a@example.test`, `https://example.invalid/x`
- Dates and times: `2000-01-01T00:00:00Z`, a fixed clock, never the current time
- Paths: `/fake/dir/file.txt`
- Money, addresses, phone numbers: round numbers, `1 Fake St`, `555-0100`
- Randomness: a fixed seed

### 4. Patchwork suites

A **patchwork** suite grows by one test per edit. Each test may be correct, but together they read as a pile of patches. Signs: gaps (contract aspects with no test), overlaps (several tests check the same aspect), tests named after changes rather than behaviour, tests ordered by when they were added.

Build the suite bottom-up from contracts:

- One test checks one contract aspect.
- One group of tests covers the whole contract of one unit: function, method, endpoint, CLI command, integration surface.
- The suite covers a larger surface completely: class, module, package, public API, service.

Name each test after the aspect it checks. Merge overlaps into one parametrized test. Fill gaps. Order tests by the contract.
