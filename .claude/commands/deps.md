---
description: Manage Flutter dependencies intelligently
---

Manage dependencies:

Show options:
1. Add new dependency
2. Remove dependency  
3. Update dependencies
4. Check for outdated packages
5. Audit dependency issues

Based on user choice:

**Add Dependency:**
- Ask: "Package name?"
- Ask: "Dev dependency? (y/n)"
- Run: `flutter pub add [--dev] $PACKAGE`
- Check for conflicts
- Run: `flutter pub get`
- If native: remind to run `pod install` for iOS

**Remove Dependency:**
- Ask: "Package name?"
- Run: `flutter pub remove $PACKAGE`
- Clean: `flutter clean && flutter pub get`

**Update Dependencies:**
- Show: `flutter pub outdated`
- Ask: "Update all minor? (y/n)"
- If yes: `flutter pub upgrade`
- If no: Ask which to upgrade
- Test after: Suggest running `/pre-commit`

**Check Outdated:**
- Run: `flutter pub outdated`
- Highlight packages with major updates
- Warn about breaking changes

**Audit Issues:**
- Check for over-promoted dependencies
- Check for unused packages
- Suggest fixes