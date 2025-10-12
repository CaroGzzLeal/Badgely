//
//  BadgesView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
import SwiftUI

struct BadgesView: View {
    
    let user: User
    var totalBadges: Int {
        user.badges.count + user.specialBadges.count
    }
    var avatar: String {
        user.avatar
    }
    @State var showEdit: Bool = false
    
    let allBadgesNames: [String] = [
        "badge1", "badge2", "badge3", "badge4", "badge5", "sBadge1", "profile2",
        "badge8", "badge9", "badge10", "badge11", "badge12", "sBadge3", "sBadge4",
        "badge13", "badge14", "badge15", "badge16", "badge17", "sBadge5", "sBadge6",
        "badge18", "badge19", "badge20", "badge21", "badge22", "sBadge7", "sBadge8",
        "badge23", "badge24", "badge25", "badge26", "badge27", "sBadge9", "sBadge10",
        "badge28", "badge29", "badge30", "badge31", "badge32", "sBadge11", "sBadge12",
        "badge32", "badge33", "badge34", "badge35", "badge36", "sBadge13", "sBadge14",
    ]
    
    let responsibleBadges: [String] = [
            
    
    ]
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    
    var body: some View {
        VStack {
            Button(action: {
                showEdit = true
            }, label: {
                Image(user.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
            })
            
            Text("\(user.name)")
                .font(Font.largeTitle)
                .bold()
            
            Text("\(totalBadges)")
                .font(.title)
            
            Text("badges")
                .font(.headline)
        
        
            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                ForEach(allBadgesNames,  id: \.self) { badgeName in
                    
                    let hasBadge = user.badges.contains(badgeName) || user.specialBadges.contains(badgeName)
                    
                    Image(badgeName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .opacity(hasBadge ? 1.0 : 0.3)
                        .grayscale(hasBadge ? 0 : 0.8)
                        .animation(.easeInOut(duration: 0.3), value: hasBadge)
                }
            }
        }
        .padding()
        .fullScreenCover(isPresented: $showEdit, content: {
            ChangeProfileView(user: user, avatar: avatar, showEdit: $showEdit)
        })
    }
}

#Preview {
    
    let previewUser = User(
        name: "Carolina González",
        avatar: "profile1",
        city: "Monterrey",
        badges: ["profile1"],
        specialBadges: ["profile4", "profile2"]
    )
    
    BadgesView(user: previewUser)
}

