//
//  OutlinedTextFieldStyle.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 28/02/25.
//

import SwiftUI

public struct OutlinedTextFieldStyle: TextFieldStyle {
    public let style: Style
    
    public init (
        cornerRadius: CGFloat = 8,
        strokeColor: Color = Color(UIColor.systemGray4),
        strokeWidth: CGFloat = 2,
        icon: Image? = nil,
        iconColor: Color? = nil
    ) {
        self.style = Style(
            cornerRadius: cornerRadius,
            strokeColor: strokeColor,
            strokeWidth: strokeWidth,
            icon: icon,
            iconColor: iconColor
        )
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            if let icon = style.icon, let iconColor = style.iconColor {
                icon
                    .foregroundColor(iconColor)
            }
            configuration
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                .stroke(style.strokeColor, lineWidth: style.strokeWidth)
        }
    }
    
    public struct Style {
        public let icon: Image?
        public let iconColor: Color?
        public let cornerRadius: CGFloat
        public let strokeColor: Color
        public let strokeWidth: CGFloat
        
        public init(
            cornerRadius: CGFloat = 8,
            strokeColor: Color = Color(UIColor.systemGray4),
            strokeWidth: CGFloat = 2,
            icon: Image? = nil,
            iconColor: Color? = nil
        ) {
            self.icon = icon
            self.iconColor = iconColor
            self.cornerRadius = cornerRadius
            self.strokeColor = strokeColor
            self.strokeWidth = strokeWidth
        }
    }
}
