import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color(red: 0.78, green: 0.74, blue: 0.82)
                .ignoresSafeArea()
            
            List {
                
                // Profile Section
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(red: 0.78, green: 0.74, blue: 0.82))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("T")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("tenchii")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            Text("stillness developer")
                                .font(.system(size: 13))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        
                        Spacer()
                        Text("")
                            .font(.system(size: 30))
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.white)
                
                // Links Section
                Section("links") {
                    Button(action: {
                        if let url = URL(string: "https://github.com/tenchiift") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left.forwardslash.chevron.right")
                                .foregroundColor(.black)
                                .frame(width: 28)
                            Text("github")
                                .foregroundColor(.black)
                            Spacer()
                            Text("tenchiift")
                                .foregroundColor(.black.opacity(0.4))
                                .font(.system(size: 13))
                            Image(systemName: "arrow.up.right")
                                .foregroundColor(.black.opacity(0.3))
                                .font(.system(size: 12))
                        }
                    }
                }
                .listRowBackground(Color.white)
                
                // App Section
                Section("app") {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.black)
                            .frame(width: 28)
                        Text("version")
                            .foregroundColor(.black)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.black.opacity(0.4))
                            .font(.system(size: 13))
                    }
                    
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.black)
                            .frame(width: 28)
                        Text("made with love")
                            .foregroundColor(.black)
                        Spacer()
                        Text("🌿")
                    }
                }
                .listRowBackground(Color.white)
            }
            .scrollContentBackground(.hidden)
        }
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    SettingsView()
}
