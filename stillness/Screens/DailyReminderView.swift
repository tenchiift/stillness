import SwiftUI

struct DailyReminderView: View {
    @Binding var isPresented: Bool
    let question: String
    let key: String
    let onDone: (() -> Void)?
    @State private var showSelawat = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            if showSelawat {
                // Popup selawat text
                VStack(spacing: 24) {
                    Text("🤲")
                        .font(.system(size: 48))
                    
                    Text("اَللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .environment(\.layoutDirection, .rightToLeft)
                    
                    Button(action: {
                        DailyReminder.markDone(for: key)
                        isPresented = false
                        onDone?()
                    }) {
                        Text("dahh ✓")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.black)
                            .cornerRadius(16)
                    }
                }
                .padding(28)
                .background(Color.white)
                .cornerRadius(28)
                .padding(.horizontal, 32)
                
            } else {
                // Popup soalan
                VStack(spacing: 24) {
                    Text("🌙")
                        .font(.system(size: 48))
                    
                    Text(question)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            if key == "selawat" {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    showSelawat = true
                                }
                            } else {
                                // ngaji — buka quran app
                                if let url = URL(string: "https://apps.apple.com/app/quran-majeed-quran-sharif/id1118663303") {
                                    UIApplication.shared.open(url)
                                }
                                isPresented = false
                            }
                        }) {
                            Text("belom")
                                .font(.system(size: 16))
                                .foregroundColor(.black.opacity(0.6))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(16)
                        }
                        
                        Button(action: {
                            DailyReminder.markDone(for: key)
                            isPresented = false
                            onDone?()
                        }) {
                            Text("dahh ✓")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.black)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(28)
                .background(Color.white)
                .cornerRadius(28)
                .padding(.horizontal, 32)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showSelawat)
    }
}
