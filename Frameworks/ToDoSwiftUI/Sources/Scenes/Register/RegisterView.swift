//
//  RegisterView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    @EnvironmentObject var router: StandardSwiftUIRouter
    
    init(_ onSuccessRegister: @escaping (String) -> Void) {
        _viewModel = StateObject(wrappedValue: RegisterViewModel(onSuccessRegister))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome Back 👋")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
            
            Text("Sign up now to start managing your tasks.")
                .font(.title3)
                .foregroundStyle(Color.textSecondary)
                .padding(.bottom, 24)
            
            FloatingTextField(title: "Email", placeholder: "Email", text: $viewModel.state.email)
                .keyboard(type: .email)
            
            FloatingTextField(title: "Password", placeholder: "Password", text: $viewModel.state.password)
                .keyboard(type: .password)
            
            FloatingTextField(title: "First Name", placeholder: "First Name", text: $viewModel.state.firstName)
                .keyboard(type: .default)
            
            FloatingTextField(title: "Last Name", placeholder: "Last Name", text: $viewModel.state.lastName)
                .keyboard(type: .default)
            
            Spacer()
            
            Button(action: {
                viewModel.send(.didTapRegister)
            }, label: {
                Text("Submit")
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
            })
            .disabled(!viewModel.state.isFormValid)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.primary)
            )
            
        }
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onAppear {
            viewModel.setup(router: router)
        }
    }
}

#Preview {
    RegisterView {_ in 
        
    }
}
