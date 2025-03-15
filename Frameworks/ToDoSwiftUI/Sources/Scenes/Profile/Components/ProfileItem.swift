//
//  ProfileItem.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 26/02/25.
//

import SwiftUI

struct ProfileItem: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
            
            Text(content)
                .font(.caption)
                .foregroundStyle(Color.textPrimary)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.clear)
                        .stroke(Color.black, style: .init(lineWidth: 1))
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ProfileItem(title: "Title", content: "any content")
}

