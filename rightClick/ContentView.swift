import SwiftUI
import ServiceManagement

struct ContentView: View {
    @State private var launchAtLogin: Bool = false
    
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
                
                Button("打开扩展设置") {
                    openSystemPreferences()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            // Settings
            VStack(alignment: .leading, spacing: 12) {
                Text("设置")
                    .font(.headline)
                
                Toggle("开机自动启动", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { newValue in
                        setLaunchAtLogin(newValue)
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
        .frame(width: 400, height: 500)
        .onAppear {
            loadLaunchAtLogin()
        }
    }
    
    private func openSystemPreferences() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences") {
            NSWorkspace.shared.open(url)
        }
    }
    
    private func loadLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            launchAtLogin = SMAppService.mainApp.status == .enabled
        } else {
            launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        }
    }
    
    private func setLaunchAtLogin(_ enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                NSLog("Failed to set launch at login: \(error)")
            }
        } else {
            // Fallback for macOS 12: use shared file list (best effort)
            UserDefaults.standard.set(enabled, forKey: "launchAtLogin")
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
