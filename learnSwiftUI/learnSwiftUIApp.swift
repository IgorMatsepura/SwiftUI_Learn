//
//  learnSwiftUIApp.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 07.12.2021.
//

import SwiftUI

@main
struct learnSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
