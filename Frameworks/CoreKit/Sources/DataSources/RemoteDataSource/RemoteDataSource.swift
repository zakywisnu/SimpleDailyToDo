//
//  RemoteDataSource.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 12/02/25.
//

import Foundation

public struct NoContent: Codable, Equatable {}

public protocol RemoteDataSource {
    func get<ResponseBody>(
        _ endpoint: RemoteEndpoint,
        queries: [String: String]?,
        for type: ResponseBody.Type
    ) async throws -> ResponseBody where ResponseBody: Decodable

    func post<RequestBody, ResponseBody>(
        _ endpoint: RemoteEndpoint,
        queries: [String: String]?,
        body: RequestBody?,
        for type: ResponseBody.Type
    ) async throws -> ResponseBody? where ResponseBody: Decodable, RequestBody: Encodable

    func delete<ResponseBody>(
        _ endpoint: RemoteEndpoint,
        for type: ResponseBody.Type
    ) async throws -> ResponseBody? where ResponseBody: Decodable

//    func upload<ResponseBody>(
//        _ endpoint: RemoteEndpoint,
//        body: Data?,
//        boundary: String,
//        queries: [String: String]?,
//        for type: ResponseBody.Type
//    ) async throws -> ResponseBody where ResponseBody: Decodable
}
