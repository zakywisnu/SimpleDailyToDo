//
//  LogoutSheet.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 12/03/25.
//


//
//  LogoutSheet.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 03/03/25.
//

import SwiftUI

struct DeleteToDoSheet: View {
    
    @Environment(\.dismiss) var dismiss
    let didTapDelete: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .foregroundStyle(Color.red)
                .frame(width: 100, height: 100)
            
            Text("Are you sure you want to delete this ToDo?")
                .font(.headline)
                .foregroundColor(Color.primary)
            
            HStack(spacing: 24) {
                PrimaryButton(
                    title: "Delete",
                    style: .default) {
                        didTapDelete()
                        dismissSheet()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                
                PrimaryButton(
                    title: "Cancel",
                    style: .secondary) {
                        dismissSheet()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func dismissSheet() {
        dismiss()
        onDismiss()
    }
}
