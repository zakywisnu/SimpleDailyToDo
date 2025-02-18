//
//  RemoteConfiguration.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 12/02/25.
//

import Foundation

public struct RemoteConfiguration {
    public let domain: String
    public let scheme: String
    
    public final class Builder {
        private var domain: String = "127.0.0.1:8080"
        private var scheme: String = "http"
        
        public func withDomain(_ domain: String) -> Self {
            self.domain = domain
            return self
        }
        
        public func withScheme(_ scheme: String) -> Self {
            self.scheme = scheme
            return self
        }
        
        public func build() -> RemoteConfiguration {
            return .init(domain: domain, scheme: scheme)
        }
    }
}
