//
//  MenuViewController.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import os.log
import UIKit
import SwiftUI
import UIKit.UIGestureRecognizerSubclass

final class MenuViewController: UIViewController {
    #if MENU_DEBUG
    let logger = Logger(subsystem: "MenuViewController", category: "ViewController")
    #else
    let logger = Logger(.disabled)
    #endif
    var viewModel: MenuView.ViewModel!
}

extension MenuViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let hostingController = UIHostingController(rootView: MenuView(viewModel: viewModel))
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
        
        hostingController.view.backgroundColor = .clear
        view.backgroundColor = .clear
        
        let panGestureRecognizer = PanRecognizerWithInitialTouch()
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delaysTouchesBegan = false
        panGestureRecognizer.cancelsTouchesInView = false
        panGestureRecognizer.delegate = self
        panGestureRecognizer.addTarget(self, action: #selector(MenuViewController.panGestureRecognizerHandler(sender:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
}

extension MenuViewController {
    @objc private func panGestureRecognizerHandler(sender: UIPanGestureRecognizer) {
        logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): pan state: \(sender.state.name)")
        
        let locationInWindow = sender.location(in: nil)
        viewModel.drag(location: locationInWindow, state: sender.state)        
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
