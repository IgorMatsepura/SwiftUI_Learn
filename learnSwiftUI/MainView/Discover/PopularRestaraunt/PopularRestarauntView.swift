//
//  PopularRestarauntView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 17.01.2022.
//

import SwiftUI

struct PopularRestarauntView: View {
    
    var rest: [Restaurant] = [
        .init(name: "Japan's Finest Tapas", nameImages: "tapas"),
        .init(name: "Bar & Grill", nameImages: "grill")
    ]
    
    var body: some View {
        VStack {
            HStack{
                Text("Popular places to eat")
                    .font(.system(size: 18, weight: .semibold))

                Spacer()
                Text("See all")
                    .font(.system(size: 18, weight: .semibold))

            }
            .padding(.horizontal)
            .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
             
                    HStack(spacing: 8) {
                        ForEach(rest, id: \.self) { restoran in
                            
                            NavigationLink {
                                RestarantDetailsView(restrarunt: restoran)
                            } label: {
                                RestaurantTitle(restoran: restoran)
                                    .foregroundColor(Color(.label))
                            }
                    }
                }.padding(.horizontal)
                    .padding(.bottom)
            }
        }
    }
}


struct RestaurantTitle: View {
    
    let restoran: Restaurant
    
    var body: some View {
        HStack(spacing: 8) {
            Image(restoran.nameImages)
                .resizable()
                .frame(width: 70, height: 70)
                .scaledToFill()
                .clipped()
                .cornerRadius(5)
            // Spacer()
            
                .background(Color.gray)
                .padding(.leading, 6)
                .padding(.vertical, 6)
            
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(restoran.name)
                    Spacer()
                    Button {
                        print("tap")
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    }
                }
                //                                        .font(.system(size: 12 ,weight: .semibold))
                HStack {
                    Image(systemName: "star.fill")
                    Text("4.7 - Sushi - $$")
                }
                
                //                                        .font(.system(size: 12 ,weight: .semibold))
                Text("Tokyo, Japan")
                //                                        .font(.system(size: 12 ,weight: .semibold))
                
            }
            .font(.system(size: 12 ,weight: .semibold))
            
            Spacer()
            
        }
        .frame(width: 260)
        .background(Color(.init(white: 0.9, alpha: 1)))
        .cornerRadius(6)
        .shadow(color: .gray, radius: 3, x: 0.0, y: 2.0)
    }
}

struct PopularRestarauntView_Previews: PreviewProvider {
    static var previews: some View {
        PopularRestarauntView()
    }
}
