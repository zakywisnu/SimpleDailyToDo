//
//  LocalDataSource.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 12/02/25.
//

import Foundation

protocol LocalDataSource {
    associatedtype DataType: Codable
    
    /// Fetches the stored data.
    /// - Returns: The stored data if available, otherwise nil.
    func get(forKey key: String) -> DataType?
    
    /// Updates or stores new data.
    /// - Parameters:
    ///   - data: The data to store.
    ///   - key: The key under which the data should be stored.
    func update(_ data: DataType, forKey key: String) throws
    
    /// Deletes the data for a given key.
    /// - Parameter key: The key of the data to delete.
    func delete(forKey key: String) throws
}
