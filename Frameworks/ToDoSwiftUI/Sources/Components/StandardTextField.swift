//
//  StandardTextField.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 28/02/25.
//

import SwiftUI

struct StandardTextField: View {
    private let title: String
    private let placeholder: String
    @Binding var text: String
    
    init(
        title: String,
        placeholder: String,
        text: Binding<String>
    ) {
        self.title = title
        self.placeholder = placeholder
        _text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.body)
                .foregroundStyle(Color.textPrimary)
            
            TextField(placeholder, text: $text)
                .font(.body)
                .foregroundStyle(Color.textPrimary)
                .textFieldStyle(
                    OutlinedTextFieldStyle(
                        cornerRadius: 8,
                        strokeColor: Color.primary,
                        strokeWidth: 2
                    )
                )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    StandardTextField(title: "Email", placeholder: "Email", text: .constant(""))
}
