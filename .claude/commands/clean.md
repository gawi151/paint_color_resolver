---
description: Clean Flutter project and rebuild dependencies
---

Clean and rebuild Flutter project:

1. Display: "🧹 Cleaning Flutter project..."

2. Execute cleaning:
   - `flutter clean`
   - Remove iOS Pods: `rm -rf ios/Pods ios/Podfile.lock`
   - Remove Android build: `rm -rf android/.gradle android/build`
   - Clear pub cache for project: `dart pub cache clean`

3. Display: "📦 Getting dependencies..."
   - `flutter pub get`

4. For iOS projects:
   - Navigate to ios/: `cd ios`
   - Run: `pod install --repo-update`
   - Return: `cd ..`

5. Display: "🏗️ Running code generation..."
   - `dart run build_runner build --delete-conflicting-outputs`

6. Display: "✅ Clean build completed!"
7. Suggest: "Run `flutter run` to verify everything works"