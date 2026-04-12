import SwiftUI

struct ContentView: View {
    @State private var showSettings = false
    @State private var selectedTab = "home"
    @State private var previousTab = "home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("home", systemImage: "house.fill", value: "home") {
                HomeView()
            }
            Tab("them", systemImage: "heart.fill", value: "them") {
                ThemView()
            }
            Tab("settings", systemImage: "gearshape.fill", value: "settings") {
                Color(red: 0.78, green: 0.74, blue: 0.82)
                    .ignoresSafeArea()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .onChange(of: selectedTab) { oldTab, newTab in
            if newTab == "settings" {
                previousTab = oldTab
                selectedTab = oldTab
                showSettings = true
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .presentationDetents([.large, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ContentView()
}
