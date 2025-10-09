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
            Text(user.name)
            Text(user.city)
        }
    }
}
