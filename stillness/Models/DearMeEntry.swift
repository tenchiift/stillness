//
//  DearMeEntry.swift
//  stillness
//
//  Created by tenchii on 12/04/2026.
//


import Foundation

struct DearMeEntry: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var songTitle: String
    var songArtist: String
    var createdAt: Date
    
    init(title: String, content: String, songTitle: String = "", songArtist: String = "") {
        self.id = UUID()
        self.title = title
        self.content = content
        self.songTitle = songTitle
        self.songArtist = songArtist
        self.createdAt = Date()
    }
}
