//
//  RegisterViewModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 24/02/25.
//

import SwiftUI
import DomainKit

final class RegisterViewModel: ObservableObject {
    @Published var state: State
    var router: StandardSwiftUIRouter?
    let onSuccessRegister: (String) -> Void
    
    private let registerUseCase: RegisterUseCase = StandardRegisterUseCase()
    
    init(_ onSuccessRegister: @escaping (String) -> Void) {
        self.state = State()
        self.onSuccessRegister = onSuccessRegister
    }
    
    func send(_ action: Action) {
        switch action {
        case .didTapRegister:
            Task {
                await register()
            }
        }
    }
    
    func setup(router: StandardSwiftUIRouter) {
        self.router = router
    }
}

extension RegisterViewModel {
    @MainActor
    private func register() async {
        do {
            let _ = try await registerUseCase.execute(
                username: state.email.lowercased(),
                password: state.password,
                firstName: state.firstName,
                lastName: state.lastName
            )
            router?.pop()
            onSuccessRegister(state.email)
        } catch {
            print("failed to register: ", error)
        }
    }
}

extension RegisterViewModel {
    struct State {
        var email: String = ""
        var password: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var isFormValid: Bool {
            !email.isEmpty && !password.isEmpty && !firstName.isEmpty && !lastName.isEmpty
        }
    }
    
    enum Action {
        case didTapRegister
    }
}
