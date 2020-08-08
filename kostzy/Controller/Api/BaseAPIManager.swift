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
    
    func performGenericFetchRequest<T: Decodable>(urlString: String, token: String,
                                             errorMsg: @escaping (()-> Void),
                                             completion: @escaping ((T) -> ())) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.addValue(token, forHTTPHeaderField: "Authorization")
            let task = session.dataTask(with: request) { (data, response, error) in
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
                            url: String, token: String,
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
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil {
                completion(nil, nil, error)
            }
            
            guard let data = data else { return }

            do {
                guard let obj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
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
    
    func performPatchUploadRequest(payload: [String: Any],
                                   imageData: Data,
                                   url: String, token: String,
                                   completion: @escaping ([String: Any]?, URLResponse?, Error?) -> Void) {
        
        let session = URLSession.shared
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url:  URL(string: url)!)
        request.httpMethod = "PATCH"
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let httpBody = NSMutableData()

        if let name = payload["name"] {
             httpBody.appendString(convertFormField(named: "name", value: name, using: boundary))
        }
        
        if let about = payload["about"] {
             httpBody.appendString(convertFormField(named: "about", value: about, using: boundary))
        }
        
        if let image = payload["image"] {
            httpBody.append(convertFileData(fieldName: "image",
                                            fileName: UUID().uuidString + ".png",
                                            mimeType: "image/png",
                                            fileData: image as! Data,
                                            using: boundary))
        }
        
        
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
                
       let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil {
                completion(nil, nil, error)
            }
            
            guard let data = data else { return }

            do {
                guard let obj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
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
    
    func convertFormField(named name: String, value: Any, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    }
    
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
