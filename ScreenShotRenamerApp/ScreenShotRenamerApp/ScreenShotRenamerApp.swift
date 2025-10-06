import SwiftUI

@main
struct ScreenShotRenamerApp: App {
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 720, height: 520)

        Settings {
            SettingsView()
                .environmentObject(appModel)
                .frame(width: 420, height: 260)
        }
    }
}
