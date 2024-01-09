//
//  PanRecognizerWithInitialTouch.swift
//
//
//  Created by MainasuK on 2024-01-05.
//

import UIKit.UIGestureRecognizerSubclass

class PanRecognizerWithInitialTouch : UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }

}
