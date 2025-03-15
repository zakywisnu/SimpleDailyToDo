//
//  ProfileRepository.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 13/02/25.
//

import Foundation
import ZeroCoreKit
import CoreKit

public protocol ProfileRepository {
    func getProfile() async throws -> ProfileResponseModel
    func registerUser(param: RegisterParam) async throws -> RegisterResponseModel
    func loginUser(param: LoginParam) async throws -> LoginResponseModel
    func updateProfile(param: UpdateProfileParam) async throws -> ProfileResponseModel
    func logout() async throws -> Bool
}

struct StandardProfileRepository: ProfileRepository {
    
    @Injected(\.remoteDataSource)
    var remoteDataSource: RemoteDataSource
    
    func getProfile() async throws -> ProfileResponseModel {
        try await remoteDataSource.get(ToDoEndpoint.profile, queries: nil, for: ProfileResponseModel.self)
    }

    func registerUser(param: RegisterParam) async throws -> RegisterResponseModel {
        try await remoteDataSource.post(
            ToDoEndpoint.register,
            queries: nil,
            headers: nil,
            body: param,
            for: RegisterResponseModel.self
        ) ?? .init(email: "", firstName: "", lastName: "")
    }
    
    func loginUser(param: LoginParam) async throws -> LoginResponseModel {
        let credentials = "\(param.username):\(param.password)"
        let headers = ["login_credentials": credentials]
        let loginData = try await remoteDataSource.post(
            ToDoEndpoint.login,
            queries: nil,
            headers: headers,
            body: DefaultEmptyRequestBody(),
            for: LoginResponseModel.self
        ) ?? .init(accessToken: "", userID: nil)
        
        try UserDefaultsDataSource.current.update(loginData.accessToken, forKey: "accessToken")
        return loginData
    }
    
    func updateProfile(param: UpdateProfileParam) async throws -> ProfileResponseModel {
        if let userImage = param.userImage {
            let request = MultipartFormDataRequest()
            if let file = userImage.file, let filename = userImage.filename, let mimeType = userImage.mimeType {
                request.addDataField(fieldName: "file", fileName: filename, data: file, mimeType: mimeType)
            }
            request.addEndField()
            
            return try await remoteDataSource.upload(
                ToDoEndpoint.updateProfile,
                body: request.body,
                boundary: request.boundary,
                queries: [:],
                for: ProfileResponseModel.self
            )
        } else {
            return try await remoteDataSource.post(
                ToDoEndpoint.updateProfile,
                queries: nil,
                headers: nil,
                body: param,
                for: ProfileResponseModel.self
            ) ?? .empty()
        }
    }
    
    func logout() async throws -> Bool {
        let response = try await remoteDataSource.post(ToDoEndpoint.logout, queries: nil, headers: nil, body: DefaultEmptyRequestBody(), for: DefaultEmptyResponse.self)
        print("responsesss : ",response)
        try UserDefaultsDataSource.current.delete(forKey: "accessToken")
        return true
    }
}
