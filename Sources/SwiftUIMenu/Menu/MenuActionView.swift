//
//  MenuActionView.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import SwiftUI

public struct MenuActionView: View {
    @ObservedObject var viewModel: ViewModel
    
    public var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                Text(String(format: "(%.2f, %.2f)(%.2f, %.2f)", viewModel.frameInWindow.origin.x, viewModel.frameInWindow.origin.y, viewModel.frameInWindow.width, viewModel.frameInWindow.height))
                    .font(.system(size: 9))
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(viewModel.padding)
        .frame(minHeight: 44.0)
        .background(Color.gray.opacity(viewModel.isHighlight ? 0.3 : 0.0))
        .contentShape(Rectangle())
    }
}

