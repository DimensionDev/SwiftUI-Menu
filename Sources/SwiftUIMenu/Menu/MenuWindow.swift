//
//  MenuWindow.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import os.log
import SwiftUI
import Combine

class MenuWindow: UIWindow {
    #if MENU_DEBUG
    let logger = Logger(subsystem: "MenuWindow", category: "Window")
    #else
    let logger = Logger(.disabled)
    #endif
    let menuViewModel: MenuView.ViewModel
    
    var disposeBag = Set<AnyCancellable>()
    
    init(windowScene: UIWindowScene, menuViewModel: MenuView.ViewModel) {
        self.menuViewModel = menuViewModel
        super.init(windowScene: windowScene)
                
        windowLevel = .statusBar + 1
        
        let menuViewController = MenuViewController()
        menuViewController.viewModel = menuViewModel
        menuViewModel.menuWindow = self
        menuViewModel.delegate = self
        rootViewController = menuViewController
        
        if let overrideUserInterfaceStyle = menuViewModel.sourceView?.window?.overrideUserInterfaceStyle {
            self.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        }
        
        if let sourceView = menuViewModel.sourceView {
            sourceView.publisher(for: \.traitCollection)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] traitCollection in
                    guard let self = self else { return }
                    self.overrideUserInterfaceStyle = traitCollection.userInterfaceStyle
                }
                .store(in: &disposeBag)
        }

        makeKeyAndVisible()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
         logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): point: \(point.debugDescription), event: \(event.debugDescription)")
         
         
         let isMenuViewFrameContainsPoint: Bool = {
             let menuViewFrameInWindow = menuViewModel.visiableMenuViewFrameInWindow
             if menuViewFrameInWindow != .zero {
                 return menuViewFrameInWindow.contains(point)
             }
             return false
         }()
         
         let isFrameContainsPoint = isMenuViewFrameContainsPoint
         
         if !isFrameContainsPoint, menuViewModel.isMenuPresented {
             menuViewModel.sourceView?.needsSkipNextTap = true
         }
         
         defer {
             if !isFrameContainsPoint {
                 dismissMenu()
             }
         }
         
         // should be return false when if touch outside the visible menu frame
         // so that the TableView could continues handle the drag event
         return isFrameContainsPoint
     }
    
    deinit {
        os_log(.info, "%{public}s[%{public}ld], %{public}s", ((#file as NSString).lastPathComponent), #line, #function)
    }
}

extension MenuWindow {
    private func dismissMenu() {
        logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public)")
        
        menuViewModel.update(isMenuPresented: false)
    }
    
    func dismiss() {
        logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public)")
        
        isHidden = true
        windowScene = nil
        rootViewController = nil
    }
}

// MARK: - MenuViewDelegate
extension MenuWindow: MenuViewDelegate {
    func menuViewDidDisappear() {
        logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public)")
        
        self.dismiss()
    }
}
