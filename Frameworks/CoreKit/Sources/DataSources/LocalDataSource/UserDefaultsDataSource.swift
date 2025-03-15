//
//  UserDefaultsDataSource.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 13/02/25.
//

import Foundation

// MARK: - UserDefaults Implementation
public class UserDefaultsDataSource: LocalDataSource {
    private let defaults = UserDefaults.standard
    public static let current: LocalDataSource = UserDefaultsDataSource()
    
    private init() {}
    
    public func get<T>(forKey key: String) -> T? where T: Codable {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    public func update<T>(_ data: T, forKey key: String) throws where T: Codable {
        let encodedData = try JSONEncoder().encode(data)
        defaults.set(encodedData, forKey: key)
    }
    
    public func delete(forKey key: String) throws {
        defaults.removeObject(forKey: key)
    }
}
