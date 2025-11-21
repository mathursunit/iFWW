# SunSar iOS App

Native iOS version of the SunSar word game, converted from the web app.

## Setup Instructions

### 1. Create Xcode Project

1. Open Xcode
2. Create a new project:
   - Choose "App" template
   - Product Name: `SunSar`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Minimum iOS version: `iOS 15.0` or later

### 2. Add Files to Project

Add all the Swift files to your Xcode project:

**Models:**
- `Models/GameState.swift`
- `Models/WordEntry.swift`

**ViewModels:**
- `ViewModels/GameViewModel.swift`

**Views:**
- `Views/ContentView.swift`
- `Views/GameGridView.swift`
- `Views/KeyboardView.swift`
- `Views/HeaderView.swift`
- `Views/StatsModalView.swift`
- `Views/EndGameModalView.swift`
- `Views/ToastView.swift`
- `Views/ConfettiView.swift`

**Managers:**
- `Managers/WordListManager.swift`
- `Managers/StorageManager.swift`

**Utilities:**
- `Utilities/AppColors.swift`

**Data:**
- `Data/WordListData.swift`

**App Entry:**
- `SunSarApp.swift`

### 3. Configure Project Settings

1. In Xcode, select your project in the navigator
2. Go to "Signing & Capabilities"
3. Set your Team and Bundle Identifier
4. Ensure "Info.plist" is included in the project

### 4. Add Custom Font (Optional)

The app uses "Fredoka One" font. To add it:

1. Download the font from Google Fonts
2. Add the font file to your project
3. Add the font to Info.plist under "Fonts provided by application"
4. The app will fall back to system fonts if the custom font is not available

### 5. Build and Run

1. Select a simulator or connected device
2. Press Cmd+R to build and run

## Features

- ✅ Complete word game functionality matching the web app
- ✅ Tile flip animations
- ✅ Keyboard with status indicators
- ✅ Statistics tracking
- ✅ Share results functionality
- ✅ Confetti animation on win
- ✅ Toast notifications
- ✅ Hint system
- ✅ Daily word rotation (8 AM cutoff)
- ✅ Persistent game state and statistics

## Color Matching

All colors have been carefully matched to the web app:
- Background: `#0F172A`
- Panel Background: `#111827`
- Correct: `#8B5CF6` (Purple)
- Present: `#2DD4BF` (Teal)
- Absent: `#4B5563` (Gray)

## Notes

- The app uses UserDefaults for persistence
- Word list is embedded in `WordListData.swift`
- Game resets daily at 8 AM local time
- Supports both portrait and landscape orientations

