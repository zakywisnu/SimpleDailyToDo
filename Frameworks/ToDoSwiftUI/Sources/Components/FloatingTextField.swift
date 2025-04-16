//
//  FloatingTextField.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 20/02/25.
//

import SwiftUI

struct FloatingTextField: View {
    public enum InputType {
        case `default`
        case email
        case password
        case otp(isFilled: Binding<Bool>)
        case phoneNumber
        case number
        case decimalNumber
        
        var type: UIKeyboardType {
            switch self {
            case .email:
                return .emailAddress
            case .password, .default:
                return .default
            case .otp:
                return .numberPad
            case .phoneNumber:
                return .phonePad
            case .decimalNumber:
                return .decimalPad
            case .number:
                return .numberPad
            }
        }
    }
    
    private let title: String
    private let placeholder: String
    @Binding var text: String
    private var type: InputType = .email
    private var errorMessage: String?
    
    // Add state for focus tracking
    @FocusState private var isFocused: Bool
    
    private var shouldShowTitle: Bool {
        isFocused || !text.isEmpty
    }
    
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
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.body)
                .foregroundStyle(Color.textPrimary)
                .opacity(shouldShowTitle ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: shouldShowTitle)
            
            HStack {
                switch type {
                case .password:
                    SecureTextField(
                        placeholder,
                        text: $text
                    )
                    .onEditingChanged { isFocused in
                        self.isFocused = isFocused
                    }
                    .focused($isFocused)
                    .foregroundStyle(Color.textPrimary)
                    .keyboardType(type.type)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ToDoSwiftUIAsset.Colors.primary.swiftUIColor, lineWidth: 1)
                    )
                default:
                    TextField(
                        placeholder,
                        text: $text
                    )
                    .focused($isFocused)
                    .foregroundStyle(Color.textPrimary)
                    .keyboardType(type.type)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ToDoSwiftUIAsset.Colors.primary.swiftUIColor, lineWidth: 1)
                    )
                }
            }
            
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundStyle(Color.red)
                    .padding(.top, 4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

extension FloatingTextField {
    public func keyboard(type: InputType) -> Self {
        var view = self
        view.type = type
        return view
    }
}

#Preview {
    FloatingTextField(
        title: "any title",
        placeholder: "Username",
        text: .constant("")
    )
    .padding(16)
}
