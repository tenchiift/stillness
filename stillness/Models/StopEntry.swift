//
//  StopEntry.swift
//  stillness
//
//  Created by tenchii on 13/04/2026.
//

import Foundation

struct StopItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: StopCategory
    var streakDays: Int
    var lastResetDate: Date
    var isCompletedToday: Bool
    
    init(name: String, category: StopCategory) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.streakDays = 0
        self.lastResetDate = Date()
        self.isCompletedToday = false
    }
    
    var streakEmoji: String {
        switch streakDays {
        case 0: return "🌱"
        case 1...3: return "🌿"
        case 4...7: return "🌳"
        case 8...14: return "⭐️"
        case 15...30: return "🔥"
        default: return "💎"
        }
    }
}

enum StopCategory: String, Codable, CaseIterable {
    case app = "App"
    case habit = "Habit"
    case thought = "Thought"
    
    var emoji: String {
        switch self {
        case .app: return "📱"
        case .habit: return "🚫"
        case .thought: return "💭"
        }
    }
}
