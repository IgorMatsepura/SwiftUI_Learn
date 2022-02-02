//
//  RestaurantCarouselView.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 01.02.2022.
//

import SwiftUI
import Kingfisher

struct RestaurantCarouselView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    let imagesName: [String]
    let selectedIndex: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        viewController.view.backgroundColor = .red
        let customViewController = CarouseCustomViewController(images: imagesName, selectedIndex: selectedIndex)

        return customViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //
    }
 
}

class CarouseCustomViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return allViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        self.selectedIndex
    }

//    let firstViewController = UIHostingController(rootView: Text("First VC"))
//    let secondViewController = UIHostingController(rootView: Text("Second VC"))
//    let threeViewController = UIHostingController(rootView: Text("Three VC"))
//
//    lazy var allViewControllers: [UIViewController] = [firstViewController, secondViewController, threeViewController]
    var allViewControllers: [UIViewController] = []
    var selectedIndex: Int
    
    init(images: [String], selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray5
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        allViewControllers = images.map({ images in
            let hostingController = UIHostingController(rootView:
                                                            ZStack{
                Color.black
                KFImage(URL(string: images))
                    .resizable()
                    .scaledToFit()
                
            }
                                                        
            )
            hostingController.view.clipsToBounds = true
            return hostingController
        })
        
        if selectedIndex < allViewControllers.count {
            setViewControllers([allViewControllers[selectedIndex]], direction: .forward, animated: true, completion: nil)
        }
//        if let first = allViewControllers.first {
//            setViewControllers([first], direction: .forward, animated: true, completion: nil)
//        }
//
        
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = allViewControllers.firstIndex(of: viewController) else { return nil}
        if index == 0 { return nil }
        
        return allViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if viewController == secondViewController {return nil}
//        return secondViewController
        
        guard let index = allViewControllers.firstIndex(of: viewController) else { return nil}
        if index == allViewControllers.count - 1 { return nil }
        
        return allViewControllers[index + 1]
    }
    
    
}


struct  RestaurantCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        DestinatioHeaderController(imagesName: ["paris", "paris", "paris"])
            .frame(height: 300)
    }
}


