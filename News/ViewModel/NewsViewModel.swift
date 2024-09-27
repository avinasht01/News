//
//  NewsViewModel.swift
//  News
//
//  Created by Avinash Thakur on 22/09/24.
//

import Foundation
import Combine
import CoreData

/// Enum for news filter category
enum NewsCategory: String {
    case science
    case technology
    case entertainment
    case sports
    case nofilter
}

class NewsViewModel: NSObject, ObservableObject {
    
    /// List of news arcticles
    @Published var articlesList = [NewsArticles]()
    
    /// List of bookmarked news articles
    @Published var bookmarkedArticles = [NewsArticles]()
    
    /// Current selected news arcticle book mark state.
    @Published var currentArticleBookmarkState = false
    
    /// Network connector instance
    @Published var networkConnector = true
    
    override init() {

    }
    
    // MARK: Initialisation functions
    /// Function initialises viewmodel and start network monitoring.
    func initialise() {
        NetworkMonitor.shared.startMonitoring()
        NotificationCenter.default.addObserver(self, selector: #selector(internetConnectionStatus(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    @objc func internetConnectionStatus(notification: Notification) {
        DispatchQueue.main.async {
            self.networkConnector = NetworkMonitor.shared.isConnected
        }
    }
    
    // MARK: News Category filter functions
    
    var newsCategory: NewsCategory = .nofilter {
        didSet {
            if newsCategory != .nofilter {
                fetchNewsFromServerForSelectedCategory()
            }
        }
    }
    
    /// Functions resets the selected filter and fetches general news list from server.
    func resetSelectedFilterCategory() {
        self.newsCategory = .nofilter
        self.fetchLatestNewsFromServer()
    }
    
    // MARK: News article fetching functions
    /// Function fetches the list of general top headlines from server. In case of any filter news as per category are feteched from server.
    func fetchNewsFromServer() {
        if newsCategory == .nofilter {
            self.fetchLatestNewsFromServer()
        } else {
            fetchNewsFromServerForSelectedCategory()
        }
    }
    
    /// Function fetches category wise news from server.
    func fetchNewsFromServerForSelectedCategory() {
            let categoryString = newsCategory.rawValue
            NewsService.getNewsFromServer(newsCategory: categoryString, completion: { categoryArticles, error in
                DispatchQueue.main.async {
                    if error == nil {
                        if categoryArticles.count > 0 {
                            self.articlesList = self.checkAndRemovedUnpublishedContent(news: categoryArticles)
                        } else {
                            self.articlesList = []
                        }
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name("ServerError"), object: self)
                    }
                }
            })
    }
    
    /// Function fetches general news from server.
    func fetchLatestNewsFromServer() {
            NewsService.getNewsFromServer() { newsArticles, error in
                DispatchQueue.main.async {
                    if error == nil {
                        if newsArticles.count > 0 {
                            DispatchQueue.main.async {
                                self.articlesList = self.checkAndRemovedUnpublishedContent(news: newsArticles)
                            }
                        } else {
                            self.articlesList = []
                        }
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name("ServerError"), object: self)
                    }
                }
            }
    }
    
    /// Function removes unpublished news from news list, as sever does not removed unpublished news.
    func checkAndRemovedUnpublishedContent(news: [NewsArticles]) -> [NewsArticles] {
        let filteredNews = news.filter { news in
            if let title = news.title, title.contains("Removed") {
                return false
            } else {
                return true
            }
        }
        return filteredNews
    }
    
    // MARK: Bookmark related functions
    /// Function checks if news article is bookmarked.
    func isBookmarked(article: NewsArticles) {
        self.currentArticleBookmarkState = NewsDataManager.sharedInstance.checkIfNewsItemExistIntoDatabase(newsArticle: article)
    }
    
    /// Function deletes the bookmarked news article from database
    func deleteBookmark(news: NewsArticles) {
        NewsDataManager.sharedInstance.deleteBomarkedArticleIntDatabase(newsArticle: news)
        currentArticleBookmarkState.toggle()
    }
    
    /// Function adds news article into bookmark database
    func markNewsAsBookmark(news: NewsArticles) {
        NewsDataManager.sharedInstance.addBoomarkedArticleIntDatabase(newsArticle: news)
        currentArticleBookmarkState.toggle()
        
    }
    
    /// Function fetches list of all bookmarked news article from database
    func fetchAllBookmarkedNews() {
        NewsDataManager.sharedInstance.getAllBookmarkedUsersFromDatabase(completionHandler: { news, error in
            if error == nil {
                self.bookmarkedArticles = news
            }
        })
    }
    
}
