//
//  ToDoRepository.swift
//  DomainKit
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import Foundation
import ZeroCoreKit
import CoreKit

public protocol ToDoRepository {
    func getToDoLists() async throws -> [ToDoResponseModel]
    func getToDoByID(_ id: String) async throws -> ToDoResponseModel
    func createToDo(_ param: CreateToDoParam) async throws
    func updateToDo(_ param: UpdateToDoParam, _ id: String) async throws -> ToDoResponseModel?
    func deleteToDo(_ id: String) async throws
}

struct StandardToDoRepository: ToDoRepository {
    
    @Injected(\.remoteDataSource)
    var remoteDataSource: RemoteDataSource
    
    func getToDoLists() async throws -> [ToDoResponseModel] {
        return try await remoteDataSource.get(ToDoEndpoint.todo, queries: nil, for: [ToDoResponseModel].self)
    }
    
    func getToDoByID(_ id: String) async throws -> ToDoResponseModel {
        return try await remoteDataSource.get(ToDoEndpoint.todo(id), queries: nil, for: ToDoResponseModel.self)
    }
    
    func createToDo(_ param: CreateToDoParam) async throws {
        try await remoteDataSource.post(ToDoEndpoint.todo, queries: nil, headers: nil, body: param, for: DefaultEmptyResponse.self)
    }
    
    func updateToDo(_ param: UpdateToDoParam, _ id: String) async throws -> ToDoResponseModel? {
        return try await remoteDataSource.patch(ToDoEndpoint.todo(id), queries: nil, headers: nil, body: param, for: ToDoResponseModel.self)
    }
    
    func deleteToDo(_ id: String) async throws {
        try await remoteDataSource.delete(ToDoEndpoint.todo(id), for: DefaultEmptyResponse.self)
    }
}

