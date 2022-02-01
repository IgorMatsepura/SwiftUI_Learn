//
//  ActivityIndicatorView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 17.01.2022.
//

import SwiftUI



struct ActivityIndicatorView: UIViewRepresentable {
    
    typealias UIViewType = UIActivityIndicatorView
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView(style: .large)
        activity.startAnimating()
        activity.color = .white
        return activity
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
}


struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActivityIndicatorView()
        }
    }
}
