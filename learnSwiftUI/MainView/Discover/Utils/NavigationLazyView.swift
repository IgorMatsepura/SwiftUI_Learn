//
//  NavigationLazyView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 17.01.2022.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

