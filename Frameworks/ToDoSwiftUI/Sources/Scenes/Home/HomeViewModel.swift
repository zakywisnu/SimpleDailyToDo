//
//  HomeViewModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 24/02/25.
//

import SwiftUI
import DomainKit
import CoreKit

public final class HomeViewModel: ObservableObject {
    @Published var state: State
    private var router: StandardSwiftUIRouter?
    
    private let profileUseCase: GetProfileUseCase = StandardGetProfileUseCase()
    private let getToDoListUseCase: GetToDoListUseCase = StandardGetToDoListUseCase()
    private let updateToDoUseCase: UpdateToDoUseCase = StandardUpdateToDoUseCase()
    private let getLiveActivityUseCase: GetAutoLiveActivityStatusUseCase = StandardGetAutoLiveActivityStatusUseCase()
    
    init() {
        self.state = State()
    }
    
    func send(_ action: Action) {
        switch action {
        case let .didTapProfile(namespace):
            router?.push(to: .user(.profile(namespace)))
        case .didLoad:
            Task {
                await getProfile()
                send(.didLoadToDos)
            }
        case .didCreateToDo:
            state.isShowCreateToDoSheet = true
        case .didSuccessCreateToDo:
            state.toast = Toast(message: "Successfully created to do", style: .success)
            send(.didLoadToDos)
        case .didLoadToDos:
            Task {
                await getToDos()
                await checkAutoLiveActivity()
            }
        case let .didUpdateCurrentShownWeek(week):
            state.currentWeek = week
        case let .didUpdateToDoStatus(todo):
            state.isLoading = true
            Task {
                await updateToDoStatus(todo)
            }
        case let .didNavigateDetail(todo):
            let param = DetailToDoParam { [weak self] in
                self?.state.toast = Toast(message: "Successfully delete to do", style: .success)
                self?.send(.didLoadToDos)
            } onSuccessUpdate: { [weak self] in
                self?.send(.didLoadToDos)
            }

            router?.push(to: .todo(.detail(todo.todoId, param)))
        }
    }
    
    func setup(router: StandardSwiftUIRouter) {
        self.router = router
    }
}

extension HomeViewModel {
    @MainActor
    private func getProfile() async {
        do {
            let profile = try await profileUseCase.execute()
            state.profile = profile.toModel()
            state.viewState = .loaded
        } catch {
            print("error profile: ", error)
        }
    }
    
    @MainActor
    private func getToDos() async {
        defer {
            DispatchQueue.main.async {
                self.state.isLoading = false
            }
        }
        do {
            let todos = try await getToDoListUseCase.execute()
            state.todos = todos.toModels()
        } catch {
            if let error = error as? APIError {
                state.toast = Toast(message: error.localizedDescription, style: .error)
            }
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
            send(.didLoadToDos)
        } catch {
            self.state.isLoading = false
            if let error = error as? APIError {
                state.toast = Toast(message: error.localizedDescription, style: .error)
            }
        }
    }
    
    @MainActor
    private func checkAutoLiveActivity() {
        let status = getLiveActivityUseCase.execute()
        if status && !LiveActivityManager.isLiveActivityActive() {
            LiveActivityManager.startLiveActivity(for: state.profile.fullName, with: state.getTodaysToDos)
        } else if status {
            LiveActivityManager.updateLiveActivity(with: state.getTodaysToDos)
        }
    }
}

extension HomeViewModel {
    struct State {
        var isLoading: Bool = false
        var todos: [ToDoModel] = []
        var selectedDate: Date = Calendar.current.startOfDay(for: Date())
        var selectedPicker: Int = 0
        var viewState: ViewState = .loading
        var isShowCreateToDoSheet: Bool = false
        var toast: Toast?
        var currentWeek: Week?
        var profile: ProfileModel = .empty
        var getTodaysToDos: [ToDoModel] {
            return todos.filter { $0.startDateInDate!.isInSameDay(Date()) }
        }
        var currentWeeksToDo: [ToDoModel] {
            get {
                guard let currentWeek = currentWeek,
                      let firstDate = currentWeek.firstDate,
                      let lastDate = currentWeek.lastDate
                else
                { return [] }
                return todos.getToDosWeek(from: firstDate, to: lastDate)
            } set {  }
        }
        
        var selectedDateToDos: [ToDoModel] {
            get {
                return todos.filter { $0.startDateInDate!.isInSameDay(selectedDate) }
                    .sorted(by: { $0.status > $1.status })
            } set { }
        }
        
        var tasksOverview: [ToDoModel] {
            if selectedPicker == 0 {
                return selectedDateToDos
            } else {
                return currentWeeksToDo
            }
        }
    }
    
    enum Action {
        case didTapProfile(Namespace.ID)
        case didLoad
        case didCreateToDo
        case didSuccessCreateToDo
        case didLoadToDos
        case didUpdateCurrentShownWeek(Week)
        case didUpdateToDoStatus(ToDoModel)
        case didNavigateDetail(ToDoModel)
    }
    
    enum ViewState {
        case loading
        case loaded
        case error
    }
}
