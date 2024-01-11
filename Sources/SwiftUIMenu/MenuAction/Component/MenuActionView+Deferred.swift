//
//  MenuActionView+Deferred.swift
//
//
//  Created by MainasuK on 2024-01-10.
//

import SwiftUI

public protocol DeferrendMenuActionViewModel: ObservableObject, AnyObject {
    var isLoading: Bool { get }
}

extension MenuActionView {
    public struct DeferredContent<Content, ViewModel>: View where Content: View, ViewModel: DeferrendMenuActionViewModel {
        @ObservedObject var viewModel: ViewModel
        let content: Content
        
        public init(
            viewModel: ViewModel,
            @ViewBuilder content: () -> Content) {
            self.viewModel = viewModel
            self.content = content()
        }
        
        public var body: some View {
            if viewModel.isLoading {
                HStack {
                    Text("Loading...")
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .foregroundStyle(.secondary)
            } else {
                content
            }
        }
    }
}
