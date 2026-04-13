//
//  StopView.swift
//  stillness
//
//  Created by tenchii on 13/04/2026.
//

import SwiftUI

struct StopView: View {
    @State private var items: [StopItem] = []
    @State private var showAddItem = false
    @State private var selectedCategory: StopCategory = .habit
    
    var appItems: [StopItem] { items.filter { $0.category == .app } }
    var habitItems: [StopItem] { items.filter { $0.category == .habit } }
    var thoughtItems: [StopItem] { items.filter { $0.category == .thought } }
    
    var body: some View {
        ZStack {
            Color(red: 0.78, green: 0.74, blue: 0.82)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("stop.")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: { showAddItem = true }) {
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
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Apps section
                        if !appItems.isEmpty {
                            StopSection(title: "📱 apps to avoid", items: appItems, onToggle: toggleItem, onReset: resetItem)
                        }
                        
                        // Habits section
                        if !habitItems.isEmpty {
                            StopSection(title: "🚫 habits to stop", items: habitItems, onToggle: toggleItem, onReset: resetItem)
                        }
                        
                        // Thoughts section
                        if !thoughtItems.isEmpty {
                            StopSection(title: "💭 thoughts to stop", items: thoughtItems, onToggle: toggleItem, onReset: resetItem)
                        }
                        
                        // Empty state
                        if items.isEmpty {
                            VStack(spacing: 12) {
                                Text("🛑")
                                    .font(.system(size: 48))
                                Text("nothing to stop yet")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black.opacity(0.6))
                                Text("add something you want to stop doing")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black.opacity(0.4))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 60)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddItem) {
            AddStopItemView(items: $items, onSave: saveItems)
        }
        .onAppear {
            loadItems()
            checkDailyReset()
        }
    }
    
    func toggleItem(_ item: StopItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompletedToday.toggle()
            if items[index].isCompletedToday {
                items[index].streakDays += 1
            } else {
                items[index].streakDays = max(0, items[index].streakDays - 1)
            }
            saveItems()
        }
    }
    
    func resetItem(_ item: StopItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].streakDays = 0
            items[index].isCompletedToday = false
            items[index].lastResetDate = Date()
            saveItems()
        }
    }
    
    func checkDailyReset() {
        let calendar = Calendar.current
        for index in items.indices {
            if !calendar.isDateInToday(items[index].lastResetDate) {
                items[index].isCompletedToday = false
                items[index].lastResetDate = Date()
            }
        }
        saveItems()
    }
    
    func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "stopItems")
        }
    }
    
    func loadItems() {
        if let data = UserDefaults.standard.data(forKey: "stopItems"),
           let decoded = try? JSONDecoder().decode([StopItem].self, from: data) {
            items = decoded
        }
    }
}

struct StopSection: View {
    let title: String
    let items: [StopItem]
    let onToggle: (StopItem) -> Void
    let onReset: (StopItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black.opacity(0.5))
                .padding(.leading, 4)
            
            VStack(spacing: 8) {
                ForEach(items) { item in
                    StopCard(item: item, onToggle: onToggle, onReset: onReset)
                }
            }
        }
    }
}

struct StopCard: View {
    let item: StopItem
    let onToggle: (StopItem) -> Void
    let onReset: (StopItem) -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            // Checkbox
            Button(action: { onToggle(item) }) {
                ZStack {
                    Circle()
                        .stroke(item.isCompletedToday ? Color.green : Color.gray.opacity(0.4), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if item.isCompletedToday {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 20, height: 20)
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            
            // Name + streak
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .strikethrough(item.isCompletedToday, color: .gray)
                
                HStack(spacing: 4) {
                    Text(item.streakEmoji)
                        .font(.system(size: 11))
                    Text("day \(item.streakDays)")
                        .font(.system(size: 11))
                        .foregroundColor(.black.opacity(0.4))
                }
            }
            
            Spacer()
            
            // Reset button
            Button(action: { onReset(item) }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.3))
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct AddStopItemView: View {
    @Binding var items: [StopItem]
    let onSave: () -> Void
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var selectedCategory: StopCategory = .habit
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.78, green: 0.74, blue: 0.82)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Category picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("category")
                            .font(.system(size: 13))
                            .foregroundColor(.black.opacity(0.5))
                        
                        HStack(spacing: 10) {
                            ForEach(StopCategory.allCases, id: \.self) { category in
                                Button(action: { selectedCategory = category }) {
                                    HStack(spacing: 6) {
                                        Text(category.emoji)
                                        Text(category.rawValue.lowercased())
                                            .font(.system(size: 14))
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(selectedCategory == category ? Color.black : Color.white)
                                    .foregroundColor(selectedCategory == category ? .white : .black)
                                    .cornerRadius(20)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    // Name input
                    VStack(alignment: .leading, spacing: 10) {
                        Text("what do you want to stop?")
                            .font(.system(size: 13))
                            .foregroundColor(.black.opacity(0.5))
                        
                        TextField(selectedCategory == .app ? "e.g. Instagram" : selectedCategory == .habit ? "e.g. stalking her profile" : "e.g. thinking about her", text: $name)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    Spacer()
                }
                .padding(16)
                .padding(.top, 8)
            }
            .navigationTitle("add to stop list")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") { dismiss() }
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("add") {
                        guard !name.isEmpty else { return }
                        let item = StopItem(name: name, category: selectedCategory)
                        items.insert(item, at: 0)
                        onSave()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
            }
        }
    }
}


#Preview{
    StopView()
}
