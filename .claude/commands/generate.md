---
description: Run build_runner to generate code (freezed, json_serializable, etc.)
---

Run code generation:

1. Display message: "🔄 Running build_runner..."
2. Execute: `dart run build_runner build --delete-conflicting-outputs`
3. Check for errors in output
4. If successful:
   - Display: "✅ Code generation completed"
   - List generated files (*.g.dart, *.freezed.dart)
5. If errors:
   - Display error details
   - Suggest fixes for common issues
6. Remind to verify generated files compile correctly