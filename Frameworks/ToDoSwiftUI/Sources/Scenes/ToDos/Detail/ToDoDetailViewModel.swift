//
//  ToDoDetailViewModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 12/03/25.
//

import SwiftUI
import DomainKit

final class ToDoDetailViewModel: ObservableObject {
    @Published var state: State
    private var router: StandardSwiftUIRouter?
    
    private let detailUseCase: GetToDoByIdUseCase = StandardGetToDoByIdUseCase()
    private let deleteToDoUseCase: DeleteToDoUseCase = StandardDeleteToDoUseCase()
    private let updateToDoUseCase: UpdateToDoUseCase = StandardUpdateToDoUseCase()
    
    private let onSuccessDelete: () -> Void
    private let onSuccessUpdate: () -> Void
    
    init(_ todoId: String, param: DetailToDoParam) {
        state = State(todoId: todoId)
        self.onSuccessDelete = param.onSuccessDelete
        self.onSuccessUpdate = param.onSuccessUpdate
    }
    
    func send(_ action: Action) {
        switch action {
        case .didLoad:
            state.viewState = .loading
            Task {
                await loadToDo()
            }
        case .didTapDelete:
            state.isShowDeleteConfirmation = true
        case .didDelete:
            state.isLoading = true
            Task {
                await deleteToDo()
            }
        case .didTapEdit:
            state.isShowEditToDo = true
        case .didSuccessEditToDo:
            state.toast = Toast(message: "Successfully edited to do", style: .success)
            onSuccessUpdate()
            send(.didLoad)
        case .updateToDoStatus:
            state.isLoading = true
            Task {
                await updateToDoStatus(state.task)
            }
        }
    }
    
    func setup(router: StandardSwiftUIRouter) {
        self.router = router
    }
}

extension ToDoDetailViewModel {
    @MainActor
    private func loadToDo() async {
        defer { state.isLoading = false }
        do {
            try await Task.sleep(for: .seconds(1))
            state.task = try await detailUseCase.execute(state.todoId).toModel()
            state.viewState = .loaded
        } catch {
            state.viewState = .error
            state.toast = Toast(message: "Failed to load to do", style: .error)
        }
    }
    
    @MainActor
    private func deleteToDo() async {
        defer {
            state.isLoading = false
        }
        do {
            try await Task.sleep(for: .seconds(1))
            try await deleteToDoUseCase.execute(id: state.todoId)
            onSuccessDelete()
            router?.pop()
        } catch {
            state.viewState = .error
            state.toast = Toast(message: "Failed to delete to do", style: .error)
        }
    }
    
    @MainActor
    private func updateToDoStatus(_ todo: ToDoModel) async {
        do {
            guard let startDate = todo.startDateInDate, let endDate = todo.lastDateInDate else {
                return
            }
            try await Task.sleep(for: .seconds(2))
            let param = UpdateToDoParam(
                title: todo.title,
                description: todo.description,
                status: todo.status == .complete ? .incomplete : .complete,
                tags: todo.tags,
                icon: todo.icon,
                category: todo.category.name,
                startDate: startDate.ISO8601Format(),
                endDate: endDate.ISO8601Format()
            )
            try await updateToDoUseCase.execute(param, todo.todoId)
            state.toast = Toast(message: "Successfully updated", style: .success)
            onSuccessUpdate()
            send(.didLoad)
        } catch {
            self.state.isLoading = false
            state.toast = Toast(message: "Failed to update to do", style: .error)
        }
    }
}

extension ToDoDetailViewModel {
    struct State {
        var todoId: String
        var isLoading: Bool = false
        var task: ToDoModel = .dummy
        var viewState: ViewState = .loading
        var isShowDeleteConfirmation: Bool = false
        var isShowEditToDo: Bool = false
        var toast: Toast?
        var shouldShowLoadingIndicator: Bool {
            isLoading || viewState == .loading
        }
    }
    
    enum Action {
        case didLoad
        case didTapDelete
        case didDelete
        case didTapEdit
        case didSuccessEditToDo
        case updateToDoStatus
    }
    
    enum ViewState {
        case loading
        case loaded
        case error
    }
}
