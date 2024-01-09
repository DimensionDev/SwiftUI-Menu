//
//  ViewFrameKey.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import SwiftUI

struct ViewFrameKey: PreferenceKey {
    static var defaultValue: CGRect { .zero }
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
