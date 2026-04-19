import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var zikrFullscreen = false
}

struct ContentView: View {
    @State private var showSettings = false
    @State private var selectedTab = "home"
    @State private var previousTab = "home"
    @State private var showNgajiReminder = false
    @State private var showSelawatReminder = false
    @StateObject private var dearMeStore = DearMeStore()
    @StateObject private var appState = AppState()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("home", systemImage: "house.fill", value: "home") {
                HomeView()
                    .environmentObject(appState)
            }
            Tab("them", systemImage: "heart.fill", value: "them") {
                ThemView()
                    .environmentObject(appState)
                    .environmentObject(DearMeStore())
            }
            Tab("settings", systemImage: "gearshape.fill", value: "settings") {
                Color(red: 0.78, green: 0.74, blue: 0.82)
                    .ignoresSafeArea()
            }
        }
        .animation(nil, value: selectedTab)
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
        .sheet(isPresented: $showSettings) {
                    SettingsView()
                        .presentationDetents([.large, .large])
                        .presentationDragIndicator(.visible)
                }
                .onAppear {
                    if DailyReminder.shouldShow(for: "ngaji") {
                        showNgajiReminder = true
                    } else if DailyReminder.shouldShow(for: "selawat") {
                        showSelawatReminder = true
                    }
                }
                .overlay {
                    if showNgajiReminder {
                        DailyReminderView(
                            isPresented: $showNgajiReminder,
                            question: "dah ngaji 1 muka harini?",
                            key: "ngaji",
                            onDone: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showSelawatReminder = true
                                }
                            }
                        )
                    }
                    
                    if showSelawatReminder {
                        DailyReminderView(
                            isPresented: $showSelawatReminder,
                            question: "dah selawat harini?",
                            key: "selawat",
                            onDone: nil
                        )
                    }
                }
            }
        }

        #Preview {
            ContentView()
        }
    

