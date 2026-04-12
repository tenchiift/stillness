import SwiftUI

struct ThemView: View {
    
    @AppStorage("zikrCount") private var zikrCount = 0
    @AppStorage("zikrTarget") private var zikrTarget = 33
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good Morning !" }
        else if hour < 17 { return "Good Afternoon !" }
        else { return "Good Night !" }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.78, green: 0.74, blue: 0.82)
                    .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    
                    // Card 1 — Hero
                    VStack(alignment: .leading, spacing: 8) {
                        Text(greeting)
                            .font(.system(size: 13))
                            .foregroundColor(.black.opacity(0.6))
                        
                        Text("stillness.")
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("chill bro , you are progressing")
                            .font(.system(size: 12))
                            .foregroundColor(.black.opacity(0.5))
                        
                        Spacer().frame(height: 24)
                        
                        // Zikir Counter
                        HStack {
                            Button(action: { zikrCount = 0 }) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black.opacity(0.4))
                                    .padding(10)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                zikrCount += 1
                                if zikrCount >= zikrTarget {
                                    zikrCount = 0
                                }
                            }) {
                                VStack(spacing: 0) {
                                    Text("\(zikrCount)")
                                        .font(.system(size: 45, weight: .bold))
                                        .foregroundColor(.black)
                                    Text("/ \(zikrTarget)")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.black.opacity(0.4))
                                }
                            }
                            
                            Spacer()
                            
                            Menu {
                                Button("33") { zikrTarget = 33; zikrCount = 0 }
                                Button("99") { zikrTarget = 99; zikrCount = 0 }
                                Button("100") { zikrTarget = 100; zikrCount = 0 }
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black.opacity(0.4))
                                    .padding(10)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 80)
                    .padding(.bottom, 30)
                    .background(Color.white)
                    .cornerRadius(40)
                    
                    // 4 Cards Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {
                        NavigationLink(destination: DearMeView()) {
                            ThemCard(title: "dear me")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        ThemCard(title: "to me")
                        ThemCard(title: "vibing")
                        ThemCard(title: "stop")
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
                .ignoresSafeArea(edges: .top)
            }
        }
    }
}

struct ThemCard: View {
    let title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(height: 200)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.black.opacity(0.7))
        }
    }
}

#Preview {
    ThemView()
}
