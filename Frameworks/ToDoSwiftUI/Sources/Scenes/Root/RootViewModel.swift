//
//  RootViewModel.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 19/02/25.
//

import Foundation

public class RootViewModel: ObservableObject {
    @Published var state: State
    
    public init() {
        self.state = .init()
    }
    
    struct State {
        var viewState: ViewState = .loaded
    }
    
    enum ViewState {
        case loading
        case loaded
    }
}
