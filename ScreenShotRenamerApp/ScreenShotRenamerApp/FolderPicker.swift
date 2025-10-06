import SwiftUI
import AppKit

struct FolderPickerView: NSViewControllerRepresentable {
    typealias NSViewControllerType = NSViewController

    var onCompletion: (URL?) -> Void

    func makeNSViewController(context: Context) -> NSViewController {
        let controller = NSViewController()
        DispatchQueue.main.async {
            let panel = NSOpenPanel()
            panel.prompt = "Choose"
            panel.message = "Select the folder that contains your screenshots"
            panel.allowsMultipleSelection = false
            panel.canChooseFiles = false
            panel.canChooseDirectories = true
            panel.canCreateDirectories = false
            panel.begin { response in
                let url = response == .OK ? panel.url : nil
                onCompletion(url)
            }
        }
        return controller
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}
}
