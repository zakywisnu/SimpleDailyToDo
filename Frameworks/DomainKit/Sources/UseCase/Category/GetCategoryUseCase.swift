//
//  GetCategoryUseCase.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit

public protocol GetCategoryUseCase {
    func execute() async throws -> [CategoryResponseModel]
}

public struct StandardGetCategoryUseCase: GetCategoryUseCase {
    @Injected(\.categoryRepository)
    var categoryRepository: CategoryRepository
    
    public init() {}
    
    public func execute() async throws -> [CategoryResponseModel] {
        return try await categoryRepository.getCategories()
    }
}
