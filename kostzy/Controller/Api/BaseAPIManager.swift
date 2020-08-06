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
   static let authUrl = "http://34.101.87.22:8000/api/auth/"
    
    func performGenericFetchRequest<T: Decodable>(urlString: String,
                                             errorMsg: @escaping (()-> Void),
                                             completion: @escaping ((T) -> ())) {
        if let url = URL(string: baseUrl + urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    errorMsg()
                    return
                }
                
                guard let data = data else { return }
    
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    completion(obj)
                } catch let error {
                    print("failed to decode json:", error)
                }
            }
            task.resume()
        }
    }
    
    func performPostRequest(payload: [String: Any],
                            url: String,
                            completion: @escaping ([String: Any]?, URLResponse?, Error?) -> Void) {
        let session = URLSession.shared
        var request = URLRequest(url:  URL(string: url)!)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload,
                                                          options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription, "JSON ERROR")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil {
                completion(nil, nil, error)
            }
            
            guard let data = data else { return }

            do {
                guard let obj = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    completion(nil, nil,NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }

                completion(obj, response, nil)
            } catch let error {
                print(error.localizedDescription, "Response Error")
                completion(nil, nil, error)
            }
            
        })
        task.resume()
    }
    
    
}
