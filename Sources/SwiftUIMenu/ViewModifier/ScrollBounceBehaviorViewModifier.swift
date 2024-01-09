//
//  ScrollBounceBehaviorViewModifier.swift
//
//
//  Created by MainasuK on 2024-01-08.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

public struct ScrollBounceBehaviorViewModifier: ViewModifier {
    public init() { }
    
    public func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .scrollBounceBehavior(.basedOnSize)
        } else {
            content
                .introspect(.scrollView, on: .iOS(.v13...)) { scrollView in
                    scrollView.alwaysBounceVertical = false
                }
        }
    }
}
