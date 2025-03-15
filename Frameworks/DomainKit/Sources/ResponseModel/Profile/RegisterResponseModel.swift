//
//  RegisterResponseModel.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation

public struct RegisterResponseModel: Codable {
    public let email: String?
    public let firstName: String?
    public let lastName: String?
}
