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
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .padding(20)
                .background(Color.yellow)
                .clipShape(Circle())
                .symbolRenderingMode(.monochrome)
            
        }
    }
}
