//
//  NewsApiHelper.swift
//  News
//
//  Created by Avinash Thakur on 22/09/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case serverError
}

class NewsApiHelper {
    
//    /**
//     Function request data from server for given url using URLSession
//     - Parameter url: URL Sets location tracking on /off
//     - Returns: completion  Returns completion handler with request data and error if any.
//     */
//    func requestDataForUrl(url: URL, completion: @escaping (Data?, Error?) -> Void) {
//        let request = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(
//            with: request, completionHandler: { data, response, error in
//                if error == nil {
//                    guard let resultData = data else {
//                        let error = NSError(domain: "Api Result Error", code: 101, userInfo: ["Desc" : "No data found"])
//                        completion(nil, error)
//                        return
//                    }
//                    completion(resultData, nil)
//                } else {
//                    completion(nil, error)
//                }
//            })
//        task.resume()
//    }

    /**
     Function request image data from server for given url using URLSession
     - Parameter url: String  Sets location tracking on /off
     - Returns: completion  Returns completion handler with requested image data and error if any.
     */
    func requestDataFromServer(url: URL, completion:@escaping(Result<Data,NetworkError>)->())  {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(
            with: request, completionHandler: { data, response, error in
                if error == nil {
                    guard let resultData = data else {
                        completion(.failure(.serverError))
                        return
                    }
                    completion(.success(resultData))
                } else {
                    completion(.failure(.serverError))
                }
            })
        task.resume()
    }
    
}
