//
//  EmojiCardView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
import SwiftUI

struct EmojiCardView: View {
    
    let emoji: EmojiData
    
    var body: some View {
        
        Button(action: {
            print("click")
        }){
            Image(systemName: emoji.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .padding(15)
                .background(Color(red: 30/255, green: 94/255, blue: 54/255))
                .clipShape(Circle())
                .symbolRenderingMode(.monochrome)

        }
    }
}
