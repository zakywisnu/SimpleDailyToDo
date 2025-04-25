//
//  UserProfileView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var router: StandardSwiftUIRouter
    var namespace: Namespace.ID
    @Environment(\.dismiss) var dismiss
    var profile: ProfileModel?
    @StateObject private var viewModel: UserProfileViewModel
    
    init(namespace: Namespace.ID) {
        self.namespace = namespace
        _viewModel = StateObject(wrappedValue: UserProfileViewModel())
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Image(systemName: "x.circle")
                    .resizable()
                    .foregroundStyle(Color.primaryColor)
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        dismiss.callAsFunction()
                    }
                
                Spacer()
                
                Text("Edit")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.primaryColor)
                    .onTapGesture {
                        viewModel.send(.didTapEditProfile)
                    }
            }
            .padding()
            Spacer()
            
            VStack {
                Group {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundStyle(Color.progressBlue)
                        .frame(width: 128, height: 128)
                        .navigationTransition(.zoom(sourceID: "profile", in: namespace))
                    
                    content
                }
                .frame(maxWidth: .infinity)
                .frame(height: 175)
                .offset(y: -100)
            }
            
            Section {
                Toggle("Enable Live Activity", isOn: Binding(get: {
                    viewModel.state.isEnableLiveActivity
                }, set: { newValue in
                    viewModel.send(.didUpdateLiveActivity)
                }))
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.primaryColor.gradient)
                )
            }
            .offset(y: -50)
            .padding(.horizontal, 16)
            
            Spacer()
            
            LoadingButtonView(isLoading: .constant(false)) {
                viewModel.send(.didTapLogout)
            } builder: {
                Text("Logout")
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
            }
            .setWidth(UIScreen.main.bounds.width - 32)
        }
        .navigationBarHidden(true)
        .background(Color.backgroundPrimary)
        .onFirstAppear {
            viewModel.setup(router: router)
        }
        .onAppear {
            viewModel.send(.didLoad)
        }
        .sheet(isPresented: $viewModel.state.isShowLogoutSheet) {
            LogoutSheet(didTapLogout: {
                viewModel.send(.didLogout)
            }, onDismiss: {
                viewModel.state.shouldUpdateProfile = true
            })
            .presentationDetents([.height(300)])
        }
        .sheet(isPresented: $viewModel.state.isShowEditProfileSheet) {
            EditProfileView(profile: viewModel.state.profile) {
                viewModel.send(.didSuccessUpdateProfile)
            }
            .presentationDetents([.fraction(0.7)])
        }
        .toast(toast: $viewModel.state.toast)
        .loading(viewModel.state.isLoading)
    }
    
    @ViewBuilder
    private var content: some View {
        VStack {
            ProfileCard(profile: viewModel.state.profile)
                .padding(16)
        }
    }
}

#Preview {
    
}
