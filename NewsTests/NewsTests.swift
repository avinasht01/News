//
//  NewsTests.swift
//  NewsTests
//
//  Created by Avinash Thakur on 22/09/24.
//

import XCTest
@testable import News

final class NewsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    /// This test function would test if the app database with speficied name exists or not. In case of no database or change in database name, Test case would assert failure.
    func testIsDatabaseAvailable() {
        let isDatabaseAvailable = NewsDataManager.sharedInstance.checkIfDatabaseExist()
        XCTAssertEqual(isDatabaseAvailable, true)
    }
    
    /// This test function would test if the app database with speficied name can be loaded or not. In case of no database, Test case would assert failure.
    func testIfDatabaseCanBeLoaded() {
        let canDatabaseBeLoaded = NewsDataManager.sharedInstance.checkIfDatabaseCanBeLoaded()
        XCTAssertEqual(canDatabaseBeLoaded, true)
    }
    
    /// This test function would test if the app database can be initialised and its persistentStoreCoordinator is initialised.  Test case would assert failure in case of failure
    func testDatabaseInitialisation() {
        let databaseInitialised = NewsDataManager.sharedInstance.checkIfCoreDataPersistentStoreCoordinatorIsInitialised()
        XCTAssertEqual(databaseInitialised, true)
    }
    
    /// This app requires active internet connection, hence test case would in case of active internet connection.
    func testInternetConnection() {
        XCTAssertEqual(NetworkMonitor.shared.isConnected , true)
    }
    
    /// This test checks if the api key value was modified or not.
    func testApiKey() {
         let apiKey = NewsConstants.apiKeyValue
            XCTAssertEqual(apiKey, "d6956c2d8f9f4a6ab68d23426a9fd352")
    }
    
    /// This test checks if the api end point  value was modified or not.
    func testApiEndpoint() {
        let apiEndPoint = NewsConstants.apiEndPoint
        XCTAssertEqual(apiEndPoint, "https://newsapi.org/v2/")
    }
    
    /// This test checks if the api call to fetch news passes or fails.
    func testFetchNewsFromServer() {
        NewsService.getNewsFromServer() { newsArticles, error in
            XCTAssertNil(error)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
