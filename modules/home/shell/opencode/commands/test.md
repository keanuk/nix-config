Generate tests for a function, module, or feature following project conventions.

Process:
1. Understand what is being tested: read the implementation and its dependencies
2. Identify the public interface and behavior contracts
3. Generate tests for:
   - Happy path (normal valid inputs)
   - Error paths (invalid inputs, failure modes)
   - Boundary conditions (empties, limits, edge cases)
   - Invariants (properties that must always hold)

Guidelines:
- Test behavior, not implementation details
- Use descriptive test names that explain the scenario
- Prefer parameterized/table-driven tests for multiple similar cases
- Mock only external dependencies, not internal logic
- Ensure tests are independent and can run in any order

After generating:
- Verify the tests compile/evaluate correctly
- Note if any test infrastructure (fixtures, helpers) needs to be created
- Flag any behavior that seems untestable or indicates a design issue
