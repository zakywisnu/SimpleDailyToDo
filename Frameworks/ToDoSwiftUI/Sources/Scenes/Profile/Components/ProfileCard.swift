//
//  ProfileCard.swift
//  ToDoSwiftUI
//
//  Created by Ahmad Zaky W on 26/02/25.
//

import SwiftUI

struct ProfileCard: View {
    var profile: ProfileModel
    var body: some View {
        VStack(spacing: 16) {
            ProfileItem(title: "Name", content: "\(profile.firstName) \(profile.lastName)")
                .padding(.top, 16)
            
            ProfileItem(title: "Email", content: profile.email)
                .padding(.bottom, 16)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blueCardBackground)
        )
    }
}

#Preview {
    ProfileCard(profile: .dummy)
}
