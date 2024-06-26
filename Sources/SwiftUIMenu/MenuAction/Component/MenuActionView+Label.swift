//
//  MenuActionView+Label.swift
//
//
//  Created by MainasuK on 2024-01-10.
//

import SwiftUI

extension MenuActionView {
    open class LabelViewModel: MenuActionView.ViewModel {
        @Published public var title: String = ""
        @Published public var icon: UIImage?
        @Published public var tint: UIColor?
        
        public init(
            title: String,
            icon: UIImage? = nil,
            tint: UIColor? = nil,
            action: @escaping () -> Void = { }
        ) {
            self.title = title
            self.icon = icon
            self.tint = tint
            super.init(action: action)
            // end init
            
            setup {
                LabelContent(viewModel: self)
            }
        }
        
        override open func viewDidAppear() {
            super.viewDidAppear()
        }
    }
}

extension MenuActionView.LabelViewModel {
    @MainActor
    public func update(title: String) {
        self.title = title
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.objectWillChange.send()
        }
    }
}

extension MenuActionView {
    public struct LabelContent: View {
        @ObservedObject var viewModel: MenuActionView.LabelViewModel
        
        public init(viewModel: MenuActionView.LabelViewModel) {
            self.viewModel = viewModel
        }
        
        public var body: some View {
            HStack(alignment: .center) {
                let tintColor = viewModel.tint.flatMap { Color(uiColor: $0) }
                Label {
                    Text(viewModel.title)
                } icon: {
                    if let icon = viewModel.icon {
                        Image(uiImage: icon)
                    }
                }
                .labelStyle(CenterLabelStyle())
                .foregroundColor(tintColor)
                Spacer()
            }   // end HStack
        }
    }
}

