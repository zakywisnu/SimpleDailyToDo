//
//  RemoteDataSourceFactory.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation
import ZeroNetwork
import ZeroCoreKit

public final class RemoteDataSourceFactory {
    public enum DataSourceType {
        case urlSession
    }
    
    public enum URLType {
        case localhost
        case custom
    }
    
    public class func create(_ type: DataSourceType, urlType: URLType) -> RemoteDataSource {
        switch type {
        case .urlSession:
            return StandardRemoteDataSource(
                httpClient: URLSessionHTTPClient(),
                configuration: genereateConfiguration(type: urlType)
            )
        }
    }
}

extension RemoteDataSourceFactory {
    static func genereateConfiguration(type: URLType) -> RemoteConfiguration {
        switch type {
        case .localhost:
            return .init(domain: "127.0.0.1:8080", scheme: "http")
        case .custom:
            return .init(domain: "", scheme: "")
        }
    }
}

struct RemoteDataSourceKey: InjectedKey {
    static var currentValue = StandardRemoteDataSource(
        httpClient: URLSessionHTTPClient(),
        configuration: .init(domain: "127.0.0.1:8080", scheme: "http")
    ) as RemoteDataSource
}

public extension InjectedValues {
    var remoteDataSource: RemoteDataSource {
        get { self[RemoteDataSourceKey.self] }
        set { self[RemoteDataSourceKey.self] = newValue }
    }
}
