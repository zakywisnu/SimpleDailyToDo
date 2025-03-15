//
//  UserProfileViewModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 25/02/25.
//

import Foundation
import DomainKit

final class UserProfileViewModel: ObservableObject {
    @Published var state: State
    
    private let profileUseCase: GetProfileUseCase = StandardGetProfileUseCase()
    private let logoutUseCase: LogoutUseCase = StandardLogoutUseCase()
    
    private var router: StandardSwiftUIRouter?
    
    init() {
        self.state = State()
    }
    
    func send(_ action: Action) {
        switch action {
        case .didLoad:
            state.isLoading = true
            Task {
                await getProfile()
            }
        case .didTapLogout:
            state.isShowLogoutSheet.toggle()
            state.shouldUpdateProfile = false
        case .didLogout:
            state.isLoading = true
            Task {
                await logout()
            }
        case .didTapEditProfile:
            state.isShowEditProfileSheet.toggle()
        case .didSuccessUpdateProfile:
            state.toast = Toast(message: "Successfully Update Profile", style: .success)
            send(.didLoad)
        }
    }
    
    func setup(router: StandardSwiftUIRouter) {
        self.router = router
    }
}

extension UserProfileViewModel {
    @MainActor
    private func getProfile() async {
        defer { state.isLoading = false }
        guard state.shouldUpdateProfile else { return }
        do {
            try await Task.sleep(for: .seconds(1))
            let profile = try await profileUseCase.execute()
            state.profile = profile.toModel()
        } catch {
            print("error profile: ", error)
        }
    }
    
    @MainActor
    private func logout() async {
        defer { state.isLoading = false }
        do {
            try await Task.sleep(for: .seconds(1))
            let isSucceed = try await logoutUseCase.execute()
            if isSucceed {
                router?.setRoot(to: .auth(.login))
            }
        } catch {
            print("failed to logout: ", error)
        }
    }
}

extension UserProfileViewModel {
    struct State {
        var profile: ProfileModel = .empty
        var isShowLogoutSheet: Bool = false
        var isShowEditProfileSheet: Bool = false
        var shouldUpdateProfile: Bool = true
        var toast: Toast?
        var isLoading: Bool = false
    }
    
    enum Action {
        case didLoad
        case didTapLogout
        case didLogout
        case didTapEditProfile
        case didSuccessUpdateProfile
    }
}
