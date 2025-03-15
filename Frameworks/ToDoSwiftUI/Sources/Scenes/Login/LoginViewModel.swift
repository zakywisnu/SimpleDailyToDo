//
//  LoginViewModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 24/02/25.
//

import SwiftUI
import DomainKit

final class LoginViewModel: ObservableObject {
    var router: SwiftUIRouter?
    @Published var state: State
    
    private let loginUseCase: LoginUseCase = StandardLoginUseCase()
    
    init() {
        self.state = State()
    }
    
    func send(_ action: Action) {
        switch action {
        case .didSubmit:
            state.isLoading = true
            
            Task {
                await login()
            }
        case .didTapRegister:
            let param = RegisterRouteParam { [weak self] email in
                guard let self else { return }
                self.state.email = email
            }
            router?.push(to: .auth(.register(param)))
        }
    }
    
    func setup(router: SwiftUIRouter) {
        self.router = router
    }
}

extension LoginViewModel {
    
    @MainActor
    private func login() async {
        defer {
            state.isLoading = false
        }
        do {
            let _ = try await loginUseCase.execute(username: state.email.lowercased(), password: state.password)
            router?.setRoot(to: .home)
        } catch {
            print("failed to login: ", error)
        }
    }
}

extension LoginViewModel {
    struct State {
        var email: String = ""
        var password: String = ""
        var isFormValid: Bool {
            !email.isEmpty && !password.isEmpty
        }
        var isLoading: Bool = false
    }
    
    enum Action {
        case didSubmit
        case didTapRegister
    }
}
