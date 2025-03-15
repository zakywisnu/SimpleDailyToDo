//
//  LogoutUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 03/03/25.
//

import Foundation
import ZeroCoreKit

public protocol LogoutUseCase {
    func execute() async throws -> Bool
}

public final class StandardLogoutUseCase: LogoutUseCase {
    
    @Injected(\.profileRepository)
    var profileRepository: ProfileRepository
    
    public init() {}
    
    public func execute() async throws -> Bool {
        try await profileRepository.logout()
    }
}
