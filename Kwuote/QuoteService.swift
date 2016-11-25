//
//  QuoteService.swift
//  Kwuote
//
//  Created by Carson Carbery on 11/17/16.
//  Copyright © 2016 Carson Carbery. All rights reserved.
//

import Foundation


enum Result {
    case success
    case failure(Error)
}

class QuoteService {
    
    let urlExtension: String
    let baseURL: URL?
    let deviceId: Int = 123456789
    
    init(urlExtension: String){
        self.urlExtension = urlExtension
        baseURL = URL(string: "https://kwuote.com/api/c/")
    }
    
    
    //MARK: - GET QUOTE

    func getQuote(_ completion: @escaping ((Quote?, Result) ->Void))  {
        
        if let quoteURL = URL(string: "\(urlExtension)?i=\(deviceId)", relativeTo: baseURL) {
            
            print(quoteURL)
            
            let networkOperation = NetworkOperation(url: quoteURL)
            networkOperation.downloadJSONDictionaryFromURL(httpBody: [:]) {
                (JSONDictionary, HTTPResponse, error) in
                
                guard let json = JSONDictionary else {
                    if let error = error {
                        completion(nil, .failure(error))
                    }
                    return
                }
                
                let quote = Quote(JSON: json)
                let result = Result.success
                
                completion(quote, result)
                
            }
            
            
        } else {
            
            // entries with spaces make a invalid URL so need error handling for that here
            print("Could not construct a valid URL")
            let error = NSError(domain: "", code: 11,     userInfo: [NSLocalizedDescriptionKey: "Invalid request, possible blanks enterred in Challenge Code "])
            completion(nil, .failure(error))
        }
    }



}

