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
    
    public func post<RequestBody, ResponseBody>(
        _ endpoint: any RemoteEndpoint,
        queries: [String : String]?,
        body: RequestBody?,
        for type: ResponseBody.Type
    ) async throws -> ResponseBody? where RequestBody : Encodable, ResponseBody : Decodable {
        try await executeRequest(
            endpoint,
            queries: queries,
            requestBody: body.encoded(),
            method: .post,
            for: type
        )
    }
    
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
    
//    public func upload<ResponseBody>(
//        _ endpoint: any RemoteEndpoint,
//        body: Data?,
//        boundary: String,
//        queries: [String : String]?,
//        for type: ResponseBody.Type
//    ) async throws -> ResponseBody where ResponseBody : Decodable {
//        <#code#>
//    }
}

extension StandardRemoteDataSource {
    private func executeRequest<ResponseBody: Decodable>(
        _ endpoint: RemoteEndpoint,
        queries: [String: String]?,
        requestBody: Data?,
        method: HTTPMethod,
        contentType: String = "application/json",
        for _: ResponseBody.Type
    ) async throws -> ResponseBody {
        let url = try makeURL(with: endpoint.path, queries: queries)
        let request = await makeRequest(
            with: url,
            method: method.rawValue,
            requestBody: requestBody,
            contentType: contentType
        )

        do {
            let (responseBody, response) = try await httpClient
                .executeWithJSONDecoding(request, for: ResponseBody.self)
                .get()

            return responseBody
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
        guard let baseURL = urlComponent.url else {
            throw APIError.networkError(.init(.badURL))
        }
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
        contentType: String = "application/json"
    ) async -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = requestBody
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        return request
    }
}

private extension Encodable {
    func encoded() -> Data? {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
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
