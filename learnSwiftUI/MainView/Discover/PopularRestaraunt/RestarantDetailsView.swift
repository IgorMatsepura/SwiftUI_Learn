//
//  RestarantDetailsView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 28.01.2022.
//

import SwiftUI
import Kingfisher

struct ResturantDetails: Decodable {
    let description: String
    let popularDishes: [Dish]
    let photos: [String]
    let reviews: [Review]
}

struct Dish: Decodable, Hashable {
    let name, price, photo: String
    let numPhotos: Int
}

struct Review: Decodable, Hashable {
   
    let user: ReviewUser
    let rating: Int
    let text: String
}

struct ReviewUser: Decodable, Hashable {
    let id: Int
    let username, firstName, lastName, profileImage: String
}

class RestaurantDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var details: ResturantDetails?

    init() {
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/restaurant?id=0"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.details = try? JSONDecoder().decode(ResturantDetails.self, from: data)
            }
        }.resume()
    }
}

struct RestarantDetailsView: View {
    
    @ObservedObject var vm = RestaurantDetailsViewModel()
    let restrarunt: Restaurant
    
    let samplesPhoto = ["https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/0d1d2e79-2f10-4cfd-82da-a1c2ab3638d2", "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/0d1d2e79-2f10-4cfd-82da-a1c2ab3638d2"]
    
    
    var body: some View {
        
        ScrollView {
           
            ZStack(alignment: .bottomLeading) {
                Image(restrarunt.nameImages)
                    .resizable()
                    .scaledToFill()
                
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(restrarunt.name)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack {
                            ForEach(0..<5, id:\.self) { num in
                                Image(systemName: "star.fill")
                            }.foregroundColor(.orange)
                        }
                    }
                    Spacer()
                    
                    NavigationLink {
                        RestaurantPhotosView()
                    } label: {
                        Text("See more photos")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .regular))
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }

                    
              
                }.padding()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Locaction & Description")
                    .font(.system(size: 16, weight: .bold))
                Text("Tokyo, Japan")
                
                HStack {
                    ForEach(0..<3, id:\.self) { num in
                        Image(systemName: "dollarsign.circle.fill")
                    }.foregroundColor(.orange)
                }
                HStack { Spacer() }
            }.padding(.top)
                .padding(.horizontal)
          
            Text(vm.details?.description ?? "")

                .padding(.top, 8)
                .font(.system(size: 14, weight: .regular))
                .padding(.horizontal)
                .padding(.bottom)
            
            
            HStack {
                Text("Popular Dishes")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }.padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.details?.popularDishes ?? [], id: \.self) { dish in
                        DishCell(dish: dish)
                    }
                }.padding(.horizontal)
            }
            
            if let reviews = vm.details?.reviews {
                RevievsList(reviews: reviews)
            }
            
        }
        .navigationTitle("Restaurant Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct RestarantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RestarantDetailsView(restrarunt: .init(name: "Japan's Finest Tapas", nameImages: "tapas"))
    }
}

struct RevievsList: View {
    
    let reviews :[Review]
    
    var body: some View {
        HStack {
            Text("Customer Reviews")
                .font(.system(size: 16, weight: .bold))
            Spacer()
        }.padding(.horizontal)
        
        //        if let reviews = vm.details?.reviews {
        ForEach(reviews, id: \.self) { review in
            VStack(alignment: .leading) {
                HStack{
                    KFImage(URL(string: review.user.profileImage))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(review.user.firstName) \(review.user.lastName)")
                            .font(.system(size: 14, weight: .bold))
                        HStack(spacing: 2){
                            ForEach(0..<review.rating, id: \.self) { stars in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                                
                            }
                            ForEach(0..<5 - review.rating, id: \.self) { stars in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.gray)
                                
                            }
                        } .font(.system(size: 12))
                    }
                    
                    
                    Spacer()
                    Text("Dec 2022")
                        .font(.system(size: 14, weight: .bold))
                    
                }
                Text(review.text)
                
            }.padding(.top)
                .padding(.horizontal)
                .font(.system(size: 14, weight: .regular))
            
        }
    }
}


struct DishCell: View {
    
    let dish: Dish
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                KFImage(URL(string: dish.photo))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 80)
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke( Color.gray))
                    .shadow(radius: 2)
                    .padding(.vertical, 2)
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                Text(dish.price)
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
            }
            Text(dish.name)
                .font(.system(size: 14, weight: .bold))
            
            Text("\(dish.numPhotos) photos")
                .foregroundColor(.gray)
                .font(.system(size: 13, weight: .regular))
            
            
        }
    }
}
