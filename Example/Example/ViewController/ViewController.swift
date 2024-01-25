//
//  ViewController.swift
//  Example
//
//  Created by MainasuK on 2023-12-27.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    static var sampleText = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin vitae augue bibendum, imperdiet dolor eu, tempor erat. Maecenas fringilla lectus in quam auctor, a accumsan felis ullamcorper. Integer pharetra consectetur odio, at auctor erat vehicula dictum. Phasellus faucibus orci ut eleifend elementum. Sed laoreet diam velit, a lobortis dui tempus vel. Sed et lorem tincidunt, blandit quam ut, vehicula massa. Aliquam erat volutpat. Proin congue, sapien sit amet ultrices porttitor, augue tellus hendrerit justo, sed lobortis est nulla et mauris. Nam elementum lorem nec sem placerat, ut elementum sem euismod. Donec scelerisque velit lorem, vel dapibus libero interdum at.
    """
    
    let viewModel: ListView.ViewModel = {
        let words = ViewController.sampleText
            .replacingOccurrences(of: "[,|.]", with: "", options: [.regularExpression], range: nil)
            .components(separatedBy: " ")
        let items = words.map { ListItem(text: $0) }
        return ListView.ViewModel(items: items)
    }()
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List"
        navigationController?.tabBarItem.image = UIImage(systemName: "list.bullet")!
        
        navigationItem.largeTitleDisplayMode = .never
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        navigationItem.standardAppearance = barAppearance
        navigationItem.compactAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        let hostingController = UIHostingController(rootView: ListView(viewModel: viewModel))
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hostingController.didMove(toParent: self)
    }
}

