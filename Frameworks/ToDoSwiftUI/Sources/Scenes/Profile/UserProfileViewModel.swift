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
    private let getLiveActivityUseCase: GetAutoLiveActivityStatusUseCase = StandardGetAutoLiveActivityStatusUseCase()
    private let updateLiveActivityUseCase: UpdateAutoLiveActivityStatusUseCase = StandardUpdateAutoLiveActivityStatusUseCase()
    private let getToDoListUseCase: GetToDoListUseCase = StandardGetToDoListUseCase()
    
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
                await checkAutoLiveActivity()
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
        case .didUpdateLiveActivity:
            Task {
                await updateAutoLiveActivity()
            }
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
                LiveActivityManager.endLiveActivity()
            }
        } catch {
            print("failed to logout: ", error)
        }
    }
    
    @MainActor
    private func checkAutoLiveActivity() async {
        let status = getLiveActivityUseCase.execute()
        if status {
            do {
                let todos = try await getToDoListUseCase.execute().toModels()
                let getTodayTodos = todos.filter { $0.startDateInDate!.isInSameDay(Date()) }
                LiveActivityManager.startLiveActivity(for: state.profile.fullName, with: getTodayTodos)
                state.isEnableLiveActivity = status
            } catch {
                print("Failed to load todos")
            }
        }
        
    }
    
    @MainActor
    private func updateAutoLiveActivity() async {
        do {
            try updateLiveActivityUseCase.execute(isEnabled: !state.isEnableLiveActivity)
            state.isEnableLiveActivity.toggle()
            if !state.isEnableLiveActivity {
                LiveActivityManager.endLiveActivity()
            }
            await checkAutoLiveActivity()
        } catch {
            print("Failed to update live activity status")
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
        var isEnableLiveActivity: Bool = false
    }
    
    enum Action {
        case didLoad
        case didTapLogout
        case didLogout
        case didTapEditProfile
        case didSuccessUpdateProfile
        case didUpdateLiveActivity
    }
}
