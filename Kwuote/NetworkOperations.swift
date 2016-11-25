//
//  NetworkOperations.swift
//  Kwuote
//
//  Created by Carson Carbery on 11/17/16.
//  Copyright © 2016 Carson Carbery. All rights reserved.
//

import Foundation

public let TRENetworkingErrorDomain = "com.covle.RunDMC.NetworkingError"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20


class NetworkOperation {
    
    lazy var config: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.config)
    let queryURL: URL
    var httpMethod: String
    
    typealias JSON = [[String : AnyObject]]
    typealias JSONArrayCompletion = ([[String: AnyObject]]?, HTTPURLResponse?, NSError?) ->Void
    typealias JSONDictionaryCompletion = ([String: AnyObject]?, HTTPURLResponse?, NSError?) ->Void
    typealias JSONTaskCompletion = (JSON?, HTTPURLResponse?, NSError?)-> Void
    
    init(url:URL) {
        queryURL = url
        self.httpMethod = "GET"
    }
    
    convenience init(url: URL, httpMethod: String) {
        self.init(url: url)
        self.httpMethod = httpMethod
    }

    func downloadJSONDictionaryFromURL(httpBody: [String:String], completion: @escaping JSONDictionaryCompletion) {
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: queryURL)
        
        if httpMethod == "PUT" || httpMethod == "POST" {
            request.httpMethod = httpMethod
            request.httpBody = try! JSONSerialization.data(withJSONObject: httpBody, options: [])
        }
        
        print(request)
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                
                let error = NSError(domain: TRENetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error)
                return
            }
            
            if data == nil {
                
                if let error = error {
                    completion(nil, HTTPResponse, error as NSError?)
                }
                
            } else {
                
                switch(HTTPResponse.statusCode) {
                case 200:
                    
                    // 2. Create JSON Object with data
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        
                        completion(jsonDict, HTTPResponse, error as NSError?)
                        
                        
                    } catch let error as NSError {
                        completion(nil, HTTPResponse, error)
                        print("JSON Serialization failed. Error: \(error)")
                    }
                case 400, 401: let error = NSError(domain: "", code: (HTTPResponse.statusCode),     userInfo: [NSLocalizedDescriptionKey:"Information not found error: \(HTTPResponse.statusCode)"])
                completion(nil, HTTPResponse, error)
                    
                case 404: let error = NSError(domain: "", code: (HTTPResponse.statusCode),     userInfo: [NSLocalizedDescriptionKey:"Request URL not found: \(HTTPResponse.statusCode)"])
                completion(nil, HTTPResponse, error)
                    
                case 408: let error = NSError(domain: "", code: (HTTPResponse.statusCode),     userInfo: [NSLocalizedDescriptionKey:"Request timed out, please check your internet connection: \(HTTPResponse.statusCode)"])
                completion(nil, HTTPResponse, error)
                    
                case 422: let error = NSError(domain: "", code: (HTTPResponse.statusCode), userInfo: [NSLocalizedDescriptionKey:"Incorrect information enterred:"])
                completion(nil, HTTPResponse, error)
                    
                    
                    // AND MORE CASES TO HANDLE THE DIFFERENT ERROR CONDITIONS
                    
                default: let error = NSError(domain: "", code: (HTTPResponse.statusCode), userInfo: [NSLocalizedDescriptionKey:"An error occurred. Error code:"])
                completion(nil, HTTPResponse, error)
                    
                }
            }
        })
        
        dataTask.resume()
    }


}
