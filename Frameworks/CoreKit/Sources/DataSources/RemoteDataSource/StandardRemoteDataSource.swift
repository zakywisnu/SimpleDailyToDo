//
//  StandardRemoteDataSource.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 12/02/25.
//

import Foundation
import ZeroNetwork

public class StandardRemoteDataSource {
    let httpClient: HTTPClient
    let configuration: RemoteConfiguration

    public init(httpClient: HTTPClient, configuration: RemoteConfiguration) {
        self.httpClient = httpClient
        self.configuration = configuration
    }
}

extension StandardRemoteDataSource: RemoteDataSource {
    @discardableResult
    public func get<ResponseBody>(
        _ endpoint: any RemoteEndpoint,
        queries: [String : String]?,
        for type: ResponseBody.Type
    ) async throws -> ResponseBody where ResponseBody : Decodable {
        try await executeRequest(
            endpoint,
            queries: queries,
            requestBody: nil,
            method: .get,
            for: type
        )
    }
    
    @discardableResult
    public func post<RequestBody, ResponseBody>(
        _ endpoint: any RemoteEndpoint,
        queries: [String : String]?,
        headers: [String: String]?,
        body: RequestBody?,
        for type: ResponseBody.Type
    ) async throws -> ResponseBody? where ResponseBody : Decodable, RequestBody: Encodable {
        try await executeRequestWithOptional(
            endpoint,
            queries: queries,
            requestBody: body.encoded(),
            headers: headers,
            method: .post,
            for: type
        )
    }
    
    @discardableResult
    public func delete<ResponseBody>(
        _ endpoint: any RemoteEndpoint,
        for type: ResponseBody.Type
    ) async throws -> ResponseBody? where ResponseBody : Decodable {
        try await executeRequest(
            endpoint,
            queries: nil,
            requestBody: nil,
            method: .delete,
            for: type
        )
    }
    
    @discardableResult
    public func upload<ResponseBody>(
        _ endpoint: any RemoteEndpoint,
        body: Data?,
        boundary: String,
        queries: [String : String]?,
        for type: ResponseBody.Type
    ) async throws -> ResponseBody where ResponseBody : Decodable {
        try await executeRequest(
            endpoint,
            queries: queries,
            requestBody: body,
            method: .post,
            contentType: "multipart/form-data; boundary=\(boundary)",
            for: type
        )
    }
    
    @discardableResult
    public func patch<RequestBody, ResponseBody>(
        _ endpoint: any RemoteEndpoint,
        queries: [String : String]?,
        headers: [String : String]?,
        body: RequestBody?,
        for type: ResponseBody.Type
    ) async throws -> ResponseBody? where RequestBody : Encodable, ResponseBody : Decodable {
        try await executeRequestWithOptional(
            endpoint,
            queries: queries,
            requestBody: body.encoded(),
            headers: headers,
            method: .patch,
            for: type
        )
    }
}

extension StandardRemoteDataSource {
    private func executeRequest<ResponseBody: Decodable>(
        _ endpoint: RemoteEndpoint,
        queries: [String: String]?,
        requestBody: Data?,
        headers: [String: String]? = nil,
        method: HTTPMethod,
        contentType: String = "application/json",
        for _: ResponseBody.Type
    ) async throws -> ResponseBody {
        let url = try makeURL(with: endpoint.path, queries: queries)
        let request = await makeRequest(
            with: url,
            method: method.rawValue,
            requestBody: requestBody,
            contentType: contentType,
            headers: headers
        )

        do {
            let (responseBody, _) = try await httpClient
                .executeWithJSONDecoding(request, for: ResponseWrapper<ResponseBody>.self)
                .get()

            guard let response = responseBody.data else {
                throw APIError.apiError(status: -999, body: String("failed to decode").data(using: .utf8))
            }
            return response
        } catch let error as HTTPError {
            let apiError = error.toDomainEntity()
            throw apiError
        } catch {
            throw APIError.networkError(.init(.unknown))
        }
    }
    
    private func executeRequestWithOptional<ResponseBody: Decodable>(
        _ endpoint: RemoteEndpoint,
        queries: [String: String]?,
        requestBody: Data?,
        headers: [String: String]? = nil,
        method: HTTPMethod,
        contentType: String = "application/json",
        for _: ResponseBody.Type
    ) async throws -> ResponseBody? {
        let url = try makeURL(with: endpoint.path, queries: queries)
        let request = await makeRequest(
            with: url,
            method: method.rawValue,
            requestBody: requestBody,
            contentType: contentType,
            headers: headers
        )

        do {
            let result = try await httpClient
                .executeWithJSONDecoding(request, for: ResponseWrapper<ResponseBody>.self)
                .get()
            
            return result.0.data
        } catch let error as HTTPError {
            let apiError = error.toDomainEntity()
            throw apiError
        } catch {
            throw APIError.networkError(.init(.unknown))
        }
    }
    
    private func makeURL(
        with endPoint: String,
        queries: [String: String]? = nil
    ) throws -> URL {
        var urlComponent = URLComponents()
        urlComponent.scheme = configuration.scheme
        urlComponent.host = configuration.domain
        let baseURL = URL(string: "\(configuration.scheme)://\(configuration.domain)")!
        var url = baseURL.appendingPathComponent(endPoint)
        if let queries = queries, !queries.isEmpty {
            let queryString = queries.map {
                "\($0.key.urlEncoded)=\($0.value.urlEncoded)"
            }.joined(separator: "&")
            url = URL(string: url.absoluteString + "?" + queryString) ?? url
        }
        return url
    }
    
    private func makeRequest(
        with url: URL,
        method: String,
        requestBody: Data?,
        contentType: String = "application/json",
        headers: [String: String]? = nil
    ) async -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = requestBody
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        if let headers = headers {
            headers.forEach {
                if $0.key == "login_credentials" {
                    let result = makeBasicAuthHeaders(credentials: $0.value)
                    request.setValue(result, forHTTPHeaderField: "Authorization")
                } else {
                    request.addValue($0.value, forHTTPHeaderField: $0.key)
                }
            }
        }
        
        if let auth: String = UserDefaultsDataSource.current.get(forKey: "accessToken"), !auth.isEmpty {
            request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func makeBasicAuthHeaders(credentials: String) -> String {
        guard let credentialsData = credentials.data(using: .utf8) else {
            return ""
        }
        let base64Credentials = credentialsData.base64EncodedString()
        return "Basic \(base64Credentials)"
    }
}

public extension Encodable {
    func encoded() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try? encoder.encode(self)
    }
}

private extension CharacterSet {
    static var urlAllowed: CharacterSet {
        .alphanumerics.union(.init(charactersIn: "-._~"))
    }
}

private extension String {
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlAllowed) ?? self
    }
}

private extension HTTPError {
    func toDomainEntity() -> APIError {
        switch self {
        case let .networkError(error):
            return .networkError(error)
        case let .parsingError(error):
            return .parsingError(error)
        case let .apiError(response):
            return .apiError(status: response.statusCode, body: response.rawData)
        }
    }
}
