import SwiftUI

struct Log2: View {
    let photos: [UIImage]
    let user: User
    
    var avatar: String {
        user.avatar
    }
   
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            
            VStack(spacing: 10) {
                HStack {
                    Text("Álbum")
                        .font(.largeTitle).bold()
                    
                    Spacer()
                    
                    Text("México")
                        .font(.largeTitle)
                        
                }
                .padding(.horizontal)
                
                Image(user.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
            .padding(.vertical)

            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(photos.indices, id: \.self) { index in
                    Image(uiImage: photos[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 260)
                        .clipped()
                        .background(.blue)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let previewUser = User(
        name: "Carolina Gonzalez",
        avatar: "profile3",
        city: "Monterrey",
        badges: [],
        specialBadges: []
    )
    
    Log2(
        photos: [
            UIImage(systemName: "sun.max.fill")!,
            UIImage(systemName: "moon.fill")!,
            UIImage(systemName: "cloud.fill")!,
            UIImage(systemName: "star.fill")!,
            UIImage(systemName: "leaf.fill")!,
            UIImage(systemName: "flame.fill")!,
            UIImage(systemName: "cloud.fill")!,
            UIImage(systemName: "star.fill")!,
            UIImage(systemName: "leaf.fill")!,
            UIImage(systemName: "flame.fill")!
        ],
        user: previewUser
    )
}

