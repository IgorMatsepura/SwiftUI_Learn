//
//  TransactionView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 02.01.2022.
//

import SwiftUI

struct TransactionView: View {
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                
            }.navigationTitle("Add transaction")
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    private var cancelButton: some View {
            Button {
             } label: {
                Text("Cancel")
            }
    }
    private var saveButton: some View {
            Button {
                
            } label: {
                Text("Save")
            }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}
