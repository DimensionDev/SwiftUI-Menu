//
//  MenuView.swift
//
//
//  Created by MainasuK on 2023-12-27.
//

import SwiftUI

protocol MenuViewDelegate: AnyObject {
    func menuViewDidDisappear()
}

public struct MenuView: View {
    @ObservedObject var viewModel: ViewModel
    
    public var body: some View {
        ZStack {
            invisibleContentView
                .opacity(.zero)
                .background(GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: ViewFrameKey.self,
                            value: proxy.frame(in: .global)
                        )
                        .onPreferenceChange(ViewFrameKey.self) { frame in
                            viewModel.menuViewFrameInWindow = frame
                        }
                })
                .overlay {
                    let visiableMenuViewFrameInWindow = viewModel.visiableMenuViewFrameInWindow
                    let offset = viewModel.offset
                    let transitionAnchor = viewModel.transitionAnchor
                    ZStack {
                        Color.clear
                        if viewModel.isMenuPresented {
                            ScrollView(.vertical, showsIndicators: true) {
                                contentView
                                    .frame(height: viewModel.menuViewFrameInWindow.height)
                            }
                            .frame(height: visiableMenuViewFrameInWindow.height)
                            .modifier(ScrollBounceBehaviorViewModifier())
                            .modifier(ScrollIndicatorsFlashViewModifier())
                            .modifier(ScrollIndicatorsInsetViewModifier(margin: 7))
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 0)
                            .offset(offset)
                            .transition(
                                AnyTransition.scale
                                    .combined(with: AnyTransition.offset(
                                        x: offset.width + transitionAnchor.x,
                                        y: offset.height + transitionAnchor.y
                                    ))
                                    .combined(with: AnyTransition.opacity)
                            )
                            .onDisappear {
                                viewModel.delegate?.menuViewDidDisappear()
                            }
                        }
                    }   // end ZStack
                    .animation(.snappy(duration: 0.24, extraBounce: 0.1), value: viewModel.isMenuPresented)
                }   // end .overlay
        }   // end ZStack
        .onAppear {
            withAnimation(.snappy(duration: 0.24, extraBounce: 0.1)) {
                viewModel.update(isMenuPresented: true)
            }
            viewModel.viewDidAppear()
        }
    }
}

extension MenuView {
    @ViewBuilder
    var invisibleContentView: some View {
        VStack(spacing: .zero) {
            ForEach(viewModel.actionViewModels) { actionViewModel in
                VStack(spacing: .leastNonzeroMagnitude) {
                    MenuActionView(viewModel: actionViewModel)
                    if viewModel.actionViewModels.last !== actionViewModel {
                        Divider()
                    }
                }
            }
        }   // end VStack
        .frame(width: 250)
    }
    
    @ViewBuilder
    var contentView: some View {
        VStack(spacing: .zero) {
            ForEach(viewModel.actionViewModels) { actionViewModel in
                VStack(spacing: .leastNonzeroMagnitude) {
                    MenuActionView(viewModel: actionViewModel)
                        .background {
                            GeometryReader { proxy in
                                let frameInWindow = proxy.frame(in: .global)
                                Color.clear
                                    .preference(
                                        key: ViewFrameKey.self,
                                        value: frameInWindow
                                    )
                                    .onPreferenceChange(ViewFrameKey.self) { frame in
                                        actionViewModel.update(frameInWindow: frame)
                                    }
                            }
                        }
                    if viewModel.actionViewModels.last !== actionViewModel {
                        Divider()
                    }
                }
            }
        }   // end VStack
        .frame(width: 250)
    }
}
