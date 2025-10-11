---
description: Generate comprehensive tests for a file
---

Generate tests for: $ARGUMENTS

Create test file for: $ARGUMENTS

1. Analyze the source file at: $ARGUMENTS
2. Determine test type:
   - Unit test for business logic
   - Widget test for UI components
   - Integration test for flows

3. Create test file in mirror structure under test/

4. Generate tests covering:
   - All public methods/functions
   - Edge cases and error conditions
   - Null safety scenarios
   - State changes (for stateful widgets)
   - User interactions (for widgets)
   - Mock dependencies using mockito

5. Include proper test structure:
   - Group blocks for organization
   - setUp and tearDown if needed
   - Clear test descriptions
   - Arrange-Act-Assert pattern

6. Display test file location
7. Remind to run: `flutter test $TEST_FILE_PATH`