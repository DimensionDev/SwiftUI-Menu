//
//  ListRowView.swift
//  Example
//
//  Created by MainasuK on 2023-12-27.
//

import SwiftUI
import SwiftUIMenu

struct ListRowView: View {
    let item: ListItem
    
    var body: some View {
        VStack {
            countLabelMenuView
            nativeMenuView
            customMenuView
        }
    }
}

extension ListRowView {
    @ViewBuilder
    var infoView: some View {
        HStack {
            Text(item.text)
            Spacer()
        }
    }
    
    @ViewBuilder
    var countLabelMenuView: some View {
        HStack {
            Text("5")
            Spacer()
            Text("10")
            Spacer()
            Text("20")
        }
    }
    
    @ViewBuilder
    var nativeMenuView: some View {
        HStack {
            Menu {
                ForEach(item.leadingMenuViewModel.actionViewModels) { actionViewModel in
                    Button {
                        actionViewModel.performAction()
                    } label: {
                        Text(actionViewModel.title)
                    }
                }
            } label: {
                Text("Menu 5")
                    .border(.blue, width: 1)
            }
            Spacer()
            Menu {
                ForEach(item.centerMenuViewModel.actionViewModels) { actionViewModel in
                    Button {
                        actionViewModel.performAction()
                    } label: {
                        Text(actionViewModel.title)
                    }
                }
            } label: {
                Text("Menu 10")
                    .border(.blue, width: 1)
            }
            Spacer()
            Menu {
                ForEach(item.trailingMenuViewModel.actionViewModels) { actionViewModel in
                    Button {
                        actionViewModel.performAction()
                    } label: {
                        Text(actionViewModel.title)
                    }
                }
            } label: {
                Text("Menu 20")
                    .border(.blue, width: 1)
            }            
        }
    }
    
    @ViewBuilder
    var customMenuView: some View {
        HStack {
            Text("DIY Menu")
                .overlay {
                    MenuSourceViewRepresentable(menuViewModel: item.leadingMenuViewModel)
                        .border(.red, width: 1)
                }
            Spacer()
            Text("DIY Menu")
                .overlay {
                    MenuSourceViewRepresentable(menuViewModel: item.centerMenuViewModel)
                        .border(.red, width: 1)
                }
            Spacer()
            Text("DIY Menu")
                .overlay {
                    MenuSourceViewRepresentable(menuViewModel: item.trailingMenuViewModel)
                        .border(.red, width: 1)
                }
        }
    }
}
