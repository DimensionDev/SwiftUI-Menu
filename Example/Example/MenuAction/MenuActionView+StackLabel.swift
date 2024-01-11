//
//  MenuActionView+StackLabel.swift
//  Example
//
//  Created by MainasuK on 2024-01-09.
//

import SwiftUI
import SwiftUIMenu

extension MenuActionView {
    class StackLabelViewModel: MenuActionView.ViewModel {
        @Published public var title: String = ""

        init(
            title: String,
            action: @escaping () -> Void
        ) {
            self.title = title
            super.init(action: action)
            // end init
            
            setup {
                StackLabelContent(viewModel: self)
            }
        }
        
        override func viewDidAppear() {
            super.viewDidAppear()
            
            print("View appear!")
        }
    }
}

extension MenuActionView {
    struct StackLabelContent: View {
        @ObservedObject var viewModel: MenuActionView.StackLabelViewModel
        
        init(viewModel: MenuActionView.StackLabelViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                    Text(String(format: "(%.2f, %.2f)(%.2f, %.2f)", viewModel.frameInWindow.origin.x, viewModel.frameInWindow.origin.y, viewModel.frameInWindow.width, viewModel.frameInWindow.height))
                        .font(.system(size: 9))
                        .lineLimit(1)
                }
                Spacer()
            }   // end HStack
        }
    }
}
