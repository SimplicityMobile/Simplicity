//
//  Helpers.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

class Helpers {
    static func registeredURLSchemes(filter closure: String -> Bool) -> [String] {
        guard let urlTypes = NSBundle.mainBundle().infoDictionary?["CFBundleURLTypes"] as? [[String: AnyObject]] else {
            return [String]()
        }
        
        // Convert the complex dictionary into an array of URL schemes
        let urlSchemes = urlTypes.flatMap({($0["CFBundleURLSchemes"] as? [String])?.first })
        
        return urlSchemes.flatMap({closure($0) ? $0 : nil})
    }
    
    static func queryString(parts: [String: String?]) -> String? {
        return parts.flatMap { key, value -> String? in
            if let value = value {
                return key + "=" + value
            } else {
                return nil
            }
        }.joinWithSeparator("&").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
}

extension NSURL {
    /// Dictionary with key/value pairs from the URL fragment
    var fragmentDictionary: [String: String] {
        return dictionaryFromFormEncodedString(fragment)
    }
    
    /// Dictionary with key/value pairs from the URL query string
    var queryDictionary: [String: String] {
        return dictionaryFromFormEncodedString(query)
    }
    
    private func dictionaryFromFormEncodedString(input: String?) -> [String: String] {
        var result = [String: String]()
        
        guard let input = input else {
            return result
        }
        let inputPairs = input.componentsSeparatedByString("&")
        
        for pair in inputPairs {
            let split = pair.componentsSeparatedByString("=")
            if split.count == 2 {
                if let key = split[0].stringByRemovingPercentEncoding, value = split[1].stringByRemovingPercentEncoding {
                    result[key] = value
                }
            }
        }
        return result
    }
}