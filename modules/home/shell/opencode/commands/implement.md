Implement a new feature using a structured multi-phase workflow.

This workflow separates design from implementation from review, producing higher-quality changes than doing everything in one shot.

## Workflow

### Phase 1: Design
Before writing any code:
- Analyze the requirements and constraints
- Identify affected systems, modules, and interfaces
- Propose 2-3 implementation approaches with explicit tradeoffs
- Recommend the best approach for the current context
- Flag any blast radius beyond the immediate task

Wait for user confirmation of the chosen approach before proceeding.

### Phase 2: Implementation
- Implement the approved design with minimal, correct changes
- Follow the project's established conventions and style
- Run formatters and linters on every modified file
- Verify syntax and basic correctness
- Ensure new files are tracked by the version control system if required

### Phase 3: Review
- Check correctness: does the change do what the design specified?
- Check security: no hardcoded secrets, proper permissions, no injection risks
- Check scope: no unrelated changes snuck in
- Check conventions: follows the project's established patterns
- Check maintainability: the next person will understand this

If the review finds blocking issues, return to Phase 2 with specific feedback.

### Phase 4: Documentation (if needed)
Only if the change introduces:
- A workaround or temporary fix
- Non-obvious architectural implications
- Cross-cutting concerns affecting multiple modules
- New external dependencies or integration points

## Constraints

- Do not proceed from Phase 1 to Phase 2 without user confirmation
- Do not proceed from Phase 3 to completion if blocking issues were found
- Never skip the project's required linting or formatting steps
- Prefer editing existing files over creating new ones
- Make the minimal change that achieves the goal
- Keep refactoring out of feature implementation — do one thing at a time
