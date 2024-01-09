//
//  TouchDetectViewModifier.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import SwiftUI

struct TouchDetectViewModifier: ViewModifier {
        
    @GestureState private var location: CGPoint = .zero
    
    let onChanged: (CGPoint) -> Void
    let onEnded: (CGPoint) -> Void
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .updating($location) { value, state, transaction in
                        state = value.location
                    }
                    .onChanged { value in
                        onChanged(value.location)
                    }
                    .onEnded { value in
                        onEnded(value.location)
                    }
            )
    }
}
