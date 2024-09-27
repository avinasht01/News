//
//  NewsDetailView.swift
//  News
//
//  Created by Avinash Thakur on 24/09/24.
//

import SwiftUI

struct NewsDetailView: View {
    
    var article: NewsArticles
    @ObservedObject var viewModel = NewsViewModel()
    @State private var showBookmarkAlert: Bool = false
    
    var body: some View {
        VStack {
            NavigationView {
                if viewModel.networkConnector {
                    ScrollView {
                        if let newsTitle = article.title {
                            Text(newsTitle)
                                .frame(alignment: .center)
                                .bold()
                                .padding(.horizontal, NewsConstants.textPadding)
                        }
                        SwiftUIUtility.NewsImageView(article: article, imageWidth: 200, imageHeight: 200, maxWidth: true)
                        if let newsDesc = article.desc {
                            Text(newsDesc)
                                .padding(.horizontal, NewsConstants.textPadding)
                                .frame(alignment: .center)
                        }
                        HStack {
                            Spacer()
                            if let date = article.dateString {
                                Text(date)
                                    .padding(.trailing, NewsConstants.textPadding)
                            }
                        }
                        Spacer()
                    }
                } else {
                    SwiftUIUtility.NoInternetView()
                }
            }
            .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                            showBookmarkAlert = true
                            
                    } label: {
                            Image(viewModel.currentArticleBookmarkState ? .bookmarked : .bookmark)
                                .frame(width: NewsConstants.iconSize, height: NewsConstants.iconSize)
                                .foregroundColor(.blue)
                                .cornerRadius(NewsConstants.cornerRadius)
                    }
                    .alert(isPresented: $showBookmarkAlert) {
                                Alert(
                                    title: Text(NewsConstants.bookmarkAlertTitle),
                                    message: viewModel.currentArticleBookmarkState ? Text(NewsConstants.removeBookmarkText) : Text(NewsConstants.addBookmarkText),
                                    primaryButton: .default(Text(NewsConstants.yesText), action: {
                                        if viewModel.currentArticleBookmarkState {
                                            self.viewModel.deleteBookmark(news: article)
                                        } else {
                                            self.viewModel.markNewsAsBookmark(news: article)
                                        }
                                    }),
                                    secondaryButton: .default(Text(NewsConstants.cancelText))
                                )
                            }
                }
            }
        }
        .onAppear {
            viewModel.isBookmarked(article: article)
        }
        .onDisappear {
            NotificationCenter.default.post(name: NSNotification.Name("BookmarkUpdate"), object: self)
        }
    }
    
}
