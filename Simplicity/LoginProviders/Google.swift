//
//  Google.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/18/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit

public class Google: OAuth2 {
    public init() {
        guard let urlScheme = Helpers.registeredURLSchemes(filter: {$0.hasPrefix("com.googleusercontent.apps.")}).first else {
                preconditionFailure("You must configure your Google URL Scheme to use Google login.")
        }
        
        let appId = urlScheme.componentsSeparatedByString(".").reverse().joinWithSeparator(".")
        let authorizationEndpoint = NSURL(string: "https://accounts.google.com/o/oauth2/auth")!
        let redirectionEndpoint = NSURL(string: "\(urlScheme):/oauth2callback")!
        
        super.init(clientId: appId, urlScheme: urlScheme, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectionEndpoint, grantType: .AuthorizationCode)
        self.scopes = ["email", "profile"]
    }
    
    override public func linkHandler(url: NSURL, callback: ExternalLoginCallback?) {
        guard let authorizationCode = url.queryDictionary["code"] where url.queryDictionary["state"] == state else {
            if let error = OAuth2Error.error(url.queryDictionary) ?? OAuth2Error.error(url.queryDictionary) {
                callback?(accessToken: nil, error: error)
            } else {
                callback?(accessToken: nil, error: LoginError.InternalSDKError)
            }
            return
        }
        exchangeCodeForAccessToken(authorizationCode, callback: callback)
    }
    
    private func exchangeCodeForAccessToken(authorizationCode: String, callback: ExternalLoginCallback?) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        let url = NSURL(string: "https://www.googleapis.com/oauth2/v4/token")!
        
        let requestParams: [String: String?] = ["client_id": clientId,
                             "code": authorizationCode,
                             "grant_type": "authorization_code",
                             "redirect_uri": authorizationURLParameters["redirect_uri"] ?? nil]
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = Helpers.queryString(requestParams)?.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            guard let data = data, json = try? NSJSONSerialization.JSONObjectWithData(data, options: []), accessToken = json["access_token"] as? String else {
                callback?(accessToken: nil, error: LoginError.InternalSDKError) // This request should not fail.
                return
            }
            callback?(accessToken: accessToken, error: nil)
        }
        task.resume()
    }
}
