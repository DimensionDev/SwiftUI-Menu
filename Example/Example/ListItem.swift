//
//  ListItem.swift
//  Example
//
//  Created by MainasuK on 2023-12-27.
//

import SwiftUI
import SwiftUIMenu

class ListItem: Identifiable {
    let id = UUID()
    let text: String
    
    let leadingMenuViewModel = MenuView.ViewModel()
    let centerMenuViewModel = MenuView.ViewModel()
    let trailingMenuViewModel = MenuView.ViewModel()
    
    init(text: String) {
        self.text = text
        // end init
        
        leadingMenuViewModel.actionViewModels = (1...5).map { i in
            MenuActionView.StackLabelViewModel(title: "\(i)") {
                print(i)
            }
        }
        centerMenuViewModel.actionViewModels = (1...10).map { i in
            MenuActionView.StackLabelViewModel(title: "\(i)") {
                print(i)
            }
        }
        trailingMenuViewModel.actionViewModels = (1...20).map { i in
            MenuActionView.StackLabelViewModel(title: "\(i)") {
                print(i)
            }
        }
    }
}
