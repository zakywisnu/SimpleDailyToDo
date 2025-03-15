//
//  RegisterUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation
import ZeroCoreKit

public struct RegisterParam: Codable {
    public let email: String
    public let password: String
    public let firstName: String
    public let lastName: String
    
    public init(email: String, password: String, firstName: String, lastName: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
}

public protocol RegisterUseCase {
    func execute(username: String, password: String, firstName: String, lastName: String) async throws -> RegisterResponseModel
}

public struct StandardRegisterUseCase: RegisterUseCase {
    @Injected(\.profileRepository)
    var profileRepository: ProfileRepository
    
    public init() {}
    
    public func execute(username: String, password: String, firstName: String, lastName: String) async throws -> RegisterResponseModel {
        try await profileRepository.registerUser(
            param: RegisterParam(
                email: username,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
        )
    }
}
