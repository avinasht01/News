//
//  NewsService.swift
//  News
//
//  Created by Avinash Thakur on 22/09/24.
//

import Foundation

class NewsService: NSObject {
    
    /** Function fetches list of news from server. In case of any filter category applied category wise news is returned.
     
     - Parameter: String News category to filter news
     - Returns: completion: @escaping ([NewsArticles], NetworkError?) List of news articles or error
     */
    static func getNewsFromServer(newsCategory: String? = nil, completion: @escaping ([NewsArticles], NetworkError?) -> Void) {
        if let serverUrl = prepareServerUrl(newsCategory: newsCategory) {
            NewsApiHelper().requestDataFromServer(url: serverUrl, completion: { result in
                switch result {
                case .success(let resultData):
                    let newsArticles = NewsService.parseServerResult(resultData: resultData)
                    completion(newsArticles, nil)
                    break
                case .failure(_): 
                    completion([], NetworkError.serverError)
                }
            })
        }
    }
    
    /** Function prepares server url with app api end point url, Api key and returns URL for the same.
     
     - Parameter: String News category to filter news
     - Returns: URL? Api url
     */
   static func prepareServerUrl(newsCategory: String?) -> URL? {
        var urlString = NewsConstants.apiEndPoint + NewsConstants.topHeadlines + NewsConstants.country
        if let category = newsCategory {
            urlString.append("\(NewsConstants.category)\(category)")
        }
        urlString.append("\(NewsConstants.apiKey)\(NewsConstants.apiKeyValue)")
        
        if let url = URL(string: urlString) {
            return url
        }
        return nil
    }
    
    /** Function parses the server data received and convert the data into articles list.
     
     - Parameter: Data? server result data
     - Returns: [NewsArticles] List of news arcticle
     */
    static func parseServerResult(resultData: Data?) -> [NewsArticles] {
        if let arcticlesData = resultData {
            let decoder = JSONDecoder()
            do {
                let articlesResponse = try decoder.decode(NewsResultModel.self, from: arcticlesData)
                print("the news articles result: \(articlesResponse)")
                return articlesResponse.articles
            } catch(let error) {
                print("error: \(error)")
                return []
            }
        }
        return []
    }
    
    
}

