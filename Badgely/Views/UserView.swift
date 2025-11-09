//
//  UserView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 08/10/25.
//

import SwiftUI
import SwiftData

struct UserView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if users.isEmpty {
            ZStack {
                Image(colorScheme == .dark ? "backgroundDarkmode" : "background")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .accessibilityHidden(true)
                
                NewUserView()
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        else {
            TabViewSearch()
        }
    }
}


#Preview {
    UserView()
}
