//
//  BadgesView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
import SwiftUI

struct BadgesView: View {
    let user: User
    var body: some View {
        VStack {
            if user.badges.isEmpty {
                Text("No badges here")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Badges:")
                        .font(.headline)
                    ForEach(user.badges, id: \.self) { badge in
                        Text("• \(badge)")
                    }
                }
            }
        }
    }
}
