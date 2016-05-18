//
//  OAuth2.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/17/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit

public class OAuth2: OAuth2Provider {
    public final var scopes = Set<String>()
    private(set) public final var urlScheme: String
    
    public final let state = String(arc4random_uniform(10000000))
    private(set) public final var clientId: String
    private(set) public final var grantType: OAuth2GrantType
    
    private(set) public final var authorizationEndpoint: NSURL
    private(set) public final var redirectEndpoint: NSURL
    
    public var authorizationURLParameters: [String: String?] {
        guard grantType != .Custom else {
            preconditionFailure("Custom Grant Type Not Supported")
        }
        return ["client_id": clientId,
                "redirect_uri": redirectEndpoint.absoluteString,
                "response_type": grantType.rawValue,
                "scope": scopes.joinWithSeparator(" "),
                "state": state]
    }
    
    public var authorizationURL: NSURL {
        guard grantType != .Custom else {
            preconditionFailure("Custom Grant Type Not Supported")
        }
        
        let url = NSURLComponents(URL: authorizationEndpoint, resolvingAgainstBaseURL: false)!
        
        url.queryItems = authorizationURLParameters.flatMap({key, value -> NSURLQueryItem? in
            return value != nil ? NSURLQueryItem(name: key, value: value) : nil
        })
        
        return url.URL!
    }
    
    public func linkHandler(url: NSURL, callback: ExternalLoginCallback?) {
        switch grantType {
        case .AuthorizationCode:
            preconditionFailure("Authorization Code Grant Type Not Supported")
        case .Implicit:
            // Get the access token, and check that the state is the same
            guard let accessToken = url.fragmentDictionary["access_token"] where url.fragmentDictionary["state"] == state else {
                // Facebook's mobile implicit grant type returns errors as 
                // query. Don't think it's a huge issue to be liberal in looking 
                // for errors, so will check both.
                if let error = OAuth2Error.error(url.fragmentDictionary) ?? OAuth2Error.error(url.queryDictionary) {
                    callback?(accessToken: nil, error: error)
                } else {
                    callback?(accessToken: nil, error: LoginError.InternalSDKError)
                }
                return
            }
            
            callback?(accessToken: accessToken, error: nil)
        case .Custom:
            preconditionFailure("Custom Grant Type Not Supported")
        }
    }
    
    public init(clientId: String, urlScheme: String, authorizationEndpoint: NSURL, redirectEndpoint: NSURL, grantType: OAuth2GrantType) {
        if Helpers.registeredURLSchemes(filter: {$0 == urlScheme}).count != 1 {
            preconditionFailure("You must register your URL Scheme in Info.plist.")
        }
        
        self.grantType = grantType
        self.clientId = clientId
        self.urlScheme = urlScheme
        self.authorizationEndpoint = authorizationEndpoint
        self.redirectEndpoint = redirectEndpoint
    }
}
