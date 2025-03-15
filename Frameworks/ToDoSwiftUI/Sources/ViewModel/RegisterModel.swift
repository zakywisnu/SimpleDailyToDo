//
//  RegisterModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 21/02/25.
//

import Foundation
import DomainKit

struct RegisterModel {
    let email: String
    let firstName: String
    let lastName: String
}

extension RegisterResponseModel {
    func toModel() -> RegisterModel {
        return RegisterModel(
            email: email ?? "",
            firstName: firstName ?? "",
            lastName: lastName ?? ""
        )
    }
}
