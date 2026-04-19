import Foundation
import Combine

class DearMeStore: ObservableObject {
    @Published var entries: [DearMeEntry] = []
    
    init() {
        load()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "dearMeEntries")
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: "dearMeEntries"),
           let decoded = try? JSONDecoder().decode([DearMeEntry].self, from: data) {
            entries = decoded
        }
    }
    
    func add(_ entry: DearMeEntry) {
        entries.insert(entry, at: 0)
        save()
    }
}
