//
//  FullLoadingView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 05/03/25.
//

import SwiftUI

public struct FullScreenLoadingView: ViewModifier {
    var isLoading: Bool
    public func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    loadingView
                }
            }
    }
    
    private var loadingView: some View {
        ZStack(alignment: .center) {
            Color.white.opacity(0.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            LoadingView()
                .frame(width: 64, height: 64)
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

public extension View {
    func loading(_ isLoading: Bool) -> some View {
        self.modifier(FullScreenLoadingView(isLoading: isLoading))
    }
}
