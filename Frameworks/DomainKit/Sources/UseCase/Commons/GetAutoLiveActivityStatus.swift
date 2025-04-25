//
//  GetAutoLiveActivityStatus.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 24/04/25.
//

import Foundation
import ZeroCoreKit

public protocol GetAutoLiveActivityStatusUseCase {
    func execute() -> Bool
}

public struct StandardGetAutoLiveActivityStatusUseCase: GetAutoLiveActivityStatusUseCase {
    @Injected(\.commonsRepository)
    var commonsRepository: CommonsRepository
    
    public init() {}
    
    public func execute() -> Bool {
        return commonsRepository.getAutoLiveActivityStatus()
    }
}

