# Xcode Build Error Fixes

## Error: "Undefined symbol: _main"

This error means Xcode can't find the app entry point. Here's how to fix it:

### Solution 1: Verify File Target Membership

1. In Xcode, select `SunSarApp.swift` in the Project Navigator
2. Open the **File Inspector** (right panel, first tab)
3. Under **Target Membership**, make sure **SunSar** is checked ✅
4. If it's not checked, check it
5. Clean and rebuild: **Product → Clean Build Folder** (Cmd+Shift+K), then **Product → Build** (Cmd+B)

### Solution 2: Check for Multiple @main Attributes

1. In Xcode, press **Cmd+Shift+F** to open Find
2. Search for `@main`
3. Make sure ONLY `SunSarApp.swift` has `@main`
4. If any other file has `@main`, remove it (only one file should have it)

### Solution 3: Verify File is in Compile Sources

1. Select the **SunSar** project in the navigator
2. Select the **SunSar** target
3. Go to **Build Phases** tab
4. Expand **Compile Sources**
5. Make sure `SunSarApp.swift` is listed
6. If it's missing, click **+** and add it

### Solution 4: Check File Location

1. Make sure `SunSarApp.swift` is in the root of your project (not in a subfolder)
2. If it's in a subfolder, move it to the root level

## Warning: "Could not find or use auto-linked framework 'UIUtilities'"

This warning is usually harmless and can be ignored. However, to suppress it:

1. Select the **SunSar** target
2. Go to **Build Settings**
3. Search for "Other Linker Flags"
4. Add `-weak_framework UIUtilities` (if you want to suppress the warning)

**Note:** This warning typically appears in Xcode 15+ and doesn't affect functionality.

## Warning: "Could not parse or use implicit file..."

This is usually related to the UIUtilities warning above and can be safely ignored.

## Complete Fix Checklist

1. ✅ Fix syntax errors (extra braces, etc.)
2. ✅ Verify `SunSarApp.swift` has `@main` attribute
3. ✅ Check `SunSarApp.swift` is added to target
4. ✅ Verify all Swift files are in "Compile Sources"
5. ✅ Clean build folder (Cmd+Shift+K)
6. ✅ Delete DerivedData (optional but recommended)
7. ✅ Rebuild (Cmd+B)

## Delete DerivedData (if issues persist)

1. In Xcode, go to **Xcode → Settings → Locations**
2. Click the arrow next to **Derived Data** path
3. Delete the folder for your project
4. Rebuild

## Quick Fix Command

If you have terminal access in Xcode:

```bash
# Clean build
rm -rf ~/Library/Developer/Xcode/DerivedData/SunSar-*

# Then rebuild in Xcode
```

## Verify Project Structure

Your Xcode project should have:

```
SunSar (Project)
└── SunSar (Target)
    ├── SunSarApp.swift ← Must have @main
    ├── Info.plist
    └── [All other Swift files]
```

Make sure `SunSarApp.swift` is at the root level of the target, not nested in a group.

## Still Not Working?

1. **Create a new Xcode project** and add files fresh
2. Make sure you're using **Xcode 14+** (for iOS 15+ support)
3. Check **iOS Deployment Target** is set to 15.0 or higher
4. Verify **Swift Language Version** is Swift 5

