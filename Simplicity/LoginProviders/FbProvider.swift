//
//  FbProvider.swift
//  Pods
//
//  Created by Maxim Pedchenko on 16.08.16.
//
//

import Foundation

public class FbProvider: OAuth2 {
    /// Facebook Auth Type
    public var authType = FacebookAuthType.None
    
    /// An array with query string parameters for the authorization URL.
    override public var authorizationURLParameters: [String : String?] {
        var result = super.authorizationURLParameters
        result["auth_type"] = authType.rawValue
        return result
    }
    
    /**
     Initializes the Facebook login object. Auto configures based on the URL
     scheme you have in your app.
     */
    public init() {
        // Search for URL Scheme, error if not there
        guard let urlScheme = Helpers.registeredURLSchemes(filter: {$0.hasPrefix("fb")}).first,
            range = urlScheme.rangeOfString("\\d+", options: .RegularExpressionSearch) else {
                preconditionFailure("You must configure your Facebook URL Scheme to use Facebook login.")
        }
        let clientId = urlScheme.substringWithRange(range)
        
        let appURL = NSURL(string: "fbauth://authorize")!
        let safariURL = NSURL(string: "https://www.facebook.com/dialog/oauth")!
        
        let authorizationEndpoint = UIApplication.sharedApplication().canOpenURL(appURL) ? appURL : safariURL
        let redirectEndpoint = NSURL(string: urlScheme + "://authorize")!
        
        super.init(clientId: clientId, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectEndpoint, grantType: .Implicit)
    }
}
