//
//  MenuActionView+Content.swift
//
//
//  Created by MainasuK on 2024-01-09.
//

import SwiftUI

extension MenuActionView {
    public struct Content<C>: View where C: View {
        
        let content: C
        
        public init(@ViewBuilder content: () -> C) {
            self.content = content()
        }
        
        public var body: some View {
            content
        }
    }
}
