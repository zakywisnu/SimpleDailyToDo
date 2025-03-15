//
//  LoginUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation
import ZeroCoreKit

public struct LoginParam: Codable {
    public let username: String
    public let password: String
}

public protocol LoginUseCase {
    func execute(username: String, password: String) async throws -> LoginResponseModel
}

public struct StandardLoginUseCase: LoginUseCase {
    @Injected(\.profileRepository)
    var profileRepository: ProfileRepository
    
    public init() {}
    
    public func execute(username: String, password: String) async throws -> LoginResponseModel {
        try await profileRepository.loginUser(param: LoginParam(username: username, password: password))
    }
}
