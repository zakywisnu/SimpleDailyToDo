//
//  CommonsRepository.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 24/04/25.
//

import Foundation
import ZeroCoreKit
import CoreKit

public protocol CommonsRepository {
    func updateAutoLiveActivityStatus(status isEnabled: Bool) throws
    func getAutoLiveActivityStatus() -> Bool
}

struct StandardCommonsRepository: CommonsRepository {
    
    // TODO: move userdefaults repository to use injection
    
    func updateAutoLiveActivityStatus(status isEnabled: Bool) throws {
        try UserDefaultsDataSource.current.update(
            isEnabled,
            forKey: UserDefaultsDataSourceKeys.isEnableAutoLiveActivity
        )
    }
    
    func getAutoLiveActivityStatus() -> Bool {
        if let status: Bool = UserDefaultsDataSource.current.get(forKey: UserDefaultsDataSourceKeys.isEnableAutoLiveActivity) {
            return status
        }
        return false
    }
}

