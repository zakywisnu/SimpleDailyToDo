//
//  LoginModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 21/02/25.
//

import Foundation
import DomainKit

struct LoginModel {
    let accessToken: String
    let userID: UserIDModel
    
    struct UserIDModel {
        let id: String
    }
}

extension LoginResponseModel {
    func toModel() -> LoginModel {
        return LoginModel(
            accessToken: accessToken ?? "",
            userID: toUserIDModel()
        )
    }
    
    func toUserIDModel() -> LoginModel.UserIDModel {
        return LoginModel.UserIDModel(id: userID?.id ?? "")
    }
}
