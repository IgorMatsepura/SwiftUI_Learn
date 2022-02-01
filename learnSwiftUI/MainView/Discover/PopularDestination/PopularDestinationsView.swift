//
//  PopularDestinationsView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 17.01.2022.
//

import SwiftUI
import MapKit


struct DestinitionsDetails: Decodable {
    let description: String
    let photos: [String]
    
}

class DestinitionDetailViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var destinitionDetails: DestinitionsDetails?

    init(name: String) {
//        let name = "paris"
        let fixedUrl = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: fixedUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            //
            DispatchQueue.main.async {
                guard let data = data else { return }
    //            print(String(data: data , encoding: .utf8))
                do {
                    self.destinitionDetails = try JSONDecoder().decode(DestinitionsDetails.self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

struct PopularDestinationsView: View {
    
   
    
    var destanation: [Destinition] = [
        .init(country: "France", name: "Paris", nameImage: "paris", latitude: 48.8550114, langitude: 2.341231),
        .init(country: "US", name: "New York", nameImage: "ny", latitude: 40.71592, langitude: -74.0055),
        .init(country: "Japan", name: "Tokyo", nameImage: "japan", latitude: 35.67988, langitude: 139.7695)
    ]
    
    var body: some View {
        VStack {
            HStack{
                Text("Popular destinitions")
                    .font(.system(size: 18, weight: .semibold))

                Spacer()
                Text("See all")
                    .font(.system(size: 18, weight: .semibold))

            }
            .padding(.horizontal)
            .padding(.top)
            ScrollView(.horizontal, showsIndicators: false) {
             
                    HStack(spacing: 8) {
                        ForEach(destanation, id: \.self) { num in
                            
                            NavigationLink {
                                PopularDestanitionDetailsView(num: num)
                            } label: {
                                PopularDestinationTitle(num: num)
                                    .padding(.bottom)
                            }
                            
                        }
                    }
                    .padding(.horizontal)
            }
        }
    }
}

struct PopularDestinationTitle: View {
    
    let num: Destinition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Image(num.nameImage)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
//                                    .clipped()
                .cornerRadius(4)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)

            Text(num.name)
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 12)
                .foregroundColor(Color(.label))

            Text(num.country)
                .font(.system(size: 14, weight: .light))
                .padding(.horizontal, 12)
                .padding(.bottom, 6)
                .foregroundColor(Color(.label))

        }
//                            .frame(width: 125)
        .background(Color(.init(white: 0.9, alpha: 1.0)))
        .cornerRadius(6)
        .shadow(color: .gray, radius: 3, x: 0.0, y: 2.0)
    }
}


struct PopularDestanitionDetailsView: View {
    
    @ObservedObject var vm: DestinitionDetailViewModel
    let num: Destinition
    @State var isShowingAttraction = false
//    @State var region = MKCoordinateRegion(center: .init(latitude: 48.859565, longitude: 2.353235), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
//
    @State var region: MKCoordinateRegion
    
    
    
    init(num: Destinition) {
        
        self.num = num
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: num.latitude, longitude: num.langitude), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)))
//        self.region =  MKCoordinateRegion(center: .init(latitude: num.latitude, longitude: num.langitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.vm = .init(name: num.name)
        
    }


    
    var body: some View {
        
        ScrollView {
            
            if let photos = vm.destinitionDetails?.photos {
                DestinatioHeaderController(imagesName: photos)
                    .frame(height: 300)
            }
        
//            Image(num.nameImage)
//                .resizable()
//                .scaledToFill()
//                .frame(height: 300)
//                .clipped()
            VStack(alignment: .leading) {
                Text(num.name)
                    .font(.system(size: 16, weight: .semibold))
                Text(num.country)
                HStack {
                    ForEach(0..<5, id: \.self) { num in
                      Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }.padding(.top, 1)
                
                Text(vm.destinitionDetails?.description ?? "")
                    .lineLimit(nil)
                    .padding(.top, 4)
                
                HStack {
                    
                    Spacer()
                    
                }
            }
            .padding(.horizontal)
            HStack {
              
                Text("Location")
                    .font(.system(size: 16, weight: .semibold))
            
                Spacer()
                
                Button(action: { isShowingAttraction.toggle() }, label:  {
                    Text("\(isShowingAttraction ? "Hide" : "Show") Atractions")
                    .font(.system(size: 12, weight: .semibold))
                })
                Toggle("", isOn: $isShowingAttraction)
                    .labelsHidden()
                    .foregroundColor(Color(.label))
               
            }.padding(.horizontal)
            
//            Map(coordinateRegion: $region)
//                .frame(height: 300)
            
            Map(coordinateRegion: $region, annotationItems: isShowingAttraction ? atraction : []) { atraction in
//                MapMarker(coordinate: .init(latitude: atraction.latitude, longitude: atraction.longitude), tint: .blue)
                MapAnnotation(coordinate: .init(latitude: atraction.latitude, longitude: atraction.longitude)) {
                    CustomMapAnnotation(atraction: atraction)
                }
                
            }
            .frame(height: 300)

//            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [])
//                .frame(width: 400, height: 300)
            
        }.navigationTitle(num.name)
            .navigationBarTitleDisplayMode(.inline)
        
    }
    
    let atraction: [Atraction] = [
        .init(latitude:48.858605 , longitude: 2.2946 , name: "paris"),
        .init(latitude:48.866867 , longitude: 2.311780 , name: "Chaps-Elysees"),
        .init(latitude:48.860288 , longitude: 2.337789 , name: "Lourve Museum")
    ]

}


struct CustomMapAnnotation: View {
    
    let atraction: Atraction
    
    var body: some View {
        VStack {
            Image(atraction.name)
                .resizable()
                .frame(width: 130, height: 60)
                .cornerRadius(4)
            Text(atraction.name)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(LinearGradient(colors: [Color.red, Color.blue], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(3)
        }
    }
}

struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularDestanitionDetailsView(num: .init(country: "France", name: "Paris", nameImage: "paris", latitude: 48.859565, langitude: 2.353235))
        }
//        Discover()
//        PopularDestinationsView()
    }
}
