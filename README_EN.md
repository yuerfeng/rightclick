# RightClick

[中文](README.md)

A macOS Finder context menu enhancement tool that adds practical right-click menu features to Finder via a Finder Sync Extension.

## Features

- **Copy Path** - Quickly copy the full path of selected files/folders to the clipboard, with multi-selection support
- **Open in Terminal** - Open Terminal at the current directory or the directory of the selected folder
- **New File** - Quickly create common file types in the current directory:
  - Text file (.txt)
  - Markdown (.md)
  - JSON (.json)
  - Python (.py)
  - Shell (.sh)

## Installation

### From DMG

1. Download the latest `RightClick.dmg`
2. Double-click to open the DMG file
3. Drag `rightClick.app` into the `Applications` folder
4. Launch the app

### Build from Source

Requires [XcodeGen](https://github.com/yonaskolb/XcodeGen) and Xcode.

```bash
git clone git@github.com:yuerfeng/rightclick.git
cd rightclick
xcodegen generate
open rightClick.xcodeproj
```

Select the `rightClick` scheme in Xcode, then build and run.

## Enable the Extension

After the first installation, you need to manually enable the Finder extension:

1. Open **System Settings** > **Privacy & Security** > **Extensions** > **Added Extensions**
2. Find **rightClick** and check **FinderSyncExtension**
3. Restart Finder (you can do this from the tray icon, or Option-right-click the Finder icon in the Dock and select "Relaunch")

## Usage

Once the extension is enabled, right-click on files, folders, or empty space in Finder to see the new menu items.

The app displays a tray icon in the menu bar with the following options:

- **Show Window** - Open the main interface
- **Extension Settings...** - Jump to system extension settings
- **Quit RightClick** - Quit the application

## System Requirements

- macOS 12.0 (Monterey) or later

## Tech Stack

- Swift / SwiftUI
- Finder Sync Extension (FIFinderSync)
- XcodeGen for project management

## License

MIT License
