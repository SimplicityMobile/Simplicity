//
//  Helpers.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

class Helpers {
    /**
     Returns a list of URL Schemes that match the filter closure.
     
     - parameters:
       - closure: A closure returning true / false as to whether or not the URL 
         Scheme matches the filter
     - returns: A list of URL Schemes that match the filter closure.
     */
    static func registeredURLSchemes(filter closure: (String) -> Bool) -> [String] {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: AnyObject]] else {
            return [String]()
        }
        
        // Convert the complex dictionary into an array of URL schemes
        let urlSchemes = urlTypes.flatMap({($0["CFBundleURLSchemes"] as? [String])?.first })
        
        return urlSchemes.flatMap({closure($0) ? $0 : nil})
    }
    
    /**
     Converts a dictionary into a query string.
     
     - parameters:
       - parts: A dictionary of parameters to put in a query string.
     - returns: A query string
     */
    static func queryString(_ parts: [String: String?]) -> String? {
        return parts.flatMap { key, value -> String? in
            if let value = value {
                return key + "=" + value
            } else {
                return nil
            }
        }.joined(separator: "&").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
}

extension URL {
    /// Dictionary with key/value pairs from the URL fragment
    var fragmentDictionary: [String: String] {
        return dictionaryFromFormEncodedString(fragment)
    }
    
    /// Dictionary with key/value pairs from the URL query string
    var queryDictionary: [String: String] {
        return dictionaryFromFormEncodedString(query)
    }
    
    var fragmentAndQueryDictionary: [String: String] {
        var result = fragmentDictionary
        queryDictionary.forEach { (key, value) in
            result[key] = value
        }
        return result
    }
    
    private func dictionaryFromFormEncodedString(_ input: String?) -> [String: String] {
        var result = [String: String]()
        
        guard let input = input else {
            return result
        }
        let inputPairs = input.components(separatedBy: "&")
        
        for pair in inputPairs {
            let split = pair.components(separatedBy: "=")
            if split.count == 2 {
                if let key = split[0].removingPercentEncoding, let value = split[1].removingPercentEncoding {
                    result[key] = value
                }
            }
        }
        return result
    }
}
