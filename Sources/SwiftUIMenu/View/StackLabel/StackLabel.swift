//
//  StackLabel.swift
//
//
//  Created by MainasuK on 2024-01-05.
//

import SwiftUI

struct StackLabel: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
            Text(description)
                .font(.caption)
        }
    }
}
