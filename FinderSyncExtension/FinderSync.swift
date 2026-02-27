import Cocoa
import FinderSync

@objc(FinderSync)
class FinderSync: FIFinderSync {
    
    override init() {
        super.init()
        
        // Monitor the entire filesystem so menu appears everywhere in Finder
        // Note: NSHomeDirectory() returns sandbox container path, not real home
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }
    
    // MARK: - Menu
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "RightClick")
        
        let copyItem = NSMenuItem(title: "复制路径", action: #selector(copyPath(_:)), keyEquivalent: "")
        copyItem.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: nil)
        menu.addItem(copyItem)
        
        let terminalItem = NSMenuItem(title: "在终端中打开", action: #selector(openTerminal(_:)), keyEquivalent: "")
        terminalItem.image = NSImage(systemSymbolName: "terminal", accessibilityDescription: nil)
        menu.addItem(terminalItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let newFileItem = NSMenuItem(title: "新建文件", action: nil, keyEquivalent: "")
        newFileItem.image = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: nil)
        let submenu = NSMenu()
        submenu.addItem(NSMenuItem(title: "文本文件 (.txt)", action: #selector(newTxt(_:)), keyEquivalent: ""))
        submenu.addItem(NSMenuItem(title: "Markdown (.md)", action: #selector(newMd(_:)), keyEquivalent: ""))
        submenu.addItem(NSMenuItem(title: "JSON (.json)", action: #selector(newJson(_:)), keyEquivalent: ""))
        submenu.addItem(NSMenuItem(title: "Python (.py)", action: #selector(newPy(_:)), keyEquivalent: ""))
        submenu.addItem(NSMenuItem(title: "Shell (.sh)", action: #selector(newSh(_:)), keyEquivalent: ""))
        newFileItem.submenu = submenu
        menu.addItem(newFileItem)
        
        return menu
    }
    
    // MARK: - Copy Path
    
    @objc func copyPath(_ sender: AnyObject?) {
        guard let items = FIFinderSyncController.default().selectedItemURLs(), !items.isEmpty else {
            if let target = FIFinderSyncController.default().targetedURL() {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(target.path, forType: .string)
            }
            return
        }
        let paths = items.map { $0.path }.joined(separator: "\n")
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(paths, forType: .string)
    }
    
    // MARK: - Open Terminal
    
    @objc func openTerminal(_ sender: AnyObject?) {
        var dir: URL?
        if let items = FIFinderSyncController.default().selectedItemURLs(), let first = items.first {
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: first.path, isDirectory: &isDir), isDir.boolValue {
                dir = first
            } else {
                dir = first.deletingLastPathComponent()
            }
        } else {
            dir = FIFinderSyncController.default().targetedURL()
        }
        guard let targetDir = dir else { return }
        
        let path = targetDir.path.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
        let src = "tell application \"Terminal\"\nactivate\ndo script \"cd \\\"\(path)\\\"\"\nend tell"
        if let script = NSAppleScript(source: src) {
            var err: NSDictionary?
            script.executeAndReturnError(&err)
        }
    }
    
    // MARK: - New File
    
    @objc func newTxt(_ sender: AnyObject?) { createFile(ext: "txt") }
    @objc func newMd(_ sender: AnyObject?) { createFile(ext: "md", content: "# \n") }
    @objc func newJson(_ sender: AnyObject?) { createFile(ext: "json", content: "{\n    \n}\n") }
    @objc func newPy(_ sender: AnyObject?) { createFile(ext: "py", content: "#!/usr/bin/env python3\n") }
    @objc func newSh(_ sender: AnyObject?) { createFile(ext: "sh", content: "#!/bin/bash\n") }
    
    private func createFile(ext: String, content: String = "") {
        guard let target = FIFinderSyncController.default().targetedURL() else { return }
        
        var name = "新建文件.\(ext)"
        var counter = 1
        while FileManager.default.fileExists(atPath: target.appendingPathComponent(name).path) {
            name = "新建文件 \(counter).\(ext)"
            counter += 1
        }
        
        let fileURL = target.appendingPathComponent(name)
        try? content.write(to: fileURL, atomically: true, encoding: .utf8)
        NSWorkspace.shared.selectFile(fileURL.path, inFileViewerRootedAtPath: target.path)
    }
}
