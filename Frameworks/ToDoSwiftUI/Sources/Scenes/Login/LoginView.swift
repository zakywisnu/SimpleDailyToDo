//
//  LoginView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var router: StandardSwiftUIRouter
    @StateObject var viewModel: LoginViewModel = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            
            Text("Welcome Back 👋")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
            
            Text("Sign in to start managing your tasks.")
                .font(.title3)
                .foregroundStyle(Color.textSecondary)
                .padding(.bottom, 24)
            
            FloatingTextField(title: "Email", placeholder: "please input your email", text: $viewModel.state.email)
                .keyboard(type: .email)
            
            FloatingTextField(title: "Password", placeholder: "please input your password", text: $viewModel.state.password)
                .keyboard(type: .password)
            
            Group {
                HStack(spacing: 4) {
                    Text("Don't have an account? ")
                        .font(.footnote)
                        .foregroundStyle(Color.textPrimary)
                    Text("Register now.")
                        .font(.footnote)
                        .foregroundStyle(Color.primary)
                        .onTapGesture {
                            viewModel.send(.didTapRegister)
                        }
                }
            }
                
            Spacer()
            
            LoadingButtonView(isLoading: $viewModel.state.isLoading) {
                viewModel.send(.didSubmit)
            } builder: {
                Text("Login")
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
            }
            .setWidth(UIScreen.main.bounds.width - 32)
            .padding(.bottom, 32)
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleDisplayMode(.automatic)
        .onAppear {
            viewModel.setup(router: router)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
