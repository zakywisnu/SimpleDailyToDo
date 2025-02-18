//
//  RemoteEndpoint.swift
//  CoreKit
//
//  Created by Ahmad Zaky W on 12/02/25.
//

import Foundation

public protocol RemoteEndpoint {
    var path: String { get }
    init (path: String)
}
