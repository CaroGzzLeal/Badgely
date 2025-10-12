//
//  EmojiCardView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 07/10/25.
//
import SwiftUI

struct EmojiCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let emoji: EmojiData
    
    var isSelected: Bool = false
    var isAnySelected: Bool = false
    
    var action: () -> Void = {}
    
    var body: some View {
        
        Button(action: action) {
            Image(systemName: emoji.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .padding(15)
                .background(buttonColor)
                //.background(isSelected ? Color(red: 30/255, green: 94/255, blue: 54/255) : Color(colorScheme == .dark ? Color(red: 58/255, green: 58/255, blue: 60/255) : Color(red: 245/255, green: 245/255, blue: 245/255)))
                .clipShape(Circle())
                .symbolRenderingMode(.monochrome)
        }
        
    }
    
    private var buttonColor: Color {
            if isSelected {
                //Selected one stays green
                return Color(red: 30/255, green: 94/255, blue: 54/255)
            } else if isAnySelected {
                //If another button is selected, this one turns gray
                return Color.gray.opacity(0.4)
            } else {
                //At the beginning (no selection yet)
                return Color(red: 30/255, green: 94/255, blue: 54/255)
            }
        }
}
