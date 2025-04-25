//
//  CommonsRepositoryFactory.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 24/04/25.
//

import Foundation
import ZeroCoreKit

public final class CommonsRepositoryFactory {
    public class func create() -> CommonsRepository {
        CommonsRepositoryKey.currentValue
    }
}

struct CommonsRepositoryKey: InjectedKey {
    static var currentValue: CommonsRepository = StandardCommonsRepository()
}

public extension InjectedValues {
    var commonsRepository: CommonsRepository {
        get { CommonsRepositoryKey.currentValue }
        set { CommonsRepositoryKey.currentValue = newValue }
    }
}


