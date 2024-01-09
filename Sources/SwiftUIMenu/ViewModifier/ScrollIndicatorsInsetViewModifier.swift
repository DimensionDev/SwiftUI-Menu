//
//  ScrollIndicatorsInsetViewModifier.swift
//
//
//  Created by MainasuK on 2024-01-08.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

public struct ScrollIndicatorsInsetViewModifier: ViewModifier {
    
    let margin: CGFloat
    
    public init(margin: CGFloat) {
        self.margin = margin
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .contentMargins(.vertical, margin, for: .scrollIndicators)
        } else {
            content
                .introspect(.scrollView, on: .iOS(.v13...)) { scrollView in
                    scrollView.verticalScrollIndicatorInsets.top = margin
                    scrollView.verticalScrollIndicatorInsets.bottom = margin
                }
        }
    }
}
