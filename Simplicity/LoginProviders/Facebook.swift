//
//  Facebook.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

public class Facebook: OAuth2LoginProvider {
    public var scopes = Set<String>()
    public var urlScheme: String
    
    public var state = arc4random_uniform(10000000)
    public var clientId: String
    public var grantType: OAuth2GrantType = .Custom
    public var authType: FacebookAuthType?
    
    public var authorizationURL: NSURL {
        // Auth_type is re-request since we need to ask for email scope again if
        // people decline the email permission. If it gets annoying because
        // people keep asking for more scopes, we can change this.
        
        let query = ["client_id": clientId,
                     "redirect_uri": urlScheme + "://authorize",
                     "response_type": "token",
                     "scope": scopes.joinWithSeparator(" "),
                     "auth_type": authType?.rawValue,
                     "state": String(state)]
        
        let queryString = Helpers.queryString(query)!
        
        return NSURL(string: "https://www.facebook.com/dialog/oauth?\(queryString)")!
    }
    
    public func linkHandler(url: NSURL, callback: ExternalLoginCallback?) {
        if(url.queryDictionary["error"] != nil) {
            // We are not even going to callback, because the user never started
            // the login process in the first place. Error is always because
            // people cancelled the FB login according to https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow
            return
        }
        
        // Get the access token, and check that the state is the same
        guard let accessToken = url.fragmentDictionary["access_token"] where url.fragmentDictionary["state"] == "\(state)" else {
            callback?(accessToken: nil, error: nil)
            return
        }
        
        callback?(accessToken: accessToken, error: nil)
    }
    
    public init() {
        // Search for URL Scheme, error if not there
        
        guard let urlScheme = Helpers.registeredURLSchemes(matching: {$0.hasPrefix("fb")}).first,
            range = urlScheme.rangeOfString("\\d+", options: .RegularExpressionSearch) else {
                preconditionFailure("You must configure your Facebook URL Scheme to use Facebook login.")
        }
        self.urlScheme = urlScheme
        self.clientId = urlScheme.substringWithRange(range)
    }
}

public enum FacebookAuthType: String {
    case Rerequest = "rerequest",
    Reauthenticate = "reauthenticate"
}