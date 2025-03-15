//
//  Toaster.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 03/03/25.
//

import SwiftUI

struct Toast: Equatable {
    var message: String
    var style: Toaster.Style
    var duration: Double = 3
    var width: Double = .infinity
}

struct Toaster: View {
    
    var message: String
    var style: Toaster.Style
    var width: CGFloat = .infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.color)
            Text(message)
                .lineLimit(nil)
                .font(Font.caption)
                .foregroundColor(Color.textPrimary)
            
            Spacer(minLength: 10)
            
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.black)
            }
        }
        .padding()
        .frame(width: width != .infinity ? width : nil, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
    }
}

extension Toaster {
    enum Style {
        case error
        case warning
        case success
        case info
    }
}

extension Toaster.Style {
    var color: Color {
        switch self {
        case .error:
            return .red
        case .warning:
            return .orange
        case .success:
            return .green
        case .info:
            return .blue
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}

// Preference key to track toast height
struct ToastHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
