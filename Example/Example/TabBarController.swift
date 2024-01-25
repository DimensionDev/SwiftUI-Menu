//
//  TabBarController.swift
//  Example
//
//  Created by MainasuK on 2024-01-25.
//

import UIKit

class TabBarController: UITabBarController {
    
}

extension TabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            ViewController(),
        ].map { viewController in UINavigationController(rootViewController: viewController) }
    }
}
