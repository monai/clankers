---
name: caretaker
description: Fixes source code that was built around one bug fix, then rewrites tests to match the contract.
disable-model-invocation: true
---

# Caretaker

A **contract** is what a unit promises its callers for all valid inputs: outputs, errors, side effects, invariants. Each item is a **promise**. A **premise** is a narrow rule that code or a test follows instead of a promise. It usually comes from one bug report.

By default, use **report-only** mode and change nothing. Use **act mode** only when the user asks for changes. In act mode, do all steps in one run.

## Process

1. Write the contract of each unit. Take promises from types, docs, specs, issues, and callers. Do not take them from the unit's own code, its tests, or workarounds in callers.
2. Check the source and the tests against the principles below.
3. If nothing tells you what a promise is, the promise is **unclear**. Do not change anything for it. Report it.
4. In act mode, fix principle 1 in the source and the tests together. Then fix the tests for principles 2 to 4. Run the tests.

Report-only ends after step 3.

## Report

Report the source changes for principle 1 and the unclear promises. Do not report test changes. Write one entry for each broken or unclear promise. In report-only mode, the diff is a suggestion. In act mode, it is the change you made. Include every source file you changed. If there are none, say so in one line. Write markdown without the outer fence.

````markdown
### `<unit>` in `<path>`

**Promise.** <one sentence>

**Premise.** <one sentence>

**Breaks on.** `<input>` gives `<wrong output>`.

```diff
--- <path>
-<line before>
+<line after>
```
````

For an unclear promise, write this entry instead:

````markdown
### `<unit>` in `<path>`

**Unclear.** <the promise and what it could mean>
````

Example:

````markdown
### `parse` in `src/parse.py`

**Promise.** `parse` returns no empty fields.

**Premise.** Only a trailing empty field is dropped.

**Breaks on.** `",a,b"` gives `["", "a", "b"]`.

```diff
--- src/parse.py
-    parts = [p.strip() for p in s.split(",")]
-    return parts[:-1] if parts[-1] == "" else parts
+    return [p for p in (p.strip() for p in s.split(",")) if p]
--- src/rows.py
-    return [f for f in parse(line) if f]
+    return parse(line)
```
````

## Principles

### 1. Bug-shaped code

A **bug-shaped** test checks one input from one bug report. The fix is written to pass that test, so both follow the same premise. Later code treats the test as the contract and copies the premise into new code, tests, and callers. This is the worst case, because the test shapes the source.

Signs: a branch for one input or symptom; a test named after an issue or symptom; one hard-coded input; test and fix added in the same commit; later code that copies the same branch; callers that filter, retry, or patch the unit's output.

Fix the source and the tests together. Change the unit so it keeps the promise. Delete the special case and the workarounds in callers. Replace the bug-shaped test with a test of the promise. Keep the bug input as one case. Delete tests that lock in the premise.

```python
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
```

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

A **patchwork** suite grows one test per edit. Signs: gaps (promises with no test), overlaps (several tests on one promise), tests named after changes instead of behaviour, tests ordered by when they were added.

Build the suite bottom-up from contracts:

- One test checks one promise.
- One group of tests covers one unit's whole contract.
- The suite covers a larger surface: class, module, package, public API, service.

Name each test after the promise it checks. Merge overlaps into one parametrized test. Fill gaps. Order tests by the contract.
