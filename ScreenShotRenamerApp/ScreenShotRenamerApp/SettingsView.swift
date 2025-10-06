import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        Form {
            Section("API Key") {
                SecureField("Paste your API key", text: $appModel.apiKey)
                    .textFieldStyle(.roundedBorder)
                Text("The key is stored using App Storage and never leaves your device.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Workspace") {
                if let url = appModel.selectedFolderURL {
                    LabeledContent("Selected Folder") {
                        Text(url.path)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                    }
                } else {
                    Text("No folder selected yet.")
                        .foregroundStyle(.secondary)
                }
                Button("Clear Selection", role: .destructive) {
                    appModel.selectedFolderURL = nil
                }
                .disabled(appModel.selectedFolderURL == nil)
            }

            Section {
                Button("Reset All Settings", role: .destructive) {
                    appModel.reset()
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppModel())
}
