//
//  ToDoDetailView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 12/03/25.
//

import SwiftUI

struct ToDoDetailView: View {
    @EnvironmentObject var router: StandardSwiftUIRouter
    @StateObject var viewModel: ToDoDetailViewModel
    
    init(_ todoId: String, _ param: DetailToDoParam) {
        _viewModel = StateObject(wrappedValue: .init(todoId, param: param))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationBarView(title: "Detail") {}
            Spacer()
            switch viewModel.state.viewState {
            case .loading:
                EmptyView()
            case .loaded:
                content
                    .padding()
            case .error:
                EmptyView()
            }
            Spacer()
            
            Button {
                viewModel.send(.didTapEdit)
            } label: {
                Text("Edit")
                    .font(.subheadline)
                    .foregroundStyle(Color.textPrimary)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.6))
                    )
                    .padding(.horizontal, 16)
            }
            
            Button {
                viewModel.send(.didTapDelete)
            } label: {
                Text("Delete")
                    .font(.subheadline)
                    .foregroundStyle(Color.textPrimary)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red)
                    )
                    .padding(.horizontal, 16)
            }
            
        }
        .navigationBarHidden(true)
        .onFirstAppear {
            viewModel.setup(router: router)
            viewModel.send(.didLoad)
        }
        .loading(viewModel.state.shouldShowLoadingIndicator)
        .sheet(isPresented: $viewModel.state.isShowDeleteConfirmation) {
            DeleteToDoSheet {
                viewModel.send(.didDelete)
            } onDismiss: {
                
            }
            .presentationDetents([.height(300)])
        }
        .sheet(isPresented: $viewModel.state.isShowEditToDo) {
            EditCreateToDoView(todo: viewModel.state.task) { [weak viewModel] in
                viewModel?.state.isShowEditToDo = false
                viewModel?.send(.didSuccessEditToDo)
            }
            .presentationDetents([.height(500)])
        }
        .toast(toast: $viewModel.state.toast)
    }
    
    private var content: some View {
        VStack {
            HStack(alignment: .center, spacing: 16) {
                icon
                taskDetails
                
                Spacer()
                
                Text(viewModel.state.task.status.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(Color.textPrimary)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(viewModel.state.task.status == .complete ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
                    )
            }
            .padding(16)
            
            tags
                .padding(.horizontal, 16)
            
            HStack {
                time
                
                Spacer()
                
                Button {
                    viewModel.send(.updateToDoStatus)
                } label: {
                    Text("Mark as \(getUpdateStatusTitle().rawValue.capitalized)")
                        .font(.subheadline)
                        .foregroundStyle(Color.textPrimary)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.6))
                        )
                }

            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(viewModel.state.task.todoCategory.cardColor)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 2, y: 2)
        )
    }
    
    private var icon: some View {
        viewModel.state.task.todoCategory.image
            .resizable()
            .foregroundStyle(Color.primary)
            .frame(width: 24, height: 24)
    }
    
    private var taskDetails: some View {
        VStack(alignment: .leading) {
            Text(viewModel.state.task.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
            
            Text(viewModel.state.task.description)
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
        }
    }
    
    private var time: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.primary)
            
            Text(viewModel.state.task.timeRange)
                .font(.subheadline)
                .foregroundColor(Color.textPrimary)
        }
    }
    
    private func getUpdateStatusTitle() -> ToDoModel.StatusModel {
        if viewModel.state.task.status == .complete {
            return .incomplete
        } else {
            return .complete
        }
    }
    
    private var tags: some View {
        HStack {
            ForEach(viewModel.state.task.tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .foregroundColor(Color.textPrimary)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
