//
//  DiscoverCategoryView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 17.01.2022.
//

import SwiftUI


struct DiscoverCategoryView: View {
    
    let categories: [Category] = [
        .init(name: "Art", nameImages: "paintpalette.fill"),
        .init(name: "Sports", nameImages: "sportscourt.fill"),
        .init(name: "Live Events", nameImages: "music.mic"),
        .init(name: "Food", nameImages: "airtag.radiowaves.forward"),
        .init(name: "History", nameImages: "airtag.radiowaves.forward")

    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 14) {
                
                ForEach(categories, id: \.self) { num in
                    NavigationLink {
                        NavigationLazyView(CategoryDetailsView(name: num.name)
)
                    } label: {
                        VStack(spacing: 8) {
                        //    Spacer()
                            Image(systemName: num.nameImages)
                                .font(.system(size: 26))
                                .foregroundColor(.red)
                                .frame(width: 70, height: 70)
                                .background(Color.white)
                                .cornerRadius(.infinity)
                                .shadow(color: .gray, radius: 5, x: 0.0, y: 4.0)
                            
                            Text("\(num.name)")
                                .font(.system(size: 14, weight: .semibold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                        }.frame(width: 80)
                    }
                }
            }.padding(.horizontal)
        }
    }
}


struct DiscoverCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverCategoryView()
    }
}
