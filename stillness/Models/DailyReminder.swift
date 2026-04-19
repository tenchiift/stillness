//
//  DailyReminder.swift
//  stillness
//
//  Created by tenchii on 14/04/2026.
//

import Foundation

struct DailyReminder {
    static let questions = [
        "dah ngaji 1 muka harini?",
        "dah selawat harini?"
    ]
    
    static func shouldShow(for key: String) -> Bool {
        let lastDone = UserDefaults.standard.string(forKey: key) ?? ""
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        return lastDone != today
    }
    
    static func markDone(for key: String) {
        let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        UserDefaults.standard.set(today, forKey: key)
    }
}
