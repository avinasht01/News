//
//  SwiftUIUtility.swift
//  News
//
//  Created by Avinash Thakur on 26/09/24.
//

import Foundation
import SwiftUI

struct SwiftUIUtility {
    
    struct NewsCardsView: View {
        var article: NewsArticles
        @ObservedObject var viewModel = NewsViewModel()
        var body: some View {
            ZStack(alignment: .topTrailing) {
                HStack {
                    NewsImageView(article: article, imageWidth: 100, imageHeight: 100, maxWidth: false)
                    NewsTitleView(article: article)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
        }
    }
    
    struct NewsImageView: View {
        var article: NewsArticles
        var imageWidth: CGFloat
        var imageHeight: CGFloat
        var maxWidth: Bool = false
        var body: some View {
            VStack {
                if let imageUrl = article.urlToImage {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        if let image = phase.image {
                            if maxWidth {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: imageHeight)
                                    .frame(maxWidth: .infinity)
                            } else {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: imageWidth, height: imageHeight)
                            }
                        } else if phase.error != nil {
                            ImagePlaceholderView(imageWidth: imageWidth, imageHeight: imageHeight)
                        } else {
                            ImagePlaceholderView(imageWidth: imageWidth, imageHeight: imageHeight)
                        }
                    }
                } else {
                    ImagePlaceholderView(imageWidth: imageWidth, imageHeight: imageHeight)
                }
            }
        }
    }
    
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
        var imageWidth: CGFloat
        var imageHeight: CGFloat
        var body: some View {
            VStack(alignment: .leading, content: {
                ZStack(alignment: .center, content: {
                    Rectangle()
                        .fill(Color.gray)
                        .opacity(0.4)
                        .cornerRadius(8.0)
                    Text(NewsConstants.noImageText)
                })
            })
            .frame(height: imageHeight)
            .frame(width: imageWidth, height: imageHeight)
        }
    }
    
    struct NoInternetView: View {
        var body: some View {
            VStack {
                Spacer()
                Image(.wifiDisconnected)
                    .resizable()
                    .frame(width: NewsConstants.iconSize, height: NewsConstants.iconSize)
                    .aspectRatio(contentMode: .fit)
                Text(NewsConstants.noInternetTitle)
                    .padding(.horizontal, NewsConstants.textPadding)
                Text(NewsConstants.noInternetDesc)
                    .padding(.horizontal, NewsConstants.textPadding)
                Spacer()
            }
        }
    }
    
    struct BookmarkEmptyView: View {
        var body: some View {
            VStack {
                Spacer()
                Image(.bookmarked)
                    .resizable()
                    .frame(width: NewsConstants.iconSize, height: NewsConstants.iconSize)
                    .aspectRatio(contentMode: .fit)
                Text(NewsConstants.noBookmarksText)
                    .padding(.horizontal, NewsConstants.textPadding)
                Spacer()
            }
        }
    }
    
    struct NewsArcticlesEmptyView: View {
        var body: some View {
            VStack {
                Spacer()
                Image(.noContent)
                    .resizable()
                    .frame(width: NewsConstants.iconSize, height: NewsConstants.iconSize)
                    .aspectRatio(contentMode: .fit)
                Text(NewsConstants.noArticlesText)
                    .padding(.horizontal, NewsConstants.textPadding)
                Spacer()
            }
        }
    }
    
}
