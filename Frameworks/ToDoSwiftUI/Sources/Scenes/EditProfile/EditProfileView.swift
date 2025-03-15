//
//  EditProfileView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditProfileViewModel
    
    init(profile: ProfileModel, onSuccess: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(profile: profile, onSuccess: onSuccess))
    }
    
    var body: some View {
        VStack {
            NavigationBarView(title: "Edit Profile") {}
                .padding(.horizontal, 16)
            
            VStack(spacing: 16) {
                StandardTextField(title: "Email", placeholder: "Email", text: $viewModel.state.profile.email)
                    .padding(.top, 16)
                
                StandardTextField(title: "First Name", placeholder: "First Name", text: $viewModel.state.profile.firstName)
                
                StandardTextField(title: "Last Name", placeholder: "Last Name", text: $viewModel.state.profile.lastName)
                    .padding(.bottom, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
            )
            .padding()
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 3)
            
            Spacer()
            
            LoadingButtonView(isLoading: $viewModel.state.isLoading) {
                viewModel.send(.didSubmit)
            } builder: {
                Text("Submit")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
            }
            .setWidth(UIScreen.main.bounds.width - 32)
            .padding(.bottom, 32)

        }
        .background(Color.backgroundPrimary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .toast(toast: $viewModel.state.toast)
        .edgesIgnoringSafeArea(.all)
        .onChange(of: viewModel.state.isSuccessUpdate) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}
