//
//  ToMeView.swift
//  stillness
//
//  Created by tenchii on 19/04/2026.
//

import SwiftUI

struct ToMeView: View {
    @EnvironmentObject var dearMeStore: DearMeStore
    
    var body: some View {
        ZStack {
            Color(red: 0.78, green: 0.74, blue: 0.82)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("to me")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                if dearMeStore.entries.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Text("💌")
                            .font(.system(size: 48))
                        Text("no letters yet")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black.opacity(0.6))
                        Text("write your first letter in dear me")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.4))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(dearMeStore.entries) { entry in
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
    }
}
