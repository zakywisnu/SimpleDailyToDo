//
//  NamespaceWrapper.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 25/02/25.
//

import SwiftUI

class NamespaceWrapper: ObservableObject {
    var namespace: Namespace.ID

    init(_ namespace: Namespace.ID) {
        self.namespace = namespace
    }
}
