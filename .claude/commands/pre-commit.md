---
description: Run all pre-commit quality checks before committing code
---

Execute pre-commit verification:

1. **Format Check**
   - Run: `dart format . --set-exit-if-changed`
   - If unformatted files found: format them with `dart format .`

2. **Static Analysis**
   - Run: `flutter analyze --no-fatal-infos`
   - Display any warnings or errors
   - Fail if errors found

3. **Tests**
   - Run: `flutter test --coverage`
   - Display test results summary
   - Show coverage percentage
   - Fail if tests fail

4. **Dependency Check**
   - Run: `flutter pub outdated`
   - List packages with major updates available

5. **Security Scan**
   - Search for hardcoded secrets patterns in staged files
   - Check for TODO/FIXME in committed code
   - Warn if found

6. **Final Summary**
   - If all pass: "✅ All pre-commit checks passed!"
   - If failures: List each failure with suggested fix