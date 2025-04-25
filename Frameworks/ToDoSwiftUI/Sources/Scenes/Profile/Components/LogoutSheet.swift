//
//  LogoutSheet.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 03/03/25.
//

import SwiftUI

struct LogoutSheet: View {
    
    @Environment(\.dismiss) var dismiss
    let didTapLogout: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .foregroundStyle(Color.red)
                .frame(width: 100, height: 100)
            
            Text("Are you sure you want to logout?")
                .font(.headline)
                .foregroundColor(Color.primaryColor)
            
            HStack(spacing: 24) {
                PrimaryButton(
                    title: "Logout",
                    style: .default) {
                        didTapLogout()
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
