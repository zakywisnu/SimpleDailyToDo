//
//  ToastModifier.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 03/03/25.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: toast) {
                if let toast {
                    show(toast: toast)
                }
            }
    }
    
    func show(toast: Toast) {
        var toastWindow: UIWindow?
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        toastWindow = UIWindow(windowScene: scene)
        toastWindow?.backgroundColor = .clear
        
        // Create a hosting controller with the toast view
        let hostingController = UIHostingController(
            rootView: ToastSizeCalculator(
                message: toast.message,
                style: toast.style,
                width: CGFloat(toast.width),
                onCancelTapped: {
                    dismissToast(window: toastWindow)
                }
            )
        )
        
        // Configure the hosting controller
        hostingController.view.backgroundColor = .clear
        hostingController.view.sizeToFit()
        
        // Get the preferred size of the content
        let size = hostingController.sizeThatFits(in: CGSize(width: toast.width == .infinity ? UIScreen.main.bounds.width - 32 : toast.width, height: UIView.layoutFittingExpandedSize.height))
        
        // Calculate the position
        let xPosition: CGFloat = toast.width == .infinity ? 16 : (UIScreen.main.bounds.width - CGFloat(toast.width)) / 2
        let height = size.height
        
        // Configure the window with the calculated size
        toastWindow?.frame = CGRect(x: xPosition, y: -height, width: toast.width == .infinity ? UIScreen.main.bounds.width - 32 : toast.width, height: height)
        toastWindow?.rootViewController = hostingController
        toastWindow?.windowLevel = .alert + 1
        toastWindow?.makeKeyAndVisible()
        
        // Provide haptic feedback
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        // Animate the window sliding down
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            toastWindow?.frame.origin.y = 50
        })
        
        // Hide the toast automatically after the specified duration
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
            dismissToast(window: toastWindow)
        }
    }
    
    private func dismissToast(window: UIWindow?) {
        UIView.animate(withDuration: 0.5, animations: {
            window?.frame.origin.y = -(window?.frame.height ?? 0)
        }) { _ in
            window?.isHidden = true
            window?.rootViewController = nil
            toast = nil
        }
    }
}

// Helper view to calculate the size of toast content
struct ToastSizeCalculator: View {
    var message: String
    var style: Toaster.Style
    var width: CGFloat
    var onCancelTapped: () -> Void
    
    var body: some View {
        Toaster(
            message: message,
            style: style,
            width: width
        ) {
            onCancelTapped()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {
    func toast(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
