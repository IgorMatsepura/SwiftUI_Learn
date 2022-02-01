//
//  AddCardForm.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 30.12.2021.
//

import SwiftUI

struct AddCardForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    let card: Card?
    
    init(card: Card? = nil) {
        self.card = card
        
        _name = State(initialValue: self.card?.name ?? "")
        _cardNumber = State(initialValue: self.card?.number ?? "")
        _typeCard = State(initialValue: self.card?.cardType ?? "Visa")
        
        if let limit = card?.limit {
            _creditLimit = State(initialValue: String(limit))
        }
        _months = State(initialValue: Int(self.card?.expMonth ?? 1))
        _years = State(initialValue: Int(self.card?.expYears ?? Int16(currentYear)))
        
        if let dataColor = self.card?.color, let uiColor = UIColor.color(data: dataColor) {
            let colors = Color(uiColor)
            _color = State(initialValue: colors)
        }
    }
    //@Binding var shouldPresentAddCardForm: Bool

    @State private var name = ""
    @State private var cardNumber = ""
    @State private var creditLimit = ""
    
    @State private var typeCard = "Visa"
    @State private var months = 1
    @State private var years = Calendar.current.component(.year, from: Date())
    @State private var color = Color.blue
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card information")) {
                    TextField("Name", text: $name)
                    TextField("Credit Card numner", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $creditLimit)
                        .keyboardType(.numberPad)
                    Picker("Type", selection: $typeCard) {
                        ForEach(["Visa", "Mastercard","Discover"], id: \.self) { card in
                            Text(String(card)).tag(String(card))
                        }
               
                    }
                    
                }
                Section(header: Text("Expiration")) {
                    Picker("Month", selection: $months) {
                        ForEach(1..<13, id: \.self) { mon in
                            Text(String(mon)).tag(String(mon))
                        }
                    }
                    Picker("Years", selection: $years) {
                        ForEach(currentYear..<currentYear + 20, id: \.self) { mon in
                            Text(String(mon)).tag(String(mon))
                        }
                    }
                }
                
                Section(header: Text("Color")) {
                    ColorPicker("Color", selection: $color)
                }
                                
            }
            .navigationTitle(self.card != nil ? self.card?.name ?? "" : "Add Credit Card")
            .navigationBarItems(leading: cancelButton, trailing:  saveButton )
        }
    }
    private var saveButton: some View {
        Button(action: {
            let viewContent = PersistenceController.shared.container.viewContext
            
            let card = self.card != nil ? self.card! : Card(context: viewContent)
            //let card = Card(context: viewContent)
            card.name = self.name
            card.number = self.cardNumber
            card.limit = Int32(self.creditLimit) ?? 0
            card.expMonth = Int16(self.months)
            card.expYears = Int16(self.years)
            card.timestamp = Date()
            card.color = UIColor(self.color).encode()
            card.cardType = typeCard
            do {
                try viewContent.save()
                presentationMode.wrappedValue.dismiss()

            } catch {
                print("Failed save to CoreData\(error.localizedDescription)")
            }
            
       }, label: {
           Text("Save")
       })
    }
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            //shouldPresentAddCardForm.toggle()
        }, label: {
            Text("Cancel")
        })
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        AddCardForm()
       // MainView()
    }
}

extension UIColor {
    
    class func color(data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}
