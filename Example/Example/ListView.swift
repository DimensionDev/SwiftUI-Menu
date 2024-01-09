//
//  ListView.swift
//  Example
//
//  Created by MainasuK on 2023-12-27.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                ListRowView(item: item)
            }
        }
    }
}

extension ListView {
    class ViewModel: ObservableObject {
        @Published var items: [ListItem]
        
        init(items: [ListItem]) {
            self.items = items
            // end init
        }
    }
}
