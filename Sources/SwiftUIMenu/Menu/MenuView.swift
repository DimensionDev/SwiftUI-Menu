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
    
    static var scaleFrom: CGFloat = 0.1
    var scale: CGFloat {
        viewModel.isMenuExpand ? 1.0 : MenuView.scaleFrom
    }
    var opacity: CGFloat {
        viewModel.isMenuExpand ? 1.0 : 0.0
    }
    
    static func defaultBouncyAnimation(isPresent: Bool) -> Animation {
        if isPresent {
            return Animation.interpolatingSpring(stiffness: 250, damping: 25)
        } else {
            return Animation.smooth(duration: 0.2)
        }
    }

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
                        ScrollView(.vertical, showsIndicators: true) {
                            contentView
                                .frame(height: animationValues.menuViewFrameInWindow.height)
                        }
                        .frame(height: animationValues.visiableMenuViewFrameInWindow.height)
                        .modifier(ScrollBounceBehaviorViewModifier())
                        .modifier(ScrollIndicatorsFlashViewModifier())
                        .modifier(ScrollIndicatorsInsetViewModifier(margin: 7))
                        .mask(
                            Color.clear
                                .overlay(alignment: .top) {
                                    let height = viewModel.isMenuExpand ? nil : animationValues.visiableMenuViewFrameInWindow.height / 3.0
                                    RoundedRectangle(cornerRadius: 14)
                                        .frame(height: height, alignment: .top)
                                }
                        )
                        .background(alignment: .top) {
                            let height = viewModel.isMenuExpand ? nil : animationValues.visiableMenuViewFrameInWindow.height / 3.0
                            Color.clear
                                .frame(height: height, alignment: .top)
                                .background(.regularMaterial)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 0)
                        .scaleEffect(scale, anchor: animationValues.scaleEffectAnchor)
                        .opacity(opacity)
                        .animation(MenuView.defaultBouncyAnimation(isPresent: viewModel.isMenuExpand), value: viewModel.isMenuExpand)
                        .modifier(AnimationValueListener(value: scale, handler: { value in
                            let targetValue = scale
                            if targetValue == value, value == MenuView.scaleFrom {
                                DispatchQueue.main.async {
                                    viewModel.delegate?.menuViewDidDisappear()
                                }
                            }
                        }))
                        .offset(animationValues.offset)
                    }   // end ZStack
                }   // end .overlay
        }   // end ZStack
        .edgesIgnoringSafeArea(.all)
        .onChange(of: viewModel.isMenuPresented) { value in
            withAnimation(MenuView.defaultBouncyAnimation(isPresent: value)) {
                viewModel.isMenuExpand = value
            }
        }
        .onAppear {
            withAnimation(MenuView.defaultBouncyAnimation(isPresent: true)) {
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
