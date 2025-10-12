//
//  ColumnView.swift
//  Badgely
//
//  Created by Martha Mendoza Alfaro on 11/10/25. happy times
//

import SwiftUI
import SwiftData


struct ColumnView: View {
    let title: String
    let places: [Place]
    //let user: User? //?
    
    var body: some View {
        ZStack{
            VStack() {
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        ScrollView() {
                            ForEach(places) { place in
                                NavigationLink(destination: PlaceDetailView(place: place)) {
                                    
                                    CardView(width: 300, height: 180, place: place)
                                        .padding(20)
                                }
                            }
                            
                        }
                    }
                }
                
                
            }//VStack
        }//ZStack
    }
}




struct EmojisView: View {
    let title: String
    let places: [Place]
    //let user: User? //?
    
    var body: some View {
        ZStack{
            VStack() {
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        ScrollView() {
                            ForEach(places) { place in
                                NavigationLink(destination: PlaceDetailView(place: place)) {
                                    
                                    CardView(width: 300, height: 180, place: place)
                                        .padding(20)
                                }
                            }
                            
                        }
                    }
                }
                
                
            }//VStack
        }//ZStack
    }
}
