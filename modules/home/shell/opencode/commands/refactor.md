Safely refactor existing code while preserving behavior and following conventions.

This workflow uses analysis and verification to ensure refactoring doesn't introduce subtle bugs.

## Workflow

### Phase 1: Analysis
Before touching any code:
- Understand the current code's behavior and dependencies
- Identify all consumers, call sites, and external interfaces
- Flag hidden coupling, side effects, or stateful dependencies
- Determine if the refactoring is purely structural or affects behavior
- Assess risk: can this be done in one change, or should it be staged?

### Phase 2: Plan
Produce a concrete refactoring plan:
- List every file that will change
- For each file, describe the exact transformation
- Identify any intermediate states that must build or test successfully
- Note which tests or checks to run after each stage

Wait for user confirmation before proceeding.

### Phase 3: Execute
- Apply the planned changes one logical step at a time
- Verify each intermediate state compiles, evaluates, or passes tests
- Run formatters and linters on every modified file
- Never combine refactoring with unrelated changes (no "while I'm here...")

### Phase 4: Verify
- Confirm behavior preservation: no logic changes, only structure
- Check for missed call sites, broken references, or incomplete migrations
- Verify conventions are still followed after the restructure
- Run the full test suite or equivalent validation for affected areas

## Safety Rules

- Refactoring is not the time to fix bugs or add features — do those separately
- If a file is moved, update all references in the same commit
- Prefer small, incremental refactors over large rewrites
- If a refactor spans more than a handful of files, consider breaking it into multiple passes
- Verify the project still builds, evaluates, or tests successfully after each incremental change
