# SunSar iOS - Project Setup Guide

## Quick Start

1. **Open Xcode** and create a new project:
   - Template: App
   - Product Name: `SunSar`
   - Interface: SwiftUI
   - Language: Swift
   - Minimum iOS: 15.0

2. **Replace the default files** with the provided Swift files in this directory

3. **Add all files** to your Xcode project:
   - Drag and drop all folders (Models, Views, ViewModels, etc.) into Xcode
   - Make sure "Copy items if needed" is checked
   - Add to target: SunSar

4. **Build and Run** (Cmd+R)

## File Structure

```
SunSar/
├── SunSarApp.swift          # App entry point
├── Info.plist               # App configuration
├── Models/
│   ├── GameState.swift
│   └── WordEntry.swift
├── ViewModels/
│   └── GameViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── GameGridView.swift
│   ├── KeyboardView.swift
│   ├── HeaderView.swift
│   ├── StatsModalView.swift
│   ├── EndGameModalView.swift
│   ├── ToastView.swift
│   └── ConfettiView.swift
├── Managers/
│   ├── WordListManager.swift
│   └── StorageManager.swift
├── Utilities/
│   └── AppColors.swift
└── Data/
    └── WordListData.swift   # Generated from extract_wordlist.ps1
```

## Important Notes

- The word list is automatically extracted from `index.html` when you run `extract_wordlist.ps1`
- All colors match the web app exactly
- Animations match the web app timing (550ms flip, etc.)
- The app uses UserDefaults for persistence
- Game resets daily at 8 AM local time

## Custom Font (Optional)

To use the Fredoka One font:
1. Download from Google Fonts
2. Add to project
3. Add to Info.plist under "Fonts provided by application"
4. The app will work without it (uses system font fallback)

## Testing

- Test on iOS 15.0+ simulators and devices
- Verify tile animations work correctly
- Check that statistics persist between app launches
- Verify daily word rotation works correctly

