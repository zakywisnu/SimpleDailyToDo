//
//  UserDefaultsDataSource.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 13/02/25.
//

import Foundation

// MARK: - UserDefaults Implementation
public struct UserDefaultsDataSource<T: Codable>: LocalDataSource {
    private let defaults = UserDefaults.standard
    
    public func get(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    public func update(_ data: T, forKey key: String) throws {
        let encodedData = try JSONEncoder().encode(data)
        defaults.set(encodedData, forKey: key)
    }
    
    public func delete(forKey key: String) throws {
        defaults.removeObject(forKey: key)
    }
}
