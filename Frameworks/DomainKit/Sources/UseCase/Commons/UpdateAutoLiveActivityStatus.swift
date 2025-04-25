//
//  UpdateAutoLiveActivityStatus.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 24/04/25.
//

import Foundation
import ZeroCoreKit

public protocol UpdateAutoLiveActivityStatusUseCase {
    func execute(isEnabled: Bool) throws
}

public struct StandardUpdateAutoLiveActivityStatusUseCase: UpdateAutoLiveActivityStatusUseCase {
    @Injected(\.commonsRepository)
    var commonsRepository: CommonsRepository
    
    public init() {}
    
    public func execute(isEnabled: Bool) throws {
        return try commonsRepository.updateAutoLiveActivityStatus(status: isEnabled)
    }
}

