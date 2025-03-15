//
//  EditProfileViewModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 28/02/25.
//

import Foundation
import DomainKit

final class EditProfileViewModel: ObservableObject {
    @Published var state: State
    
    let onSuccess: () -> Void
    
    private var editProfileUseCase: UpdateProfileUseCase = StandardUpdateProfileUseCase()
    
    init(profile: ProfileModel, onSuccess: @escaping () -> Void) {
        self.state = .init(profile: profile)
        self.onSuccess = onSuccess
    }
    
    func send(_ action: Action) {
        switch action {
        case .didSubmit:
            Task {
                await updateProfile()
            }
        }
    }
}

extension EditProfileViewModel {
    
    @MainActor
    private func updateProfile() async {
        do {
            let param = UpdateProfileParam(firstName: state.profile.firstName, lastName: state.profile.lastName, email: state.profile.email, userImage: nil)
            let _ = try await editProfileUseCase.execute(param: param)
            state.isSuccessUpdate = true
            onSuccess()
        } catch {
            state.toast = Toast(message: "Failed to update profile", style: .error)
        }
    }
}

extension EditProfileViewModel {
    struct State {
        var profile: ProfileModel
        var isLoading: Bool = false
        var toast: Toast?
        var isSuccessUpdate: Bool = false
    }
    
    enum Action {
        case didSubmit
    }
}
