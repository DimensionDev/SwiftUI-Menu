//
//  MenuView+ViewModel.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import os.log
import SwiftUI
import func QuartzCore.CACurrentMediaTime

extension MenuView {
    public class ViewModel: ObservableObject {
        #if MENU_DEBUG
        let logger = Logger(subsystem: "MenuView.ViewModel", category: "ViewModel")
        #else
        let logger = Logger(.disabled)
        #endif
        
        weak var delegate: MenuViewDelegate?
        
        // input
        @Published public var actionViewModels: [MenuActionView.ViewModel]
        @Published public private(set) var isMenuPresented: Bool = false
        @Published var isMenuExpand: Bool = false
        
        private var menuPresentedUpdatedAt: CFTimeInterval = CACurrentMediaTime()
        
        var menuPresentAnimationValues: AnimationValues = AnimationValues(
            menuSourceViewFrameInWindow: .zero, 
            visiableMenuViewFrameInWindow: .zero,
            offset: .zero,
            transitionAnchor: .zero
        )
        
        weak var sourceView: MenuSourceView?
        weak var menuWindow: UIWindow?
        
        // output
        @Published public var menuViewFrameInWindow: CGRect = .zero
        
        private var menuActionViewInitalFrameAtDrag: CGRect = .zero
        private var isDragTriggerScroll: Bool = false
         
        public init(actionViewModels: [MenuActionView.ViewModel] = []) {
            self.actionViewModels = actionViewModels
        }
    }
}

extension MenuView.ViewModel {
    @MainActor
    func update(isMenuPresented: Bool) {
        self.isMenuPresented = isMenuPresented
        self.menuPresentedUpdatedAt = CACurrentMediaTime()
        self.menuPresentAnimationValues = self.animationValues()

        #if MENU_DEBUG
        logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): isMenuPresented: \(isMenuPresented); transitionAnchor: \(self.transitionAnchor.debugDescription)")
        #endif
    }
    
    @MainActor
    func viewDidAppear() {
        for actionViewModel in self.actionViewModels {
            actionViewModel.viewDidAppear()
        }
    }
}

// MenuView: original ---(offset)---> visible
extension MenuView.ViewModel {
    struct AnimationValues {
        let menuSourceViewFrameInWindow: CGRect
        let visiableMenuViewFrameInWindow: CGRect
        let offset: CGSize
        let transitionAnchor: CGPoint
        let scaleEffectAnchor: UnitPoint
        
        init(
            menuSourceViewFrameInWindow: CGRect,
            visiableMenuViewFrameInWindow: CGRect,
            offset: CGSize,
            transitionAnchor: CGPoint
        ) {
            self.menuSourceViewFrameInWindow = menuSourceViewFrameInWindow
            self.visiableMenuViewFrameInWindow = visiableMenuViewFrameInWindow
            self.offset = offset
            self.transitionAnchor = transitionAnchor
            self.scaleEffectAnchor = {
                var y: CGFloat = transitionAnchor.y < 0 ? 0.0 : 1.0
                if visiableMenuViewFrameInWindow.height > 0 {
                    let ratio = (menuSourceViewFrameInWindow.midY - visiableMenuViewFrameInWindow.minY) / visiableMenuViewFrameInWindow.height
                    if 0.0..<1.0 ~= ratio {
                        y = min(1, max(0, y + ratio))
                    }
                }
                return UnitPoint(x: 0.5, y: y)
            }()
        }
    }
    
    func animationValues() -> AnimationValues {
        AnimationValues(
            menuSourceViewFrameInWindow: self.menuSourceViewFrameInWindow,
            visiableMenuViewFrameInWindow: self.visiableMenuViewFrameInWindow,
            offset: self.offset,
            transitionAnchor: self.transitionAnchor
        )
    }
    
    var menuSourceViewFrameInWindow: CGRect {
        guard let sourceView = self.sourceView else { return .zero }
        return sourceView.convert(sourceView.frame, to: nil)
    }
    
    var offset: CGSize {
        return transition(from: menuViewFrameInWindow, to: visiableMenuViewFrameInWindow)
    }
    
    var maxMenuViewFrameHeight: CGFloat {
        guard let menuWindow = self.menuWindow else {
            return 500.0
        }
        
        let verticalSizeClass = menuWindow.windowScene?.traitCollection.verticalSizeClass ?? .compact
        let frameMaxHeight: CGFloat = {
            var height = menuWindow.bounds.height
            height -= menuWindow.safeAreaInsets.top
            height -= menuWindow.safeAreaInsets.bottom
            if verticalSizeClass == .regular {
                height = 0.85 * height
            }
            return ceil(height)
        }()
        
        return frameMaxHeight
    }
    
    var visiableMenuViewFrameInWindow: CGRect {
        guard let menuWindow = self.menuWindow else {
            // put the menu in the center if window not found
            return .zero
        }
        let menuViewFrameInWindow = self.menuViewFrameInWindow
        let menuSourceViewFrameInWindow = self.menuSourceViewFrameInWindow
        
        // move to source view center
        var finalMenuViewFrameInWindow = menuViewFrameInWindow
        finalMenuViewFrameInWindow.size.height = min(finalMenuViewFrameInWindow.height, maxMenuViewFrameHeight)
        let offset = transition(from: menuViewFrameInWindow, to: menuSourceViewFrameInWindow)
        finalMenuViewFrameInWindow.origin.x += offset.width
        finalMenuViewFrameInWindow.origin.y += offset.height
        
        // adapt horizontal safe area inset (default with addtional 16pt margin)
        // - left
        let frameMinX: CGFloat = menuWindow.safeAreaInsets.left + 16.0
        if finalMenuViewFrameInWindow.minX < frameMinX {
            finalMenuViewFrameInWindow.origin.x = frameMinX
        }
        // - right
        let frameMaxX: CGFloat = menuWindow.bounds.width - menuWindow.safeAreaInsets.right - 16.0
        if finalMenuViewFrameInWindow.maxX > frameMaxX {
            finalMenuViewFrameInWindow.origin.x = frameMaxX - finalMenuViewFrameInWindow.width
        }
        
        // move the frame to align the source view (default with addtional 12pt margin)
        let isSourceFrameInUpperWindow = menuSourceViewFrameInWindow.midY <= menuWindow.bounds.midY
        if isSourceFrameInUpperWindow {
            finalMenuViewFrameInWindow.origin.y = menuSourceViewFrameInWindow.maxY + 12.0
        } else {
            finalMenuViewFrameInWindow.origin.y = menuSourceViewFrameInWindow.minY - finalMenuViewFrameInWindow.height - 12.0
        }
        
        // adapt horizontal safe area inset (default with minimal 12pt margin)
        // - top
        let frameMinY: CGFloat = max(12.0, menuWindow.safeAreaInsets.top)
        if finalMenuViewFrameInWindow.minY < frameMinY {
            finalMenuViewFrameInWindow.origin.y = frameMinY
        }
        // - bottom
        let frameMaxY: CGFloat = menuWindow.bounds.height - max(12.0, menuWindow.safeAreaInsets.bottom)
        if finalMenuViewFrameInWindow.maxY > frameMaxY {
            finalMenuViewFrameInWindow.origin.y = frameMaxY - finalMenuViewFrameInWindow.height
        }
        
        return finalMenuViewFrameInWindow
    }
    
    var transitionAnchor: CGPoint {
        guard let menuWindow = self.menuWindow else {
            // put the menu in the center if window not found
            return .zero
        }
        
        var anchor: CGPoint = .zero
    
        let visiableMenuViewFrameInWindow = self.visiableMenuViewFrameInWindow
        let menuSourceViewFrameInWindow = self.menuSourceViewFrameInWindow
    
        // adjust Y
        let isSourceFrameInUpperWindow = menuSourceViewFrameInWindow.midY <= menuWindow.bounds.midY
        if isSourceFrameInUpperWindow {
            anchor.y = -0.5 * visiableMenuViewFrameInWindow.height
            if visiableMenuViewFrameInWindow.minY < menuSourceViewFrameInWindow.maxY {
                anchor.y += menuSourceViewFrameInWindow.maxY - visiableMenuViewFrameInWindow.minY
            }
        } else {
            anchor.y = 0.5 * visiableMenuViewFrameInWindow.height
        }
        
        // adjust X
        let offsetX = menuSourceViewFrameInWindow.midX - menuWindow.bounds.midX
        anchor.x = offsetX
        
        return anchor
    }
}

extension MenuView.ViewModel {
    private func transition(from: CGRect, to: CGRect) -> CGSize {
        let offsetX = to.midX - from.midX
        let offsetY = to.midY - from.midY
        
        return CGSize(
            width: offsetX,
            height: offsetY
        )
    }
}

extension MenuView.ViewModel {
    @MainActor 
    func drag(location: CGPoint, state: UIGestureRecognizer.State) {
        logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): drag to location: \(location.debugDescription), state: \(state.name)")
        
        guard checkDragFailedToScroll(location: location, state: state) else {
            deselectMenuActionViews()
            return
        }
        
        deselectMenuActionViews()
        
        // set highlight for menu action view at current location
        var needsDismiss = false
        for actionViewModel in self.actionViewModels {
            let actionViewFrame = actionViewModel.frameInWindow
            let isContainsLocation = actionViewFrame.contains(location)
            
            actionViewModel.update(isHighlight: isContainsLocation)
            
            if isContainsLocation {
                logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): action view \(actionViewModel.id) frameInWindow: \(actionViewFrame.debugDescription) contains location \(location.debugDescription)")
            }
            
            if isContainsLocation, state.isEnd {
                actionViewModel.performAction()
                needsDismiss = true
            }
        }   // end for … in …
        
        // remove highlight if state is finish
        if state.isFinish {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.deselectMenuActionViews()
            
                if needsDismiss {
                    self.update(isMenuPresented: false)
                }
            }
        }
    }   // end func
    
    private func checkPresentDelta() {
        let now = CACurrentMediaTime()
        let delta = abs(now - self.menuPresentedUpdatedAt)
        self.logger.log(level: .debug, "\((#file as NSString).lastPathComponent, privacy: .public)[\(#line, privacy: .public)], \(#function, privacy: .public): since present animation start: \(delta)")
    }
    
    private func checkDragFailedToScroll(location: CGPoint, state: UIGestureRecognizer.State) -> Bool {
        switch state {
        case .possible, .began:
            menuActionViewInitalFrameAtDrag = self.firstMenuActionViewFrameInWindow()
            isDragTriggerScroll = false
            return true
        case .changed:
            guard !isDragTriggerScroll else {
                return false
            }
            
            let frame = self.firstMenuActionViewFrameInWindow()
            guard abs(menuActionViewInitalFrameAtDrag.origin.y - frame.origin.y) < 5 else {
                isDragTriggerScroll = true
                return true
            }
            return true
        case .cancelled, .failed:
            return false
        case .ended:
            return !isDragTriggerScroll
        @unknown default:
            return true
        }
    }
    
    private func firstMenuActionViewFrameInWindow() -> CGRect {
        guard let first = actionViewModels.first else {
            return .zero
        }
        let frame = first.frameInWindow
        return frame
    }
    
    private func deselectMenuActionViews() {
        actionViewModels.forEach { actionViewModel in
            actionViewModel.update(isHighlight: false)
        }
    }
}
