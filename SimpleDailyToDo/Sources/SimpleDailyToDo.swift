import UIKit
import DomainKit

final class DummyViewController: UIViewController {
    
    private var loginUseCase: LoginUseCase = StandardLoginUseCase()
    private var registerUseCase: RegisterUseCase = StandardRegisterUseCase()
    private var getProfileUseCase: GetProfileUseCase = StandardGetProfileUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await login()
//            await getProfile()
        }
    }
    
    private func login() async {
        do {
            let data = try await loginUseCase.execute(username: "zakysit0@gmail.com", password: "Masuk123")
            print("success login: ", data)
        } catch {
            print("failed to login:", error)
        }
    }
    
    @MainActor
    private func register() async {
        do {
            let data = try await registerUseCase.execute(username: "zakysit0@gmail.com", password: "Masuk123", firstName: "Soft Green", lastName: "Spring")
            print("success register: ", data)
        } catch {
            print("failed to register:", error)
        }
    }
    
    private func getProfile() async {
        do {
            let data = try await getProfileUseCase.execute()
            print("success get profile: ", data)
        } catch {
            print("failed to getprofile:", error)
        }
    }
}
