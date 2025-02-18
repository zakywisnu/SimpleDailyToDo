//
//  APIError.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 12/02/25.
//

import Foundation
import ZeroNetwork

public enum APIError: Error {
    case networkError(URLError)
    case apiError(status: Int, body: Data?)
    case parsingError(DecodingError)

    public func toErrorResponse() -> APIErrorResponse? {
        if case let .apiError(_, body) = self {
            do {
                let response = try JSONDecoder().decode(APIErrorResponse.self, from: body ?? .init())
                return response
            } catch {
                print(String(describing: error))
                return nil
            }
        }
        return nil
    }

    public func toErrorResponse<T: Decodable>(type _: T.Type) -> T? {
        if case let .apiError(_, body) = self {
            do {
                let response = try JSONDecoder().decode(T.self, from: body ?? .init())
                return response
            } catch {
                print(String(describing: error))
                return nil
            }
        }
        return nil
    }

    public func getApiErrorStatus() -> Int? {
        if case let .apiError(status, _) = self {
            return status
        }
        return nil
    }
}

public struct APIErrorResponseBody: Codable {
    public let errorMessage: String?
    public let errorCode: String?

    public init(errorMessage: String? = nil, errorCode: String? = nil) {
        self.errorMessage = errorMessage
        self.errorCode = errorCode
    }
}

public struct APIErrorResponse: Codable, Error {
    public let statusCode: Int?
    public let apiError: APIErrorResponseBody?

    public init(statusCode: Int? = nil, apiError: APIErrorResponseBody? = nil) {
        self.statusCode = statusCode
        self.apiError = apiError
    }
}
