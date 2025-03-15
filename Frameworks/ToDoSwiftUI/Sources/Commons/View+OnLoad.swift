//
//  View+OnLoad.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 25/02/25.
//

import SwiftUI

/// A custom view modifier that performs an action when the view appears.
struct OnLoadModifier: ViewModifier {
    var action: () async -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                Task {
                    await action()
                }
            }
    }
}

public extension View {
    /// Adds an action to perform when this view is loaded.
    ///
    /// - Parameter action: The asynchronous action to perform.
    /// - Returns: A view that triggers `action` when this view is loaded.
    func onLoad(perform action: @escaping @Sendable () async -> Void) -> some View {
        modifier(OnLoadModifier(action: action))
    }
    
    /// Adds an action to perform when this view is loaded.
    ///
    /// - Parameter action: The synchronous action to perform.
    /// - Returns: A view that triggers `action` when this view is loaded.
    func onLoad(perform action: @escaping () -> Void) -> some View {
        modifier(OnLoadModifier {
            await withCheckedContinuation { continuation in
                action()
                continuation.resume()
            }
        })
    }
}
