//
//  DetoxView.swift
//  stillness
//
//  Created by tenchii on 11/04/2026.
//

import SwiftUI

struct DetoxView: View {
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.93, blue: 0.84)
                .ignoresSafeArea()
            Text("Detox — Coming soon")
                .font(.custom("Georgia", size: 20))
                .foregroundColor(Color(red: 0.48, green: 0.36, blue: 0.31))
        }
        .navigationTitle("Detox")
    }
}
