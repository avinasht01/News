//
//  NewsHeadlinesView.swift
//  News
//
//  Created by Avinash Thakur on 22/09/24.
//

import SwiftUI

struct NewsHeadlinesView: View {
    
    @State private var showServerErrorAlert: Bool = false
    @State private var showCategoryFilter: Bool = false
    @State private var removeFilter: Bool = false
    
    @ObservedObject var viewModel = NewsViewModel()
    
    var body: some View {
        VStack {
            NavigationStack {
                if viewModel.networkConnector {
                        if viewModel.articlesList.count > 0 {
                            List(viewModel.articlesList, id: \.id) { news in
                                NavigationLink(destination: NewsDetailView(article: news)) {
                                    SwiftUIUtility.NewsCardsView(article: news, viewModel: viewModel)
                                }
                            }
                            .navigationTitle(NewsConstants.title)
                            .navigationBarTitleDisplayMode(.inline)
                            .listStyle(.inset)
                            .toolbar {
                                ToolbarItemGroup(placement: .primaryAction) {
                                    Button {
                                        if viewModel.newsCategory == .nofilter {
                                            showCategoryFilter = true
                                        } else {
                                            removeFilter = true
                                        }
                                    } label: {
                                        if viewModel.newsCategory == .nofilter {
                                            Image(.filterIcon)
                                                .frame(width: NewsConstants.iconSize, height: NewsConstants.iconSize)
                                                .foregroundColor(.blue)
                                                .cornerRadius(NewsConstants.cornerRadius)
                                        } else {
                                            Image(.filterApplied)
                                                .frame(width: NewsConstants.iconSize, height: NewsConstants.iconSize)
                                                .foregroundColor(.blue)
                                                .cornerRadius(NewsConstants.cornerRadius)
                                        }
                                    }
                                    .confirmationDialog(NewsConstants.filterText, isPresented: $showCategoryFilter, titleVisibility: .visible) {
                                        Button("\(NewsCategory.science)") {
                                            viewModel.newsCategory = .science
                                        }
                                        Button("\(NewsCategory.technology)") {
                                            viewModel.newsCategory = .technology
                                        }
                                        Button("\(NewsCategory.entertainment)") {
                                            viewModel.newsCategory = .entertainment
                                        }
                                        Button("\(NewsCategory.sports)") {
                                            viewModel.newsCategory = .sports
                                        }
                                    }
                                }
                            }
                        } else {
                            SwiftUIUtility.NewsArcticlesEmptyView()
                        }
                } else {
                    SwiftUIUtility.NoInternetView()
                }
            }
            .refreshable {
                await refreshContent()
            }
        }
            .alert(isPresented: $removeFilter) {
                Alert(
                    title: Text(NewsConstants.removeFilterText),
                    message: nil,
                    primaryButton: .default(Text(NewsConstants.yesText), action: {
                        self.viewModel.resetSelectedFilterCategory()
                    }),
                    secondaryButton: .default(Text(NewsConstants.cancelText))
                )
            }
            .alert(isPresented: $showServerErrorAlert) {
                Alert(title: Text(NewsConstants.errorTitle), message: Text(NewsConstants.errorDesc), dismissButton: .default(Text(NewsConstants.okay)))
            }
            .onAppear {
                viewModel.fetchNewsFromServer()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ServerError"))) { object in
                showServerErrorAlert = true
                }
    }
    
    private func refreshContent() async {
        viewModel.fetchNewsFromServer()
     }

}

#Preview {
    NewsHeadlinesView()
}
