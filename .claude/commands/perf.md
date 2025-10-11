---
description: Check Flutter app performance and suggest optimizations
---

Performance analysis:

1. **Code Analysis**
   - Search for missing `const` constructors
   - Find widgets without keys in lists
   - Identify large build methods (>100 lines)
   - Look for setState in loops
   - Check for unnecessary rebuilds

2. **Image Optimization**
   - Find unoptimized images in assets/
   - Check for missing cached network images
   - Verify image sizes are appropriate

3. **State Management**
   - Check for inefficient provider usage
   - Look for unnecessary listeners
   - Verify proper dispose implementations

4. **Build Optimization**
   - Check for expensive operations in build()
   - Identify candidates for RepaintBoundary
   - Find ListView without .builder

5. **Suggestions**
   - List specific issues found
   - Provide code examples for fixes
   - Prioritize by impact (high/medium/low)

6. **DevTools Reminder**
   - Suggest running app with: `flutter run --profile`
   - Recommend using Flutter DevTools for deeper analysis