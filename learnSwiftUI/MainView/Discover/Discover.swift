//
//  Discover.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 13.01.2022.
//

import SwiftUI



struct Discover: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .bottom, endPoint: .top).ignoresSafeArea()
                
                Color(.init(white: 0.95, alpha: 1))
                    .offset(y: 400)
                
                ScrollView {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Where do you want to go?")
                            
                        Spacer()
//                            .padding(.horizontal , 26)
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .semibold))
                    .padding()
                    .background(Color(.init(white: 1, alpha: 0.3)))
                    .cornerRadius(16)
                    .padding(8)
                    
                    DiscoverCategoryView()
                    
                    VStack {
                        PopularDestinationsView()
                        PopularRestarauntView()
                        TrandingCreatorsView()
                    }
                    
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.top, 52)
                }
            }
            .navigationTitle(Text ("Discover"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                //
                print("Tapped")
                presentationMode.wrappedValue.dismiss()

            }, label: {
                Text("Close")
                    .foregroundColor(.black)
            }))
          //  .padding()
        }
        
       
        
    }
}



struct Discover_Previews: PreviewProvider {
    static var previews: some View {
        Discover()
        PopularDestinationsView()
    }
    
}
