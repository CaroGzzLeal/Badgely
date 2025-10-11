//
//  ChangeProfileView.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 10/10/25.
//

import SwiftUI

struct ChangeProfileView: View {
    
    let user: User
    @State var avatar: String
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    let allProfileImages: [String] = ["profile1", "profile2", "profile3", "profile4"]
    @Binding var showEdit: Bool
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    showEdit = false
                }, label: {
                    Image(systemName: "xmark.square")
                        .font(.largeTitle)
                        .padding()
                })
                
                Button(action: {
                    showEdit = false
                }, label: {
                    Image(systemName: "checkmark.square")
                        .font(.largeTitle)
                        .padding()
                })
            }
            
            Text("Selecciona tu avatar")
                .font(.title)
                .bold()
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(allProfileImages,  id: \.self) { image in
                    
                    Button(action: {
                        user.avatar = image
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(.gray)
                                .frame(width: 150)
                                .opacity(0.4)
                            
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .overlay {
                                    Image(systemName: "checkmark.seal")
                                        .font(.largeTitle)
                                        .opacity(image == user.avatar ? 1 : 0)
                                        .offset(x: 50, y: -50)
                                }
                        }
                    })
                }
            }
        }
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
    
    ChangeProfileView(user: previewUser, avatar: "profile1", showEdit: .constant(true))
}
