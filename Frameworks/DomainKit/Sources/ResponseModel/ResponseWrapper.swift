//
//  ResponseWrapper.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation

public struct ResponseWrapper<Data: Codable>: Codable {
    public let data: Data?
    public let status: Int?
    public let message: String?
    public let error: String?
}
