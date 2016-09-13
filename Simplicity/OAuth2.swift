//
//  OAuth2.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/17/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

/**
 Base implementation of a basic OAuth 2 provider. Only supports Implicit grant 
 types, but is overridable to support custom grant types.
 
 You should never implement the AuthorizationCode grant type unless you're sure 
 that the API Key Secret used is not important for anything else. Otherwise, 
 it's a security concern to leave it in your app as it can be sniffed and used 
 for malicious purposes.
 */
public class OAuth2: LoginProvider {
    /// A set of OAuth 2 Scopes to request from the login provider.
    public final var scopes = Set<String>()
    
    /// The URL Scheme registered by the app.
    public final var urlScheme: String {
        return redirectEndpoint.scheme!
    }
    
    /// The state used to prevent CSRF attacks with bad access tokens.
    public final let state = String(arc4random_uniform(10000000))
    
    /// The OAuth 2 Client ID
    public final let clientId: String
    
    /// The OAuth 2 Grant Type
    public final let grantType: OAuth2GrantType
    
    /// The OAuth 2 authorization endpoint
    public final let authorizationEndpoint: URL
    
    /// The OAuth 2 redirection endpoint
    public final let redirectEndpoint: URL
    
    /**
     An array with query string parameters for the authorization URL.
     Override this to pass custom data to the OAuth provider. 
     */
    public var authorizationURLParameters: [String: String?] {
        guard grantType != .Custom else {
            preconditionFailure("Custom Grant Type Not Supported")
        }
        return ["client_id": clientId,
                "redirect_uri": redirectEndpoint.absoluteString,
                "response_type": grantType.rawValue,
                "scope": scopes.joined(separator: " "),
                "state": state]
    }
    
    /// The authorization URL to start the OAuth flow. 
    public var authorizationURL: URL {
        guard grantType != .Custom else {
            preconditionFailure("Custom Grant Type Not Supported")
        }
        
        var url = URLComponents(url: authorizationEndpoint, resolvingAgainstBaseURL: false)!
        
        url.queryItems = authorizationURLParameters.flatMap({key, value -> URLQueryItem? in
            return value != nil ? URLQueryItem(name: key, value: value) : nil
        })
        
        return url.url!
    }
    
    /**
     Handles the resulting link from the OAuth Redirect
     
     - parameters:
     - url: The OAuth redirect URL
     - callback: A callback that returns with an access token or NSError.
     */
    public func linkHandler(_ url: URL, callback: @escaping ExternalLoginCallback) {
        switch grantType {
        case .AuthorizationCode:
            preconditionFailure("Authorization Code Grant Type Not Supported")
        case .Implicit:
            // Get the access token, and check that the state is the same
            guard let accessToken = url.fragmentDictionary["access_token"], url.fragmentAndQueryDictionary["state"] == state else {
                /**
                 Facebook's mobile implicit grant type returns errors as 
                 query. Don't think it's a huge issue to be liberal in looking 
                 for errors, so will check both.
                 */
                if let error = OAuth2Error.error(url.fragmentAndQueryDictionary) {
                    callback(nil, error)
                } else {
                    callback(nil, LoginError.InternalSDKError)
                }
                return
            }
            
            callback(accessToken, nil)
        case .Custom:
            preconditionFailure("Custom Grant Type Not Supported")
        }
    }
    
    /**
     Creates a generic OAuth 2 Login Provider.
     
     - parameters:
       - clientId: The OAuth Client ID
       - authorizationEndpoint: The OAuth Provider's Authorization Endpoint. The 
         application will redirect to this endpoint to start the login flow.
       - redirectEndpoint: The redirect URI passed to the provider.
       - grantType: The OAuth 2 Grant Type
     */
    public init(clientId: String, authorizationEndpoint: URL, redirectEndpoint: URL, grantType: OAuth2GrantType) {
        self.grantType = grantType
        self.clientId = clientId
        self.authorizationEndpoint = authorizationEndpoint
        self.redirectEndpoint = redirectEndpoint
        
        if Helpers.registeredURLSchemes(filter: {$0 == self.urlScheme}).count != 1 {
            preconditionFailure("You must register your URL Scheme in Info.plist.")
        }
    }
}

/// The OAuth 2 Grant Type
public enum OAuth2GrantType: String {
    /// Authorization Code Grant Type
    case AuthorizationCode = "code",
    
    /// Implicit Grant Type
    Implicit = "token",
    
    /// Custom Grant Type
    Custom = ""
}
