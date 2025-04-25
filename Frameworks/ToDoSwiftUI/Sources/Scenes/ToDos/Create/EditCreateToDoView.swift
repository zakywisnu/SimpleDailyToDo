//
//  CreateToDoView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 04/03/25.
//

import SwiftUI

struct EditCreateToDoView: View {
    @EnvironmentObject var router: StandardSwiftUIRouter
    @StateObject private var viewModel: CreateToDoViewModel
    @Environment(\.dismiss) var dismiss
    
    init(todo: ToDoModel? = nil, _ onSuccessSubmit: @escaping () -> Void) {
        _viewModel = .init(wrappedValue: CreateToDoViewModel(onSuccessSubmit, todo))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationBarView(title: viewModel.state.title) {}
            
            content
            
            Spacer()
            
            LoadingButtonView(isLoading: $viewModel.state.isLoading) {
                viewModel.send(.didSubmit)
            } builder: {
                Text("Submit")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            .setWidth(UIScreen.main.bounds.width - 32)

        }
        .padding(16)
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.state.isShowChooseCategory) {
            ChooseCategorySheet(categories: viewModel.state.categories) { category in
                viewModel.send(.didUpdateIcon(category))
            }
            .presentationDetents([.height(250)])
        }
        .onFirstAppear {
            viewModel.send(.didAppear)
        }
        .toast(toast: $viewModel.state.toast)
    }
    
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 16) {
            categoryWithTitle
            
            TextField("Description", text: $viewModel.state.todoDescription)
                .textFieldStyle(OutlinedTextFieldStyle(strokeColor: Color.primaryColor))
            
            dates
            
            TextField("Tags (Use comma for multiple tags)", text: $viewModel.state.tags)
                .textFieldStyle(OutlinedTextFieldStyle(strokeColor: Color.primaryColor))
        }
    }
    
    @ViewBuilder
    private var dates: some View {
        HStack(spacing: 8) {
            ChooseDateView(
                selectedDate: $viewModel.state.startDate,
                title: "From: ",
                dateRange: Date.setDateRange(from: Date(), toYears: 10),
                displayedComponents: [.date, .hourAndMinute]
            )
            Spacer()
            ChooseDateView(
                selectedDate: $viewModel.state.endDate,
                title: "To: ",
                dateRange: Date.setDateRange(from: viewModel.state.startDate, toYears: 10),
                displayedComponents: [.date, .hourAndMinute]
            )
        }
        .frame(maxWidth: .infinity)
        .onChange(of: viewModel.state.startDate) {
            if viewModel.state.startDate > viewModel.state.endDate {
                viewModel.send(.didUpdateEndDate)
            }
        }
    }
    
    @ViewBuilder
    private var categoryWithTitle: some View {
        HStack(spacing: 24) {
            viewModel.getImageCategory()
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundStyle(Color.primaryColor)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryColor, style: .init(lineWidth: 2))
                        .fill(Color.clear)
                        .frame(width: 54, height: 54)
                )
                .overlay {
                    ZStack(alignment: .bottomTrailing) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color.black.opacity(0.5))
                    }
                }
                .padding(.leading, 12)
                .onTapGesture {
                    viewModel.send(.didTapIcon)
                }
            
            TextField("Title", text: $viewModel.state.todoTitle)
                .textFieldStyle(OutlinedTextFieldStyle(strokeColor: Color.primaryColor))
        }
    }
}

#Preview {
    EditCreateToDoView {}
}
