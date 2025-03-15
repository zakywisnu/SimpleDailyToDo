//
//  UnderlinedTextFieldStyle.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 28/02/25.
//

import SwiftUI

public struct UnderlinedTextFieldStyle: TextFieldStyle {
    public let style: Style
    
    public init (
        underlinedColor: Color = Color(UIColor.systemGray4),
        icon: Image? = nil,
        iconColor: Color? = nil
    ) {
        self.style = Style(
            underlinedColor: underlinedColor,
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
        .padding(.vertical, 8)
        .background(
            VStack {
                Spacer()
                style.underlinedColor
                    .frame(height: 2)
            }
        )
    }
    
    public struct Style {
        public let underlinedColor: Color
        public let icon: Image?
        public let iconColor: Color?
        
        public init(
            underlinedColor: Color = Color(UIColor.systemGray4),
            icon: Image? = nil,
            iconColor: Color? = nil
        ) {
            self.underlinedColor = underlinedColor
            self.icon = icon
            self.iconColor = iconColor
        }
    }
}

