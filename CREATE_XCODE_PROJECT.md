# Creating the Xcode Project

## Step-by-Step Instructions

### 1. Open Xcode and Create New Project

1. Launch **Xcode**
2. Select **File → New → Project** (or press `Cmd+Shift+N`)
3. Choose **iOS** tab
4. Select **App** template
5. Click **Next**

### 2. Configure Project Settings

Fill in the project details:
- **Product Name:** `SunSar`
- **Team:** Select your development team (or leave None for simulator only)
- **Organization Identifier:** `com.yourname` (e.g., `com.mathursunit`)
- **Bundle Identifier:** Will auto-generate as `com.yourname.SunSar`
- **Interface:** `SwiftUI`
- **Language:** `Swift`
- **Storage:** `None` (we'll use UserDefaults)
- **Minimum iOS:** `15.0` or later

6. Click **Next**
7. Choose where to save the project (you can save it in a temporary location)
8. Click **Create**

### 3. Replace Default Files

1. **Delete** the default `ContentView.swift` that Xcode created
2. **Delete** the default `SunSarApp.swift` (if it exists)

### 4. Add All Source Files

1. In Xcode, right-click on the **SunSar** folder in the Project Navigator
2. Select **Add Files to "SunSar"...**
3. Navigate to the cloned repository folder
4. Select ALL the following folders and files:
   - `SunSarApp.swift`
   - `Info.plist`
   - `Data/` folder
   - `Models/` folder
   - `Views/` folder
   - `ViewModels/` folder
   - `Managers/` folder
   - `Utilities/` folder
5. Make sure these options are checked:
   - ✅ **Copy items if needed**
   - ✅ **Create groups** (not folder references)
   - ✅ **Add to targets: SunSar**
6. Click **Add**

### 5. Configure Info.plist

1. In Xcode, select the **SunSar** project in the navigator
2. Select the **SunSar** target
3. Go to the **Info** tab
4. The `Info.plist` should be automatically recognized
5. If needed, verify the bundle identifier and version

### 6. Update Build Settings (if needed)

1. Select the **SunSar** target
2. Go to **Build Settings**
3. Verify:
   - **iOS Deployment Target:** 15.0 or higher
   - **Swift Language Version:** Swift 5

### 7. Build and Run

1. Select a simulator (e.g., iPhone 15 Pro)
2. Press **Cmd+R** to build and run
3. The app should launch successfully!

## Alternative: Quick Setup Script

If you prefer, you can also:

1. Clone the repo: `git clone https://github.com/mathursunit/iFWW.git`
2. Open Xcode
3. Create new project as above
4. Drag and drop all the Swift files from the cloned repo into Xcode
5. Make sure "Copy items if needed" is checked

## Troubleshooting

### "Cannot find 'WordListData' in scope"
- Make sure `Data/WordListData.swift` is added to the target
- Check Target Membership in File Inspector

### "Cannot find type 'GameState'"
- Make sure all files in `Models/` folder are added to the target

### Build Errors
- Clean build folder: **Product → Clean Build Folder** (Cmd+Shift+K)
- Delete DerivedData if needed
- Rebuild: **Product → Build** (Cmd+B)

## Project Structure in Xcode

After adding files, your Xcode project should look like:

```
SunSar
├── SunSarApp.swift
├── Info.plist
├── Data
│   └── WordListData.swift
├── Models
│   ├── GameState.swift
│   └── WordEntry.swift
├── Views
│   ├── ContentView.swift
│   ├── GameGridView.swift
│   ├── KeyboardView.swift
│   ├── HeaderView.swift
│   ├── StatsModalView.swift
│   ├── EndGameModalView.swift
│   ├── ToastView.swift
│   └── ConfettiView.swift
├── ViewModels
│   └── GameViewModel.swift
├── Managers
│   ├── WordListManager.swift
│   └── StorageManager.swift
└── Utilities
    └── AppColors.swift
```

That's it! Your Xcode project is ready to build and run.

