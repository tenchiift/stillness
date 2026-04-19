import SwiftUI

struct ThemView: View {
    
    @State private var showNewEntry = false
    @EnvironmentObject var dearMeStore: DearMeStore
    @EnvironmentObject var appState: AppState
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
                            // Reset
                            Button(action: { zikrCount = 0 }) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black.opacity(0.4))
                                    .padding(10)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            // Counter — tap = count, long press = fullscreen
                            Button(action: {
                                zikrCount += 1
                                if zikrCount >= zikrTarget {
                                    zikrCount = 0
                                }
                            }) {
                                VStack(spacing: 5) {
                                    Text("\(zikrCount)")
                                        .font(.system(size: appState.zikrFullscreen ? 80 : 45, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.top, 2)
                                        .offset(y: appState.zikrFullscreen ? CGFloat(0) : CGFloat(15))
                                        .contentTransition(.numericText())
                                    
                                    
                                    Text("click me !")
                                        .font(.system(size: 11))
                                        .foregroundColor(.black)
                                        .opacity(appState.zikrFullscreen ? 0 : 1)
                                        .offset(y: appState.zikrFullscreen ? CGFloat(0) : CGFloat(5))
                                        .animation(.spring(response: 0.5, dampingFraction: 1), value: appState.zikrFullscreen)
                                    
                                    Text("/ \(zikrTarget)")
                                        .font(.system(size: appState.zikrFullscreen ? 20 : 15, weight: .bold))
                                        .foregroundColor(.black.opacity(0.4))
                                        .padding(.top, 4)
                                        .offset(y: appState.zikrFullscreen ? CGFloat(-25) : CGFloat(3))
                                }
                                .offset(y: appState.zikrFullscreen ? 25 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: appState.zikrFullscreen)
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0.5)
                                    .onEnded { _ in
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                            appState.zikrFullscreen = true
                                        }
                                    }
                            )
                            
                            Spacer()
                            
                            // Target selector
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
                    .padding(.bottom, appState.zikrFullscreen ? 30 : 30)
                    .background(Color.white)
                    .cornerRadius(40)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            appState.zikrFullscreen = true
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.height < -50 && appState.zikrFullscreen {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        appState.zikrFullscreen = false
                                    }
                                }
                            }
                    )
                    // 4 Cards Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {
                        
                        Button(action: { showNewEntry = true }) {
                            ThemCard(title: "dear me")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: ToMeView()) {
                            ThemCard(title: "to me")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        ThemCard(title: "vibing")
                        
                        NavigationLink(destination: StopView()) {
                            ThemCard(title: "stop")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
                .ignoresSafeArea(edges: .top)
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    appState.zikrFullscreen = false
                }
            }
            .onDisappear {
                withAnimation(.none) {
                    appState.zikrFullscreen = false
                }
            }
            .sheet(isPresented: $showNewEntry) {
                NewDearMeView(entries: $dearMeStore.entries, onSave: { dearMeStore.save() })
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
        .environmentObject(AppState())
        .environmentObject(DearMeStore())
}
