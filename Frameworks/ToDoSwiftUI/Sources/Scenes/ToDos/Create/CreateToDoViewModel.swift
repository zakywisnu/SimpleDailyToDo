//
//  CreateToDoViewModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import SwiftUI
import DomainKit

final class CreateToDoViewModel: ObservableObject {
    @Published var state: State
    
    private let getCategoryUseCase: GetCategoryUseCase = StandardGetCategoryUseCase()
    private let createToDoUseCase: CreateToDoUseCase = StandardCreateToDoUseCase()
    private let updateToDoUseCase: UpdateToDoUseCase = StandardUpdateToDoUseCase()
    private let onSuccessSubmit: () -> Void
    
    init(_ onSuccessSubmit: @escaping () -> Void, _ todo: ToDoModel? = nil) {
        if let todo {
            self.state = State(
                title: "Edit To Do",
                todoTitle: todo.title,
                todoDescription: todo.description,
                tags: todo.tags.joined(separator: ", "),
                startDate: todo.startDateInDate ?? Date(),
                endDate: todo.lastDateInDate ?? Date(),
                selectedCategory: todo.todoCategory,
                journey: .edit,
                todoId: todo.todoId,
                status: todo.status
            )
        } else {
            self.state = State()
        }
        self.onSuccessSubmit = onSuccessSubmit
    }
    
    func send(_ action: Action) {
        switch action {
        case .didAppear:
            Task {
                await getCategories()
            }
        case .didSubmit:
            state.isLoading = true
            Task {
                await submit()
            }
        case .didTapIcon:
            state.isShowChooseCategory.toggle()
        case let .didUpdateIcon(image):
            state.selectedCategory = image
        case .didUpdateEndDate:
            state.endDate = state.startDate
        }
    }
    
    func getImageCategory() -> Image {
        (state.selectedCategory ?? .exercise).image
    }
}

extension CreateToDoViewModel {
    @MainActor
    private func getCategories() async {
        do {
            state.categories = try await getCategoryUseCase.execute().toModels().toToDoCategory()
            state.selectedCategory = state.categories[0]
            state.viewState = .loaded
        } catch {
            state.toast = Toast(message: "Failed to load categories", style: .error)
        }
    }
    
    @MainActor
    private func submit() async {
        defer { state.isLoading = false }
        guard validateForm() else {
            return
        }
        do {
            try await Task.sleep(for: .seconds(1))
            if state.journey == .create {
                try await createToDo()
            } else {
                try await editToDo()
            }
            onSuccessSubmit()
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func createToDo() async throws {
        let param = CreateToDoParam(
            title: state.todoTitle,
            description: state.todoDescription,
            status: .incomplete,
            tags: state.tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            icon: "",
            category: state.selectedCategory?.rawValue ?? state.categories[0].rawValue,
            startDate: state.startDate.ISO8601Format(),
            endDate: state.endDate.ISO8601Format()
        )
        try await createToDoUseCase.execute(param)
    }
    
    @MainActor
    private func editToDo() async throws {
        let param = UpdateToDoParam(
            title: state.todoTitle,
            description: state.todoDescription,
            status: .incomplete,
            tags: state.tags.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            icon: "",
            category: state.selectedCategory?.rawValue ?? state.categories[0].rawValue,
            startDate: state.startDate.ISO8601Format(),
            endDate: state.endDate.ISO8601Format()
        )
        let _ = try await updateToDoUseCase.execute(param, state.todoId ?? "")
    }
    
    private func validateForm() -> Bool {
        guard !state.todoTitle.isEmpty else {
            state.toast = Toast(message: "Title is required", style: .error)
            return false
        }
        return true
    }
}

extension CreateToDoViewModel {
    struct State {
        var title: String = "Create To Do"
        var isLoading: Bool = false
        var viewState: ViewState = .loading
        var todoTitle: String = ""
        var todoDescription: String = ""
        var tags: String = ""
        var startDate: Date = .init()
        var endDate: Date = .init()
        var categories: [ToDoCategory] = []
        var selectedCategory: ToDoCategory?
        var isShowChooseCategory: Bool = false
        var toast: Toast?
        var journey: Journey = .create
        var todoId: String?
        var status: ToDoModel.StatusModel = .incomplete
    }
    
    enum Action {
        case didSubmit
        case didAppear
        case didTapIcon
        case didUpdateIcon(ToDoCategory)
        case didUpdateEndDate
    }
    
    enum ViewState {
        case loaded
        case loading
        case error
    }
    
    enum Journey {
        case create
        case edit
    }
}
