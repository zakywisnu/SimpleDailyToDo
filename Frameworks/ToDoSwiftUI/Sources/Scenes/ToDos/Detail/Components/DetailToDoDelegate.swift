//
//  DetailToDoDelegate.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 12/03/25.
//

import Foundation

public protocol DetailToDoDelegate: AnyObject, Hashable {
    func didSuccessUpdateToDo()
    func didSuccessDeleteToDo()
}
