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
                    ZStack {
                        let animationValues = viewModel.menuPresentAnimationValues
                        Color.clear
                        if viewModel.isMenuPresented {
                            ScrollView(.vertical, showsIndicators: true) {
                                contentView
                                    .frame(height: animationValues.menuViewFrameInWindow.height)
                            }
                            .frame(height: animationValues.visiableMenuViewFrameInWindow.height)
                            .modifier(ScrollBounceBehaviorViewModifier())
                            .modifier(ScrollIndicatorsFlashViewModifier())
                            .modifier(ScrollIndicatorsInsetViewModifier(margin: 7))
                            .scaleEffect(viewModel.isMenuPresented ? 1 : 0.2, anchor: .center)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 0)
                            .scaleEffect(viewModel.isMenuExpand ? 1.0 : 0.2, anchor: animationValues.scaleEffectAnchor)
                            .offset(animationValues.offset)
                            .transition(AnyTransition.opacity)
                            .onDisappear {
                                viewModel.delegate?.menuViewDidDisappear()
                            }
                        }
                    }   // end ZStack
                    .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 1), value: viewModel.isMenuPresented)
                    .animation(.spring(duration: 0.2), value: viewModel.isMenuExpand)
                }   // end .overlay
        }   // end ZStack
        .edgesIgnoringSafeArea(.all)
        .onChange(of: viewModel.isMenuPresented) { value in
            withAnimation(.spring(duration: 0.2)) {
                viewModel.isMenuExpand = value
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 1)) {
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
