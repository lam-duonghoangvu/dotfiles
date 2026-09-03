import Carbon
import Foundation

private func getProperty<T>(_ source: TISInputSource, _ key: CFString) -> T? {
    guard let ptr = TISGetInputSourceProperty(source, key) else { return nil }
    return Unmanaged<AnyObject>.fromOpaque(ptr).takeUnretainedValue() as? T
}

private func getString(_ source: TISInputSource, _ key: CFString) -> String? {
    return getProperty(source, key) as String?
}

func getCurrentInputSource() -> (name: String, id: String)? {
    guard let source = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else { return nil }
    let name = getString(source, kTISPropertyLocalizedName) ?? "Unknown"
    let id = getString(source, kTISPropertyInputSourceID) ?? "Unknown"
    return (name, id)
}

func getSelectableInputSources() -> [(name: String, id: String, source: TISInputSource)] {
    guard let list = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] else { return [] }

    return list.compactMap { source in
        guard let category = getString(source, kTISPropertyInputSourceCategory),
              category == (kTISCategoryKeyboardInputSource as String),
              let isSelectable: CFBoolean = getProperty(source, kTISPropertyInputSourceIsSelectCapable),
              CFBooleanGetValue(isSelectable),
              let name = getString(source, kTISPropertyLocalizedName),
              let id = getString(source, kTISPropertyInputSourceID)
        else { return nil }
        return (name, id, source)
    }
}

// --- Main Execution ---
let args = CommandLine.arguments

if args.count > 1 && args[1] == "list" {
    for item in getSelectableInputSources() {
        print("\(item.name)\t\(item.id)")
    }
} else if args.count > 2 && args[1] == "select" {
    let target = args[2].lowercased()
    if let item = getSelectableInputSources().first(where: {
        $0.id.lowercased() == target || $0.name.lowercased() == target
    }) {
        TISSelectInputSource(item.source)
        print("Selected: \(item.name)")
    }
} else {
    if let current = getCurrentInputSource() {
        print(current.name)
    }
}
