//
//  MenuSourceView.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import os.log
import UIKit
import SwiftUI
import Combine

final public class MenuSourceView: UIView {
    #if MENU_DEBUG
    let logger = Logger(subsystem: "MenuSourceView", category: "View")
    #else
    let logger = Logger(.disabled)
    #endif
    let tapGestureRecognizer = UITapGestureRecognizer()
        
    var menuWindow: MenuWindow?
    var menuViewModel: MenuView.ViewModel!
    var needsSkipNextTap: Bool = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        _init()
    }
}

extension MenuSourceView {
    private func _init() {
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.addTarget(self, action: #selector(MenuSourceView.tapGestureRecognizerHandle(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
}

extension MenuSourceView {
    var reusableValidMenuWindow: MenuWindow? {
        if let menuWindow = self.menuWindow, !menuWindow.isHidden {
            return menuWindow
        } else {
            return nil
        }
    }
    
    @objc private func tapGestureRecognizerHandle(_ sender: UITapGestureRecognizer) {
        logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): tap \(self), state: \(sender.state.name)")
        
        switch sender.state {
        case .ended:
            if needsSkipNextTap {
                needsSkipNextTap = false
                
                if reusableValidMenuWindow != nil {
                    logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): skip tap")
                    return
                }
            }
            presentMenuWindow()
        default:
            return
        }
    }
    
    private func presentMenuWindow() {
        logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public)")
        
        if let menuWindow = reusableValidMenuWindow {
            menuWindow.menuViewModel.update(isMenuPresented: !menuWindow.menuViewModel.isMenuPresented)
        } else {
            guard let window = self.window, let windowScene = window.windowScene, let menuViewModel = self.menuViewModel else {
                assertionFailure()
                return
            }
            
            menuWindow = MenuWindow(
                windowScene: windowScene,
                menuViewModel: menuViewModel
            )
        }
    }
}

public struct MenuSourceViewRepresentable: UIViewRepresentable {
    let menuViewModel: MenuView.ViewModel
    
    public init(menuViewModel: MenuView.ViewModel) {
        self.menuViewModel = menuViewModel
    }
    
    public func makeUIView(context: Context) -> MenuSourceView {
        let view = MenuSourceView()
        view.menuViewModel = menuViewModel
        menuViewModel.sourceView = view
        return view
    }
    
    public func updateUIView(_ view: MenuSourceView, context: Context) {
        // do nothing
    }
}

