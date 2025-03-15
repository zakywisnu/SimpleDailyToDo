//
//  CategoryRepository.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit
import CoreKit

public protocol CategoryRepository {
    func getCategories() async throws -> [CategoryResponseModel]
}

struct StandardCategoryRepository: CategoryRepository {
    
    @Injected(\.remoteDataSource)
    var remoteDataSource: RemoteDataSource
    
    func getCategories() async throws -> [CategoryResponseModel] {
        try await remoteDataSource.get(ToDoEndpoint.category, queries: nil, for: [CategoryResponseModel].self)
    }
}
