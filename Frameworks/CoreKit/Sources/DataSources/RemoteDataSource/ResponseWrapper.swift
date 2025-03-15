//
//  ResponseWrapper.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation

public struct ResponseWrapper<Data: Decodable>: Decodable {
    public let data: Data?
    public let status: Int?
    public let message: String?
    public let error: String?
}
