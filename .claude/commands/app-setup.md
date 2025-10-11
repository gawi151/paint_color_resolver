---
description: Initialize Flutter project structure with best practices
---

Set up Flutter project structure:

1. Verify Flutter installation: `flutter doctor -v`
2. Check current directory structure
3. Create missing core directories:
   - lib/features/
   - lib/shared/widgets/
   - lib/shared/utils/
   - lib/core/theme/
   - lib/core/constants/
   - lib/core/config/
   - test/features/
   - test/shared/
4. Create base theme files:
   - lib/core/theme/app_theme.dart
   - lib/core/theme/app_colors.dart
   - lib/core/theme/app_text_styles.dart
5. Create constants file: lib/core/constants/app_constants.dart
6. Verify pubspec.yaml exists
7. Run `flutter pub get`
8. Display project structure summary