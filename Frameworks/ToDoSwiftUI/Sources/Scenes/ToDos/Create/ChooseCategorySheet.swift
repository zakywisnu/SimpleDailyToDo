//
//  ChooseCategorySheet.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 06/03/25.
//

import SwiftUI

struct ChooseCategorySheet: View {
    @Environment(\.dismiss) var dismiss
    let categories: [ToDoCategory]
    let onSelect: (ToDoCategory) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(categories, id: \.self) { category in
                HStack(alignment: .center, spacing: 24) {
                    category.image
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color.primaryColor)
                    
                    Text(category.rawValue.capitalized)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primaryColor)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .stroke(Color.primaryColor, style: .init(lineWidth: 2))
                        .shadow(color: Color.black.opacity(0.16), radius: 2, x: 3, y: 3)
                )
                .padding(.horizontal, 16)
                .onTapGesture {
                    onSelect(category)
                    dismiss()
                }
            }
        }
        .padding(.vertical, 16)
    }
}
