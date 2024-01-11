//
//  MenuActionView+ViewModel.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import SwiftUI

extension MenuActionView {
    open class ViewModel: ObservableObject, Identifiable {
        public let id = UUID()
        
        // input
        @Published public var padding = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        public private(set) var content: AnyView?
        public private(set) var action: () -> Void
        
        // output
        @Published public private(set) var isHighlight = false
        @Published public private(set) var frameInWindow: CGRect = .zero

        public init(
            action: @escaping () -> Void = { }
        ) {
            self.action = action
            // end init
        }
        
        public func setup<Content: View>(content: () -> Content) {
            self.content = AnyView(content())
        }
        
        public func setupAction(action: @escaping () -> Void) {
            self.action = action
        }
        
        open func performAction() {
            action()
        }
        
        open func viewDidAppear() {
            // open for hook
        }
    }
}

extension MenuActionView.ViewModel {
    func update(isHighlight: Bool) {
        self.isHighlight = isHighlight
    }
    
    func update(frameInWindow: CGRect) {
        if self.frameInWindow != frameInWindow {
            self.frameInWindow = frameInWindow
        }
    }
}
