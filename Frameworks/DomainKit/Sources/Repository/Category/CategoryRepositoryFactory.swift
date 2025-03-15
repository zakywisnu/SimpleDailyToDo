//
//  CategoryRepositoryFactory.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit

public final class CategoryRepositoryFactory {
    public class func create() -> CategoryRepository {
        CategoryRepositoryKey.currentValue
    }
}

struct CategoryRepositoryKey: InjectedKey {
    static var currentValue: CategoryRepository = StandardCategoryRepository()
}

public extension InjectedValues {
    var categoryRepository: CategoryRepository {
        get { CategoryRepositoryKey.currentValue }
        set { CategoryRepositoryKey.currentValue = newValue }
    }
}

