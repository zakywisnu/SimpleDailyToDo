//
//  SecureTextField.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 20/02/25.
//

import SwiftUI

public struct SecureTextField: View {
    @State
    private var isSecured = true
    private let placeholder: String

    @Binding
    private var text: String

    private var _onEditingChanged: ((Bool) -> Void)?

    public init(
        _ placeholder: String,
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        _text = text
    }

    public var body: some View {
        HStack {
            if isSecured {
                SecureField(
                    placeholder,
                    text: $text,
                    onCommit: {
                        _onEditingChanged?(false)
                    }
                )
                .foregroundStyle(.black)
                .onTapGesture {
                    _onEditingChanged?(true)
                }
            } else {
                TextField(text, text: $text) { focused in
                    _onEditingChanged?(focused)
                }
                .foregroundStyle(.black)
            }

            HStack {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
            .padding(.leading, 16)
            .padding([.vertical, .trailing], 4)
            .contentShape(Rectangle())
            .onTapGesture {
                isSecured.toggle()
            }
        }
    }
}

extension SecureTextField {
    public func onEditingChanged(_ onEditingChanged: @escaping (Bool) -> Void) -> Self {
        var newView = self
        newView._onEditingChanged = onEditingChanged
        return newView
    }
}
