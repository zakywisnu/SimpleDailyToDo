//
//  ProfileResponseModel.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation

public struct ProfileResponseModel: Codable {
    public let id: String?
    public let firstName: String?
    public let lastName: String?
    public let email: String?
    public let userImage: String?
    
    public static func empty() -> ProfileResponseModel {
        return .init(
            id: nil,
            firstName: nil,
            lastName: nil,
            email: nil,
            userImage: nil
        )
    }
}
