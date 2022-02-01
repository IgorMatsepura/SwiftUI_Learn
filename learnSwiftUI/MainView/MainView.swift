//
//  MainView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 30.12.2021.
//

import SwiftUI



struct MainView: View {
    
    var colors = ["Red" , "Black", "White", "Blue"]
    
    @State private var shouldPresentAddCardForm = false
    @State private var shouldPresentAddTransactionForm = false
    @State private var shouldPresentPicker = 0
    @State private var shouldPresentDiscover = false

    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>

    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if !cards.isEmpty {
                    TabView {
                        Group {
                            ForEach(cards) { num in
                                CardCreditView(card: num)
                            }
                        }
                        .padding(.bottom, 50)
                       
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 260)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    Text("Get started by adding your first transaction!")
                    Button {
                        shouldPresentAddTransactionForm.toggle()
                    } label: {
                        Text("+ Transaction")
                            .padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 20))
                            .background(Color(.label))
                            .foregroundColor(Color(.systemBackground))
                            .font(.headline)
                            .cornerRadius(5)
                    }
                    .fullScreenCover(isPresented: $shouldPresentAddTransactionForm, onDismiss: nil) {
                        TransactionView()
                    }
                    
                    Button {
                        //
                        //showPicker
                        
                    } label: {
                        Text("Show me picker")
                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 14))
                        .background(Color(.label))
                        .foregroundColor(Color(.systemBackground))
                        .font(.headline)
                        .cornerRadius(5)
                    }
                    
                    Button {
                        shouldPresentDiscover.toggle()
                    } label: {
                        Text("Show me disover")
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 14))
                            .background(Color(.label))
                            .foregroundColor(Color(.systemBackground))
                            .font(.headline)
                            .cornerRadius(5)
                    }
                    .fullScreenCover(isPresented: $shouldPresentDiscover, onDismiss: nil) {
                        Discover()
                    }

                } else {
    
                    emptyMessage
                }
//                .onAppear {
//                    shouldPresentAddCardForm.toggle()
//                }
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
                        AddCardForm()
                       // AddCardForm(shouldPresentAddCardForm: $shouldPresentAddCardForm)
                        
                    }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(leading: HStack {
                addItemButton
                deleteAllButton
            }, trailing: addButton)

        }
    }
    
    private var deleteAllButton: some View {
        Button {
            cards.forEach { card in
                viewContext.delete(card)
            }
            do {
               try viewContext.save()
                
            } catch {
                
            }
        } label: {
            Text("Delete All")
        }
    }

    private var emptyMessage: some View {
        VStack {
            Text("You currently have no cards in system")
                .padding(.horizontal, 48)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Button {
                shouldPresentAddCardForm.toggle()
            } label: {
                Text("+ Add Your first card")
                    .foregroundColor(Color(.systemBackground))
            }
            .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
            .background(Color(.label))
            .cornerRadius(5)
            .shadow(radius: 3)
            
        }
        .font(.system(size: 24, weight: .semibold))
    }
    
    private var showPicker: some View {
   
        Picker(selection: $shouldPresentPicker, label: Text("Selected:")) {
            ForEach(0..<colors.count) {
                Text(self.colors[$0])
            }
        }
    }
    
    struct CardCreditView: View {
        let card: Card
        @State private var shouldShowActionSheet = false
        @State private var shouldShowEditActionSheet = false
        @State var refreshId = UUID()

        
        private func handleDelete() {
            let viewContent = PersistenceController.shared.container.viewContext
            viewContent.delete(card)
            do {
                try viewContent.save()
            } catch {
                print("Not saved to CoreData \(error.localizedDescription)")
            }
        }
        
        var body: some View {
                        
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(card.name ?? "Apple Blue Visa Card")
                        .font(.system(size: 24, weight:  .semibold))
                    Spacer()
                    Button {
                        shouldShowActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                    }
                    .actionSheet(isPresented: $shouldShowActionSheet) {
                        .init(title: Text(self.card.name ?? "Title"), buttons: [
                            .default(Text("Edit"), action: {
                                shouldShowEditActionSheet.toggle()
                            }),
                            .destructive(Text("Delete card"), action:  handleDelete),
                            .cancel()
                        ])
                    }
                  
                }
         
                
                HStack {
                    Image("viza")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64)
                        .clipped()
                        .foregroundColor(.blue)
                    Spacer()
                    Text("Balance: $5,000")
                        .font(.system(size: 18, weight:  .semibold))

                }
                
                Text(card.number ?? "1234 1234 1234 1234")

                Text("Credit Limit: \(card.limit)")

                HStack {
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding()
            .background(
                VStack {
                    if let colorData = card.color,
                       let uiColor = UIColor.color(data: colorData),
                       let actualColor = Color(uiColor: uiColor) {
                        LinearGradient(colors: [actualColor.opacity(0.6), actualColor], startPoint: .center, endPoint: .bottom)
                    } else {
                        Color.gray
                    }
                 
                }
            )
            .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
            
            .fullScreenCover(isPresented: $shouldShowEditActionSheet) {
                AddCardForm(card: self.card)
            }
        }
    }
    

                                    
    var addButton: some View {
                Button(action: {
                    shouldPresentAddCardForm.toggle()
                }, label: {
                    Text("+ Card")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 12))
                        .background(Color.black)
                        .cornerRadius(5)
                        .shadow(radius: 2)
                })
                
            }
    
    var addItemButton: some View {
                Button(action: {
                   //
                    withAnimation {
                        let viewContext = PersistenceController.shared.container.viewContext
                        let card = Card(context: viewContext)
                        card.timestamp = Date()

                        do {
                            try viewContext.save()
                        } catch {
                 
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }, label: {
                    Text("Add Item")

                })
                
            }
    


}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewContext = PersistenceController.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, viewContext)
    }
}
