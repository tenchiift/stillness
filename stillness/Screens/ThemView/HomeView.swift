import SwiftUI
import MediaPlayer

struct HomeView: View {
    
    @State private var songTitle = "Not playing"
    @State private var artistName = ""
    @State private var albumArt: UIImage? = nil
    @State private var isPlaying = false
    @State private var timer: Timer? = nil
    @State private var songProgress: Double = 0.0
    @EnvironmentObject var appState: AppState
    
    @AppStorage("zikrCount") private var zikrCount = 0
    @AppStorage("zikrTarget") private var zikrTarget = 33
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good Morning !" }
        else if hour < 17 { return "Good Afternoon !" }
        else { return "Good Night !" }
    }
    
    func fetchNowPlaying() {
        let player = MPMusicPlayerController.systemMusicPlayer
        if let item = player.nowPlayingItem {
            songTitle = item.title ?? "Unknown"
            artistName = item.artist ?? ""
            isPlaying = player.playbackState == .playing
            
            let current = player.currentPlaybackTime
            let duration = item.playbackDuration
            songProgress = duration > 0 ? current / duration : 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let artwork = item.artwork?.image(at: CGSize(width: 200, height: 200)) {
                    albumArt = artwork
                }
            }
        } else {
            songTitle = "Not playing"
            artistName = ""
            albumArt = nil
            isPlaying = false
            songProgress = 0
        }
    }
    
    var body: some View {
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
                // Card 2 — Progress
                VStack(alignment: .leading, spacing: 14) {
                    Text("so far")
                        .font(.system(size: 16))
                        .foregroundColor(.black.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 4)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(red: 0.35, green: 0.35, blue: 0.9))
                                .frame(width: geo.size.width * 0.4, height: 4)
                        }
                    }
                    .frame(height: 4)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(24)
                .padding(.horizontal, 16)
                
                // Card 3 — Music Player
                VStack(spacing: 16) {
                    Spacer().frame(height: 8)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.15), lineWidth: 4)
                            .frame(width: 116, height: 116)
                        
                        Circle()
                            .trim(from: 0, to: songProgress)
                            .stroke(
                                Color(red: 0.35, green: 0.35, blue: 0.9),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .frame(width: 116, height: 116)
                        
                        if let art = albumArt {
                            Image(uiImage: art)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "music.note")
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    
                    Text(songTitle)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    
                    Text(artistName)
                        .font(.system(size: 13))
                        .foregroundColor(.black.opacity(0.5))
                    
                    HStack(spacing: 48) {
                        Button(action: {
                            MPMusicPlayerController.systemMusicPlayer.skipToPreviousItem()
                            fetchNowPlaying()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            let player = MPMusicPlayerController.systemMusicPlayer
                            if player.playbackState == .playing {
                                player.pause()
                                isPlaying = false
                            } else {
                                player.play()
                                isPlaying = true
                            }
                        }) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            MPMusicPlayerController.systemMusicPlayer.skipToNextItem()
                            fetchNowPlaying()
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer().frame(height: 8)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(24)
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
        }
        .onAppear {
            fetchNowPlaying()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                fetchNowPlaying()
            }
            NotificationCenter.default.addObserver(
                forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
                object: nil,
                queue: .main
            ) { _ in
                fetchNowPlaying()
            }
            MPMusicPlayerController.systemMusicPlayer.beginGeneratingPlaybackNotifications()
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil

            
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
