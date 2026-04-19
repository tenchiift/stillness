//
//  DearMeView.swift
//  stillness
//
//  Created by tenchii on 12/04/2026.
//

import SwiftUI
import MediaPlayer

struct DearMeView: View {
    @State private var entries: [DearMeEntry] = []
    @State private var showNewEntry = false
    
    var body: some View {
        ZStack {
            Color(red: 0.78, green: 0.74, blue: 0.82)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("dear me")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: { showNewEntry = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                if entries.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Text("💌")
                            .font(.system(size: 48))
                        Text("No letters yet")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black.opacity(0.6))
                        Text("Write your first letter to yourself")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.4))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(entries) { entry in
                                NavigationLink(destination: DearMeDetailView(entry: entry)) {
                                    DearMeCard(entry: entry)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showNewEntry) {
            NewDearMeView(entries: $entries, onSave: {})
        }
        .onAppear {
            loadEntries()
        }
    }
    
    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "dearMeEntries"),
           let decoded = try? JSONDecoder().decode([DearMeEntry].self, from: data) {
            entries = decoded
        }
    }
}

struct DearMeCard: View {
    let entry: DearMeEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(entry.title.isEmpty ? "Untitled" : entry.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
                Text(entry.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.4))
            }
            
            Text(entry.content)
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.6))
                .lineLimit(2)
            
            if !entry.songTitle.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "music.note")
                        .font(.system(size: 11))
                        .foregroundColor(.black.opacity(0.4))
                    Text("\(entry.songTitle) — \(entry.songArtist)")
                        .font(.system(size: 12))
                        .foregroundColor(.black.opacity(0.4))
                        .lineLimit(1)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct DearMeDetailView: View {
    let entry: DearMeEntry
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 0.78, green: 0.74, blue: 0.82)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Back button
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    // Title
                    Text(entry.title.isEmpty ? "Untitled" : entry.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    // Date
                    Text(entry.createdAt.formatted(date: .long, time: .omitted))
                        .font(.system(size: 13))
                        .foregroundColor(.black.opacity(0.4))
                    
                    // Song
                    if !entry.songTitle.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: "music.note")
                                .font(.system(size: 13))
                                .foregroundColor(.black.opacity(0.5))
                            Text("\(entry.songTitle) — \(entry.songArtist)")
                                .font(.system(size: 13))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(12)
                    }
                    
                    Divider()
                    
                    // Content
                    Text(entry.content)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .lineSpacing(6)
                }
                .padding(24)
                .padding(.top, 40)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }
}

struct NewDearMeView: View {
    @Binding var entries: [DearMeEntry]
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var songTitle = ""
    @State private var songArtist = ""
    @State private var showSongPicker = false
    let onSave: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.78, green: 0.74, blue: 0.82)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Title
                        TextField("Title", text: $title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(16)
                        
                        // Song picker
                        Button(action: { pickCurrentSong() }) {
                            HStack(spacing: 10) {
                                Image(systemName: "music.note")
                                    .foregroundColor(.black.opacity(0.5))
                                if songTitle.isEmpty {
                                    Text("Add current song")
                                        .foregroundColor(.black.opacity(0.4))
                                } else {
                                    Text("\(songTitle) — \(songArtist)")
                                        .foregroundColor(.black.opacity(0.7))
                                        .lineLimit(1)
                                }
                                Spacer()
                            }
                            .font(.system(size: 14))
                            .padding(14)
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                        
                        // Content
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $content)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(minHeight: 300)
                            
                            if content.isEmpty {
                                Text("Dear me...")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black.opacity(0.3))
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                    .padding(16)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("dear me")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard !content.isEmpty else { return }
                        let entry = DearMeEntry(
                            title: title,
                            content: content,
                            songTitle: songTitle,
                            songArtist: songArtist
                        )
                        entries.insert(entry, at: 0)
                        saveEntries()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
            }
        }
    }
    
    func pickCurrentSong() {
        let player = MPMusicPlayerController.systemMusicPlayer
        if let item = player.nowPlayingItem {
            songTitle = item.title ?? ""
            songArtist = item.artist ?? ""
        }
    }
    
    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "dearMeEntries")
        }
        onSave()
    }
}

#Preview {
    ContentView()
}
