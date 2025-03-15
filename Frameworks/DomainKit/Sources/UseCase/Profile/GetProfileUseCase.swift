//
//  GetProfileUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 13/02/25.
//

import Foundation
import ZeroCoreKit

public protocol GetProfileUseCase {
    func execute() async throws -> ProfileResponseModel
}

public struct StandardGetProfileUseCase: GetProfileUseCase {
    @Injected(\.profileRepository)
    var profileRepository: ProfileRepository
    
    public init() {}
    
    public func execute() async throws -> ProfileResponseModel {
        try await profileRepository.getProfile()
    }
}
