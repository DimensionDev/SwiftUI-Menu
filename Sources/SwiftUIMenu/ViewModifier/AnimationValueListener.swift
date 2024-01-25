//
//  AnimationValueListener.swift
//
//
//  Created by MainasuK on 2024-01-24.
//

import SwiftUI

struct AnimationValueListener: Animatable, ViewModifier {
    var animatableData: CGFloat {
        didSet {
            handler(animatableData)
        }
    }
    var handler: (CGFloat) -> Void
    
    init(
        value: CGFloat,
        handler: @escaping (CGFloat) -> Void
    ) {
        self.animatableData = value
        self.handler = handler
    }
    
    func body(content: Content) -> some View {
        content
    }
}
