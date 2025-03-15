//
//  UpdateProfileUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation
import ZeroCoreKit

public struct UpdateProfileParam: Codable {
    public let firstName: String?
    public let lastName: String?
    public let email: String?
    public let userImage: UserImage?
    
    public init(firstName: String?, lastName: String?, email: String?, userImage: UserImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userImage = userImage
    }
    
    public struct UserImage: Codable {
        public let file: Data?
        public let filename: String?
        public let mimeType: String?
        
        public init(file: Data?, filename: String?, mimeType: String?) {
            self.file = file
            self.filename = filename
            self.mimeType = mimeType
        }
    }
}

public protocol UpdateProfileUseCase {
    func execute(param: UpdateProfileParam) async throws -> ProfileResponseModel
}

public struct StandardUpdateProfileUseCase: UpdateProfileUseCase {
    @Injected(\.profileRepository)
    var profileRepository: ProfileRepository
    
    public init() {}
    
    public func execute(param: UpdateProfileParam) async throws -> ProfileResponseModel {
        try await profileRepository.updateProfile(param: param)
    }
}
