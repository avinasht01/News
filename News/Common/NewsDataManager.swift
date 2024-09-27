//
//  NewsDataManager.swift
//  News
//
//  Created by Avinash Thakur on 26/09/24.
//

import Foundation
import CoreData

/// NewsDataManager handles core database interaction to fetch and modify database for boomarked news article
class NewsDataManager: NSObject {
    static let sharedInstance = NewsDataManager()
    private let databaseModelName: String!
    
    private override init() {
        self.databaseModelName = NewsConstants.databaseName
    }
    
    // MARK: - Core Data Variables
    
    /// NSManagedObjectContext instance
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    /// NSManagedObjectModel instance
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.databaseModelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    
    /// NSPersistentStoreCoordinator instance
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = self.databaseModelName + NewsConstants.databaseExtension
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            return nil
        }
        
        return persistentStoreCoordinator
    }()
    
    // MARK: Testcases helper functions
    func checkIfDatabaseExist() -> Bool {
        guard Bundle.main.url(forResource: self.databaseModelName, withExtension: "momd") != nil else {
            return false
        }
        return true
    }
    
    func checkIfDatabaseCanBeLoaded() -> Bool {
        guard let modelURL = Bundle.main.url(forResource: self.databaseModelName, withExtension: "momd") else {
            return false
        }
        guard NSManagedObjectModel(contentsOf: modelURL) != nil else {
            return false
        }
        return true
    }
    
    func checkIfCoreDataPersistentStoreCoordinatorIsInitialised() -> Bool {
        if persistentStoreCoordinator != nil {
            return true
        } else {
            return false
        }
    }
    
    
    /** Function fetches list of all bookmarked news articles from database.
     
     - Returns: completionHandler: @escaping([NewsArticles], Error?) NewsArticles list or Error
     */
    func getAllBookmarkedUsersFromDatabase(completionHandler: @escaping([NewsArticles], Error?)->()) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NewsConstants.databaseName)
        guard let result = try? self.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] else {
            completionHandler([], nil)
            return
        }
        let newsArticles = self.convertManagedObjectResultIntoNewsArticle(inputArray: result)
        completionHandler(newsArticles, nil)
    }
    
    /** Function adds news article into bookmark database
     
     - Parameters newsArticle: NewsArticles
     */
    func addBoomarkedArticleIntDatabase(newsArticle: NewsArticles) {
       // let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NewsConstants.databaseName)
        let entry = NewsArticle(context: self.managedObjectContext)
        entry.id = newsArticle.id
        entry.desc = newsArticle.desc
        entry.title = newsArticle.title
        entry.date = newsArticle.dateString
        entry.urlToImage = newsArticle.urlToImage
            try? self.managedObjectContext.save()
    }
    
    /** Function deletes news article into bookmark database
     
     - Parameters newsArticle: NewsArticles
     */
    func deleteBomarkedArticleIntDatabase(newsArticle: NewsArticles) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NewsConstants.databaseName)
        fetchRequest.predicate = NSPredicate(format: "title == %@", newsArticle.title!)
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest)
            if let managedObject = result[0] as? NSManagedObject {
                self.managedObjectContext.delete(managedObject)
            }
            try self.managedObjectContext.save()
        } catch( let error) {
            print("erorr: \(error)")
        }
    }
    
    
    /** Function converts NSManagedObject item list fetched from database into array of NewsArticle
     
    - Parameters: [NSManagedObject] NSManagedObject of articles fetched from database
    - Returns: [NewsArticles] Bookmarked news articles
     */
     func convertManagedObjectResultIntoNewsArticle(inputArray: [NSManagedObject]) -> [NewsArticles] {
        var bookmarkArticles = [NewsArticles]()
        for object in inputArray {
            let newsArticle = NewsArticles(id: object.value(forKey: "id") as? String, title: object.value(forKey: "title") as? String, desc: object.value(forKey: "desc") as?String, dateSting: object.value(forKey: "date") as? String, urlToImage: object.value(forKey: "urlToImage") as? String)
            bookmarkArticles.append(newsArticle)
        }
        return bookmarkArticles
    }
    
    
    /** Function checks if news article exist into bookamr Database
     
    - Parameters: [NSManagedObject] NSManagedObject of articles fetched from database
    - Returns: Bool
     */
    func checkIfNewsItemExistIntoDatabase(newsArticle: NewsArticles) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NewsConstants.databaseName)
        fetchRequest.predicate = NSPredicate(format: "title == %@", newsArticle.title!)
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest)
            if result.count > 0 {
                return true
            } else {
                return false
            }
        } catch( let error) {
            print("erorr: \(error)")
        }
        return false
    }
}
