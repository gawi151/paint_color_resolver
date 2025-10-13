---
description: Run all pre-commit quality checks before committing code
---

Execute pre-commit verification:

1. **Format Check**
   - Run: `dart format . --set-exit-if-changed`
   - If unformatted files found: format them with `dart format .`

2. **Static Analysis**
   - Run: `flutter analyze --fatal-infos`
   - Fail if anything found

3. **Static Analysis - Custom lints**
   - Run: `dart run custom_lint`
   - Fail if anything found

4. **Tests**
   - Run: `flutter test --coverage`
   - Display test results summary
   - Show coverage percentage
   - Fail if tests fail

5. **Dependency Check**
   - Run: `flutter pub outdated`
   - List packages with major updates available

6. **Security Scan**
   - Search for hardcoded secrets patterns in staged files
   - Check for TODO/FIXME in committed code
   - Warn if found

7. **Final Summary**
   - If all pass: "✅ All pre-commit checks passed!"
   - If failures: List each failure with suggested fix