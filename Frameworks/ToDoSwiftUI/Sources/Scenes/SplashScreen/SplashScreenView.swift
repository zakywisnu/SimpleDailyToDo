//
//  SplashScreenView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 25/02/25.
//

import SwiftUI
import CoreKit

struct SplashScreenView: View {
    @State private var titleOpacity = 0.0
    @State private var subtitleOpacity = 0.0
    @State private var isActive = false
    @EnvironmentObject
    var router: StandardSwiftUIRouter
    
    var body: some View {
        ZStack {
            // Background color
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title text with animation
                Text("Daily ToDo")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.primary)
                    .opacity(titleOpacity)
                
                // Subtitle text with animation
                Text("Managing Your Daily Tasks")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.secondary)
                    .opacity(subtitleOpacity)
            }
        }
        .background(Color.backgroundPrimary)
        .onAppear {
            // Animate title appearing first
            withAnimation(.easeIn(duration: 1.2)) {
                titleOpacity = 1.0
            }
            
            // Animate subtitle appearing after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeIn(duration: 1.2)) {
                    subtitleOpacity = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                if let token: String = UserDefaultsDataSource.current.get(forKey: "accessToken"), !token.isEmpty {
                    router.setRoot(to: .home)
                } else {
                    router.setRoot(to: .auth(.login))
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
