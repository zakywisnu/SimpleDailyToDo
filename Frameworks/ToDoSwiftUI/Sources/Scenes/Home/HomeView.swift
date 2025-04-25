//
//  HomeView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = .init()
    
    @EnvironmentObject var router: StandardSwiftUIRouter
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            switch viewModel.state.viewState {
            case .loading:
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .loaded:
                content
            case .error:
                EmptyView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.backgroundPrimary)
        .onFirstAppear {
            viewModel.setup(router: router)
            viewModel.send(.didLoad)
        }
        .sheet(isPresented: $viewModel.state.isShowCreateToDoSheet) {
            EditCreateToDoView { [weak viewModel] in
                viewModel?.state.isShowCreateToDoSheet = false
                viewModel?.send(.didSuccessCreateToDo)
            }
            .presentationDetents([.height(500)])
        }
        .toast(toast: $viewModel.state.toast)
        .loading(viewModel.state.isLoading)
    }
    
    @ViewBuilder
    private var content: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 8) {
                VStack(alignment: .leading) {
                    dashboard
                    overview
                    
                    WeeklyCalendarView(
                        selectedDate: $viewModel.state.selectedDate,
                        todos: $viewModel.state.todos
                    ) { currentShownWeek in
                        viewModel.send(.didUpdateCurrentShownWeek(currentShownWeek))
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 8) {
                            if viewModel.state.selectedDateToDos.isEmpty {
                                Text("Congrats, you have no to-do")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.primaryColor)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .frame(height: 150)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.primaryColor.opacity(0.2))
                                            .shadow(radius: 8)
                                    )
                                    .padding()
                            } else {
                                ForEach(viewModel.state.selectedDateToDos, id: \.todoId) { todo in
                                    ToDoCard(task: todo) { todo in
                                        viewModel.send(.didUpdateToDoStatus(todo))
                                    }
                                    .onTapGesture {
                                        viewModel.send(.didNavigateDetail(todo))
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(16)
            }
            
            Image(systemName: "plus")
                .resizable()
                .foregroundStyle(Color.white)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.7))
                        .frame(width: 48, height: 48)
                )
                .padding(32)
                .onTapGesture {
                    viewModel.send(.didCreateToDo)
                }
                
        }
    }
    
    private var dashboard: some View {
        HStack {
            Text("Dashboard")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
            
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .foregroundStyle(Color.progressBlue)
                .frame(width: 48, height: 48)
                .matchedTransitionSource(id: "profile", in: namespace)
                .onTapGesture {
                    viewModel.send(.didTapProfile(namespace))
                }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 2, y: 2)
        )
    }
    
    private var overview: some View {
        VStack(alignment: .leading) {
            Text("Tasks Overview")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
            
            Picker("", selection: $viewModel.state.selectedPicker) {
                Text("Daily Tasks").tag(0)
                Text("Weekly Tasks").tag(1)
            }
            .pickerStyle(.segmented)
            
            TasksCard(
                todos: viewModel.state.selectedPicker == 0 ? $viewModel.state.selectedDateToDos : $viewModel.state.currentWeeksToDo,
                title: viewModel.state.selectedPicker == 0 ? "Daily Tasks" : "Weekly Tasks"
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 2, y: 2)
        )
    }
}
