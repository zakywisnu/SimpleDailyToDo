//
//  PrimaryButton.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let style: Style
    let action: (() -> Void)
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(style.textColor)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(style.backgroundColor)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
}

extension PrimaryButton {
    enum Style {
        case `default`
        case warning
        case secondary
    }
}

extension PrimaryButton.Style {
    var backgroundColor: Color {
        switch self {
        case .default:
            return Color.primary
        case .warning:
            return Color.red
        case .secondary:
            return Color.backgroundPrimary
        }
    }
    
    var textColor: Color {
        switch self {
        case .default:
            return Color.white
        case .warning:
            return Color.textPrimary
        case .secondary:
            return Color.textSecondary
        }
    }
}
