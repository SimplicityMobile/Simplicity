//
//  Google.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/18/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

/**
 Class implementing Google login's mobile OAuth 2 flow.
 
 ## Using Google Login in your app.
 
 To get started, you first need to [register an 
 application](https://console.developers.google.com/project) with Google. Click
 "Enable and Manage APIs", and then the credentials tab. Create two sets of 
 OAuth Client IDs, one as "Web Application", and one as "iOS".
 
 Finally, open up your App's Xcode project and go to the project's info tab. 
 Under "URL Types", add a new entry, and in the URL schemes form field, type in 
 your Google iOS Client's `iOS URL scheme` from the Google Developer Console.
 
 Then, you can initiate the login screen by calling:
 
 ```
 Simplicity.login(Google()) { (accessToken, error) in
    // Insert code here
 }
 ```
 */
public class Google: OAuth2 {
    
    /**
     Initializes the Google login object. Auto configures based on the URL
     scheme you have in your app. Uses default scopes of 'email profile' to 
     match the Google SDK.
     */
    public init() {
        guard let urlScheme = Helpers.registeredURLSchemes(filter: {$0.hasPrefix("com.googleusercontent.apps.")}).first else {
                preconditionFailure("You must configure your Google URL Scheme to use Google login.")
        }
        
        let appId = urlScheme.componentsSeparatedByString(".").reverse().joinWithSeparator(".")
        let authorizationEndpoint = NSURL(string: "https://accounts.google.com/o/oauth2/auth")!
        let redirectionEndpoint = NSURL(string: "\(urlScheme):/oauth2callback")!
        
        super.init(clientId: appId, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectionEndpoint, grantType: .AuthorizationCode)
        self.scopes = ["email", "profile"]
    }
    
    /**
     Handles the resulting link from the OAuth Redirect
     
     - parameters:
     - url: The OAuth redirect URL
     - callback: A callback that returns with an access token or NSError.
     */
    override public func linkHandler(url: NSURL, callback: ExternalLoginCallback) {
        guard let authorizationCode = url.queryDictionary["code"] where url.queryDictionary["state"] == state else {
            if let error = OAuth2Error.error(url.queryDictionary) ?? OAuth2Error.error(url.queryDictionary) {
                callback(accessToken: nil, error: error)
            } else {
                callback(accessToken: nil, error: LoginError.InternalSDKError)
            }
            return
        }
        exchangeCodeForAccessToken(authorizationCode, callback: callback)
    }
    
    private func exchangeCodeForAccessToken(authorizationCode: String, callback: ExternalLoginCallback) {
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
                callback(accessToken: nil, error: LoginError.InternalSDKError) // This request should not fail.
                return
            }
            callback(accessToken: accessToken, error: nil)
        }
        task.resume()
    }
}
