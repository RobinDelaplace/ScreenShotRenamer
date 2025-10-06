import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var isShowingFolderPicker = false
    @State private var isFolderAccessGranted = true

    var body: some View {
        ZStack {
            RadialGradient(colors: [Color(red: 0.08, green: 0.09, blue: 0.15), Color(red: 0.01, green: 0.02, blue: 0.06)], center: .topLeading, startRadius: 120, endRadius: 620)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                HeaderView()

                LiquidGlassCard {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Workspace Folder")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)

                        FolderSelectionRow(selectedURL: appModel.selectedFolderURL, isFolderAccessGranted: $isFolderAccessGranted) {
                            presentFolderPicker()
                        }
                    }
                }

                LiquidGlassCard {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("API Key")
                            .font(.title3.weight(.semibold))
                        APIKeyField(apiKey: $appModel.apiKey)
                    }
                }

                Spacer()
            }
            .padding(32)
        }
        .sheet(isPresented: $isShowingFolderPicker) {
            FolderPickerView { url in
                if let url {
                    appModel.selectedFolderURL = url
                    isFolderAccessGranted = true
                }
                isShowingFolderPicker = false
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appModel.selectedFolderURL)
        .animation(.easeInOut(duration: 0.25), value: appModel.apiKey)
    }

    private func presentFolderPicker() {
        isShowingFolderPicker = true
    }
}

private struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ScreenShot Renamer")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.9))
            Text("Pick the folder that contains your captures and paste your API key to get started.")
                .font(.title3)
                .foregroundStyle(Color.white.opacity(0.65))
        }
    }
}

private struct FolderSelectionRow: View {
    let selectedURL: URL?
    @Binding var isFolderAccessGranted: Bool
    var onPickRequested: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "folder")
                    .font(.title2)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.accentColor, Color.white.opacity(0.9))

                VStack(alignment: .leading, spacing: 4) {
                    if let url = selectedURL {
                        Text(url.lastPathComponent)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(url.path)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                    } else {
                        Text("No folder selected")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Button(action: onPickRequested) {
                    Label("Choose", systemImage: "square.and.arrow.down.on.square")
                        .labelStyle(.titleAndIcon)
                        .font(.headline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(.thinMaterial, in: Capsule())
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }

            if !isFolderAccessGranted {
                Label("We could not access the folder. Please try picking it again.", systemImage: "exclamationmark.triangle.fill")
                    .font(.footnote)
                    .foregroundStyle(.orange)
            }
        }
    }
}

private struct APIKeyField: View {
    @Binding var apiKey: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SecureField("Paste your API key", text: $apiKey)
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .glassBackgroundEffect()
                )

            if !apiKey.isEmpty {
                Text("Stored securely on this Mac using App Storage.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppModel())
}
