//
//  ProfileModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 21/02/25.
//

import Foundation
import DomainKit

public struct ProfileModel: Hashable {
    public let id: String
    public var firstName: String
    public var lastName: String
    public var email: String
    public let userImage: String
    
    public static var empty: ProfileModel {
        return ProfileModel(
            id: "",
            firstName: "",
            lastName: "",
            email: "",
            userImage: ""
        )
    }
    
    public static var dummy: ProfileModel {
        return ProfileModel(
            id: "1234567890",
            firstName: "Ahmad",
            lastName: "Zaky",
            email: "ahmadzakyw@gmail.com",
            userImage: ""
        )
    }
}

extension ProfileResponseModel {
    public func toModel() -> ProfileModel {
        return ProfileModel(
            id: id ?? "",
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            email: email ?? "",
            userImage: userImage ?? ""
        )
    }
}
