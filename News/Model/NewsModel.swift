//
//  NewsModel.swift
//  News
//
//  Created by Avinash Thakur on 22/09/24.
//

import Foundation


/// News Api data struct
struct NewsResultModel: Codable {
    let status: String?
    let errorCode: String?
    let errorMessage: String?
    let totalResults: Int?
    var articles = [NewsArticles]()
}

/// News articles struct
struct NewsArticles: Codable, Identifiable, Hashable {
    var id: String?
    var title: String?
    var desc: String?
    var publishedAt: String?
    var url: String?
    var urlToImage: String?
    var content: String?
    var dateString: String?
    
    init(id: String?, title: String?, desc: String?, dateSting: String?, urlToImage: String?)  {
        self.id = id
        self.title = title
        self.desc = desc
        self.dateString = dateSting
        self.urlToImage = urlToImage
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, publishedAt, url, urlToImage, content, dateString
        case desc = "description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if (try? container.decode(Int.self, forKey: .id)) != nil {
            self.id = UUID().uuidString
        } else {
            self.id = UUID().uuidString
        }
        
        self.title = try? container.decode(String.self, forKey: .title)
        self.desc = try? container.decode(String.self, forKey: .desc)
        self.dateString = try? container.decode(String.self, forKey: .dateString)
        if let publishedDate = try? container.decode(String.self, forKey: .publishedAt) {
            updateDateFormat(dateString: publishedDate)
        } else {
            self.dateString = ""
        }
        self.publishedAt = try? container.decode(String.self, forKey: .publishedAt)
        self.url = try? container.decode(String.self, forKey: .url)
        self.urlToImage = try? container.decode(String.self, forKey: .urlToImage)
        self.content = try? container.decode(String.self, forKey: .content)
    }
    
    /// Mutating function added to convert publishedAt string into displayable date format and assigned to parameter dateString
    mutating func updateDateFormat(dateString: String) {
        self.dateString = NewsAppUtility.convertDateFormat(inputString: dateString)
    }
    
}
