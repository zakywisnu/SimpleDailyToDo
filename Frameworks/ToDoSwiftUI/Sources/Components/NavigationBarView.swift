//
//  NavigationBarView.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 28/02/25.
//

import SwiftUI

struct NavigationBarView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    public let content: Content
    private var title: String?
    
    public init(
        title: String? = nil,
        @ViewBuilder _ builder: () -> Content
    ) {
        content = builder()
        self.title = title
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "x.circle")
                .resizable()
                .foregroundStyle(Color.primaryColor)
                .frame(width: 32, height: 32)
                .onTapGesture {
                    dismiss.callAsFunction()
                }
            
            if let title {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
            }
            
            Spacer()
            
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 2, y: 2)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
    }
}

#Preview {
    NavigationBarView {
        Text("testing")
    }
}
