//
//  NewsConstants.swift
//  News
//
//  Created by Avinash Thakur on 22/09/24.
//

import Foundation

/// App related constants
struct NewsConstants {
    static let databaseName = "NewsArticle"
    static let databaseExtension = "momd"
    static let apiKey = "&apiKey="
    static let apiKeyValue = "d6956c2d8f9f4a6ab68d23426a9fd352"
    static let apiEndPoint = "https://newsapi.org/v2/"
    static let topHeadlines = "top-headlines?"
    static let country = "country=us"
    static let category = "&category="
    static let title = "News"
    static let bookmarkTitle = "Bookmarked News"
    static let iconSize = 48.0
    static let cornerRadius = 8.0
    static let noArticlesText = "No news articles found."
    static let noBookmarksText = "No bookmarked articles found."
    static let textPadding = 16.0
    static let noInternetTitle = "Networks seems to be offline."
    static let noInternetDesc = "Please check you internet connection."
    static let noImageText = "No image available"
    static let removeFilterText = "Remove selected news category filter?"
    static let filterText = "Filter text by caetogory"
    static let bookmarkAlertTitle = "Bookmark"
    static let removeBookmarkText = "Remove article from bookmark?"
    static let addBookmarkText = "Bookmark this article?"
    static let yesText = "Yes"
    static let cancelText = "Cancel"
    static let errorTitle = "Server error"
    static let errorDesc = "Something went wrong while fetching from server"
    static let okay = "Okay"
}


/// NewsAppUtility
struct NewsAppUtility {
    
    /// Function converts news publishedAt date string format "yyyy-MM-dd'T'HH:mm:ssZ" into "yyyy-MM-dd HH:mm a"
    static func convertDateFormat(inputString: String?) -> String {
        if let inputDateString = inputString {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormatter.date(from: inputDateString) {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
                let newDateString = dateFormatter.string(from: date)
                return newDateString
            }
        }
        return ""
    }
}

