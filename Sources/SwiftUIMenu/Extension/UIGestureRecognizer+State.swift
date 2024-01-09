//
//  UIGestureRecognizer+State.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import UIKit

extension UIGestureRecognizer.State {
    var name: String {
        switch self {
        case .possible: return "possible"
        case .began: return "began"
        case .changed: return "changed"
        case .ended: return "ended"
        case .cancelled: return "cancelled"
        case .failed: return "failed"
        @unknown default: return "@unknown"
        }
    }
    
    var isEnd: Bool {
        switch self {
        case .ended:
            return true
        default:
            return false
        }
    }
    
    var isFinish: Bool {
        switch self {
        case .ended, .cancelled, .failed:
            return true
        default:
            return false
        }
    }
}
