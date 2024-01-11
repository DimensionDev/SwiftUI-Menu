//
//  CenterLabelStyle.swift
//
//
//  Created by MainasuK on 2024-01-11.
//

import SwiftUI

struct CenterLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            configuration.icon
            configuration.title
        }
    }
}
