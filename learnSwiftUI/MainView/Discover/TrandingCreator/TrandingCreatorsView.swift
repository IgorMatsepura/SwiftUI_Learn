//
//  TrandingCreatorsView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 17.01.2022.
//

import SwiftUI

struct TrandingCreatorsView: View {
    
    let user:[User] = [
        .init(name: "Ammy Adams", nameImages: "billy"),
        .init(name: "Billy Childs", nameImages: "cam"),
        .init(name: "Sam Smith", nameImages: "sam")
    ]
    
    var body: some View {
        VStack {
            HStack{
                Text("Trending Creators")
                    .font(.system(size: 18, weight: .semibold))

                Spacer()
                Text("See all")
                    .font(.system(size: 18, weight: .semibold))

            }
            .padding(.horizontal)
            .padding(.top)
            ScrollView(.horizontal, showsIndicators: false) {
             
                HStack(alignment: .top, spacing: 8) {
                        ForEach(user, id: \.self) { users in
                            //VStack(alignment: .center, spacing: 8) {
                                VStack {
                                    Image(users.nameImages)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(60)
                                    Text(users.name)
                                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 60)
                             //   .background(Color(.init(white: 0.9, alpha: 1)))
                             //   .cornerRadius(.infinity)
                                .shadow(color: .gray, radius: 5, x: 0.0, y: 4.0)
                                .padding(.bottom)
                            
                          //  }
                        }
                    }
            }.padding(.horizontal)
        }
    }
}

struct TrandingCreatorsView_Previews: PreviewProvider {
    static var previews: some View {
        TrandingCreatorsView()
    }
}
