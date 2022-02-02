//
//  TrandingCreatorsView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 17.01.2022.
//

import SwiftUI

struct TrandingCreatorsView: View {
    
    let user:[User] = [
        .init(id: 0, name: "Ammy Adams", nameImages: "billy"),
        .init(id: 1, name: "Billy Childs", nameImages: "cam"),
        .init(id: 2, name: "Sam Smith", nameImages: "sam")
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
                            NavigationLink {
                                UserDetailsView(user: users)
                            } label: {
                              //  UserDetailsView(user: users)
                               DiscoverUserView(users: users)
                            }
                        }
                    }
            }.padding(.horizontal)
                .padding(.bottom)
        }
    }
}

struct DiscoverUserView: View {
    
    let users: User
    
    var body: some View {
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
                    .foregroundColor(Color(.label))
            }
            .frame(width: 60)
         //   .background(Color(.init(white: 0.9, alpha: 1)))
         //   .cornerRadius(.infinity)
            .shadow(color: .gray, radius: 5, x: 0.0, y: 4.0)
    }
}

struct TrandingCreatorsView_Previews: PreviewProvider {
    static var previews: some View {
        TrandingCreatorsView()
    }
}
