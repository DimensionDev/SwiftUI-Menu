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
        content
            .padding(viewModel.padding)
            .frame(minHeight: 44.0)
            .background(Color.gray.opacity(viewModel.isHighlight ? 0.3 : 0.0))
            .contentShape(Rectangle())
    }
    
    @ViewBuilder
    var content: some View {
        if let content = viewModel.content {
            content
        } else {
            HStack {
                EmptyView()
            }   // end HStack
        }
    }
}

