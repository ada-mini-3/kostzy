//
//  APIManager.swift
//  kostzy
//
//  Created by Rais on 05/08/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import Foundation

struct BaseAPIManager {
    
    let baseUrl = "http://34.101.87.22:8000/api/v1/"
    let authUrl = "http://34.101.87.22:8000/api/auth/"
    
    func initSession(url: String) {
        let urlString = baseUrl + url
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJson(data: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJson(data: Data) {
        
    }
    
}
