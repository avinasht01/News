//
//  BookmarkView.swift
//  News
//
//  Created by Avinash Thakur on 26/09/24.
//

import SwiftUI

struct BookmarkView: View {
    
    @ObservedObject var viewModel = NewsViewModel()
  //  @FetchRequest(sortDescriptors: []) var boomarkedNewsArticles: FetchedResults<NewsArticle>
    
    var body: some View {
        VStack {
        if viewModel.bookmarkedArticles.count > 0 {
            NavigationStack {
                List(viewModel.bookmarkedArticles, id: \.id) { news in
                    NavigationLink(destination: NewsDetailView(article: news)) {
                        SwiftUIUtility.NewsCardsView(article: news, viewModel: viewModel)
                    }
                }
                .navigationTitle(NewsConstants.bookmarkTitle)
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.inset)
            }
        } else {
            SwiftUIUtility.BookmarkEmptyView()
        }
    }
        .onAppear {
            viewModel.fetchAllBookmarkedNews()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("BookmarkUpdate"))) { object in
            viewModel.fetchAllBookmarkedNews()
            }
}
    }

#Preview {
    BookmarkView()
}


//struct NewsCardsView: View {
//    var article: NewsArticles
//    @ObservedObject var viewModel = NewsViewModel()
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//        HStack {
//                if let imageUrl = article.urlToImage {
//                    AsyncImage(url: URL(string: imageUrl)) { phase in
//                        if let image = phase.image {
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
//                        } else if phase.error != nil {
//                            // Text("No image available")
//                            SwiftUIUtility.ImagePlaceholderView()
//                        } else {
//                            SwiftUIUtility.ImagePlaceholderView()
//                        }
//                    }
//                    .cornerRadius(8.0)
//                } else {
//                    SwiftUIUtility.ImagePlaceholderView()
//                }
//            SwiftUIUtility.NewsTitleView(article: article)
//                
//                Spacer()
//            }
//            SwiftUIUtility.BookmarkButtonView(viewModel: viewModel, article: article)
//                .offset(x: 40, y: -10)
//        }
//        .frame(maxWidth: .infinity)
//        .frame(height: 100)
//    }
//}



struct NewsTitleView: View {
    var article: NewsArticles
    var body: some View {
        VStack {
            if let titleStr = article.title {
                Text("\(titleStr)")
            }
        }
    }
}

struct ImagePlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading, content: {
            ZStack(alignment: .center, content: {
                Text("No image available")
            })
        })
        .frame(width: 100, height: 100)
    }
}


struct BookmarkButtonView: View {
    @ObservedObject var viewModel = NewsViewModel()
    var article: NewsArticles
    var body: some View {
        VStack {
            Button {
              // book mark item and refresh view
            } label: {
                ZStack {
//                    if viewModel.isBookmarked(article: article) {
//                        Image(.bookmarked)
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                            .aspectRatio(contentMode: .fit)
//                    } else {
//                        Image(.bookmark)
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                            .aspectRatio(contentMode: .fit)
//                    }
                }
                
            }
            .frame(width: 40, height: 40)
        }
    }
}
