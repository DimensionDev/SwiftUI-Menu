//
//  MenuActionView+ViewModel.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import SwiftUI

extension MenuActionView {
    public class ViewModel: ObservableObject, Identifiable {
        public let id = UUID()
        
        let background: UIColor

        // input
        @Published public var title: String = ""
        @Published public var padding = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        var action: UIAction?
        
        // output
        @Published public var isHighlight = false
        @Published public var frameInWindow: CGRect = .zero

        public init(title: String) {
            self.title = title
            self.background = [
                UIColor.red,
                UIColor.yellow,
                UIColor.blue,
                UIColor.green,
                UIColor.gray,
                UIColor.systemPink,
                UIColor.purple,
            ].randomElement()!
            // end init
        }
    }
}

extension MenuActionView.ViewModel {
    public func performAction() {
        title = title + title
    }
}
