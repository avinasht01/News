//
//  MainTabView.swift
//  News
//
//  Created by Avinash Thakur on 26/09/24.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var viewModel = NewsViewModel()
    var body: some View {
        TabView {
            NewsHeadlinesView(viewModel: viewModel)
                .tabItem {
                    Label("Top Headlines", systemImage: "list.dash")
                }
            
            BookmarkView()
                .tabItem {
                    Label("Bookmarks", systemImage: "square.and.pencil")
                }
        }
        .onAppear {
            viewModel.initialise()
        }
    }
}

#Preview {
    MainTabView()
}
