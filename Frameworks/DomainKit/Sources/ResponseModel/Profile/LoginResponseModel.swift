//
//  LoginResponseModel.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation

public struct LoginResponseModel: Codable {
    public let accessToken: String?
    public let userID: UserIDResponseModel?
    
    public struct UserIDResponseModel: Codable {
        public let id: String
    }
}
