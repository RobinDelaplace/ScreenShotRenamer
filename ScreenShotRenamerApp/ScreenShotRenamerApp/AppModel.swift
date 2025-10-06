import SwiftUI

final class AppModel: ObservableObject {
    @AppStorage("apiKey") var apiKey: String = "" {
        willSet { objectWillChange.send() }
    }

    @AppStorage("selectedFolder") private var storedFolderPath: String = "" {
        willSet { objectWillChange.send() }
    }

    @Published var folderSecurityScopedBookmark: Data?

    var selectedFolderURL: URL? {
        get {
            if let bookmark = folderSecurityScopedBookmark,
               let url = try? URL(resolvingBookmarkData: bookmark,
                                   options: [.withSecurityScope],
                                   bookmarkDataIsStale: nil) {
                return url
            }
            guard !storedFolderPath.isEmpty else { return nil }
            return URL(fileURLWithPath: storedFolderPath)
        }
        set {
            guard let url = newValue else {
                storedFolderPath = ""
                folderSecurityScopedBookmark = nil
                return
            }
            storedFolderPath = url.path
            folderSecurityScopedBookmark = try? url.bookmarkData(options: [.withSecurityScope], includingResourceValuesForKeys: nil, relativeTo: nil)
        }
    }

    func reset() {
        apiKey = ""
        storedFolderPath = ""
        folderSecurityScopedBookmark = nil
    }
}
