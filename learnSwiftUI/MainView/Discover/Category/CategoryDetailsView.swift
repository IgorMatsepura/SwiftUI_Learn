//
//  CategoryDetailsView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 17.01.2022.
//

import SwiftUI
import Kingfisher
import SDWebImageSwiftUI


class SomeObservableObjectForUserInteface: ObservableObject {
    
    @Published var  isLoadingCategoryDetails = true
    @Published var  places = [Place]()
    @Published var  erroMessages = ""

    init(name: String) {
        //network cpde will happen here
        
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/category?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")  else {
            self.isLoadingCategoryDetails = false
            
            return
            
        }
        
        
        
        URLSession.shared.dataTask(with: url) { data, respone, error in
            
           
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                if let statusCode = (respone as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                    self.isLoadingCategoryDetails = false
                    self.erroMessages = "Bad status request: \(statusCode)"
                    return
                }
                
                guard let data = data else { return }
                do {
                    self.places =  try JSONDecoder().decode([Place].self, from: data)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    self.erroMessages = error.localizedDescription
                }
                self.isLoadingCategoryDetails = false
              //  self.places = [1, 2, 3, 4, 5, 6, 7, 8]
            }
        }.resume()
        
       
    }
    
}

struct CategoryDetailsView: View {
    
    private let name: String
    @ObservedObject private var vm:  SomeObservableObjectForUserInteface
    
    init(name: String) {
        self.name = name
        self.vm = .init(name: name)
    }
//    @State var isLoadingCategoryDetails = false
//    @ObservedObject  var vm =  SomeObservableObjectForUserInteface()
    
    var body: some View {
        
        ZStack {
            
            if vm.isLoadingCategoryDetails {
                VStack {
                    ActivityIndicatorView()
                    Text("Loading...")
                        .foregroundColor(Color.white)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
                .padding()
                .background(Color.black)
                .cornerRadius(15)

            } else {
                ZStack {
                    if !vm.erroMessages.isEmpty {
                        VStack {
                            Image(systemName: "xmark.octagon.fill")
                                .frame(width: 64, height: 64, alignment: .center)
                                .font(.system(size: 66, weight: .semibold))
                                .foregroundColor(.gray)
                            Text(vm.erroMessages)
                        }
                        
                    }
                    ScrollView {
                        ForEach(vm.places, id: \.self ) { num in
                            VStack(alignment: .leading, spacing: 0) {
                              //  KFImage(URL(string: num.thumbnail))
                                WebImage(url: URL(string: num.thumbnail))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFill()
                                
                                Text(num.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding()
                                
                                
                            } .asTile()
                                .padding()
                        }
                    }
                }
        
                
            }
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryDetailsView(name: "Food")
        }
    }
}
