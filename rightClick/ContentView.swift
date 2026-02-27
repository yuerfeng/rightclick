import SwiftUI

struct ContentView: View {
    @State private var monitoredPaths: [String] = [NSHomeDirectory()]
    @State private var newPath: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "contextualmenu.and.cursorarrow")
                    .font(.system(size: 48))
                    .foregroundColor(.accentColor)
                
                Text("RightClick")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Finder 右键菜单扩展")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            
            Divider()
            
            // Extension Status
            VStack(spacing: 12) {
                Text("请在系统设置中启用扩展")
                    .font(.headline)
                
                Button("打开系统设置") {
                    openSystemPreferences()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            // Monitored Paths
            VStack(alignment: .leading, spacing: 12) {
                Text("监控目录")
                    .font(.headline)
                
                Text("扩展只在这些目录下的右键菜单中生效")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                List {
                    ForEach(monitoredPaths, id: \.self) { path in
                        HStack {
                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)
                            Text(path)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                            Button(action: {
                                removePath(path)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(height: 120)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(6)
                
                HStack {
                    Button("添加目录...") {
                        selectFolder()
                    }
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            // Features
            VStack(alignment: .leading, spacing: 8) {
                Text("功能列表")
                    .font(.headline)
                
                FeatureRow(icon: "doc.on.clipboard", title: "复制路径", description: "复制文件/文件夹的完整路径")
                FeatureRow(icon: "terminal", title: "打开终端", description: "在当前目录打开 Terminal")
                FeatureRow(icon: "doc.badge.plus", title: "新建文件", description: "快速创建 txt, md 等文件")
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .frame(width: 400, height: 600)
        .onAppear {
            loadMonitoredPaths()
        }
    }
    
    private func openSystemPreferences() {
        // Open System Preferences > Extensions
        if let url = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences") {
            NSWorkspace.shared.open(url)
        }
    }
    
    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "选择要监控的目录"
        
        if panel.runModal() == .OK, let url = panel.url {
            let path = url.path
            if !monitoredPaths.contains(path) {
                monitoredPaths.append(path)
                saveMonitoredPaths()
            }
        }
    }
    
    private func removePath(_ path: String) {
        monitoredPaths.removeAll { $0 == path }
        if monitoredPaths.isEmpty {
            monitoredPaths = [NSHomeDirectory()]
        }
        saveMonitoredPaths()
    }
    
    private func saveMonitoredPaths() {
        let defaults = UserDefaults(suiteName: "group.com.rightclick.shared")
        defaults?.set(monitoredPaths, forKey: "monitoredPaths")
        defaults?.synchronize()
    }
    
    private func loadMonitoredPaths() {
        let defaults = UserDefaults(suiteName: "group.com.rightclick.shared")
        if let paths = defaults?.stringArray(forKey: "monitoredPaths"), !paths.isEmpty {
            monitoredPaths = paths
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
