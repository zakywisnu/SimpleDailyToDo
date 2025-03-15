//
//  ProfileRepositoryFactory.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 18/02/25.
//

import Foundation
import ZeroCoreKit

public final class ProfileRepositoryFactory {
    public class func create() -> ProfileRepository {
        ProfileRepositoryKey.currentValue
    }
}

struct ProfileRepositoryKey: InjectedKey {
    static var currentValue: ProfileRepository = StandardProfileRepository()
}

public extension InjectedValues {
    var profileRepository: ProfileRepository {
        get { ProfileRepositoryKey.currentValue }
        set { ProfileRepositoryKey.currentValue = newValue }
    }
}
