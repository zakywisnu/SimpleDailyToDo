//
//  RoundedTextFieldStyle.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 28/02/25.
//

import SwiftUI

public struct RoundedTextFieldStyle: TextFieldStyle {
    public let style: Style
    
    public init (
        backgroundColor: Color = Color(UIColor.systemGray4),
        icon: Image? = nil,
        iconColor: Color? = nil
    ) {
        self.style = Style(
            backgroundColor: backgroundColor,
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
        .padding(.vertical)
        .padding(.horizontal, 24)
        .background(
            style.backgroundColor
        )
        .clipShape(Capsule(style: .continuous))
    }
    
    public struct Style {
        public let backgroundColor: Color
        public let icon: Image?
        public let iconColor: Color?
        
        public init(
            backgroundColor: Color = Color(UIColor.systemGray4),
            icon: Image? = nil,
            iconColor: Color? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.icon = icon
            self.iconColor = iconColor
        }
    }
}

