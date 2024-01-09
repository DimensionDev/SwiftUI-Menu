//
//  ScrollIndicatorsFlashViewModifier.swift
//
//
//  Created by MainasuK on 2024-01-08.
//

import SwiftUI

public struct ScrollIndicatorsFlashViewModifier: ViewModifier {
    public init() { }
    
    public func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .scrollIndicatorsFlash(onAppear: true)
        } else {
            content
        }
    }
}
