//
//  Facebook.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

public class Facebook: OAuth2 {
    public var authType = FacebookAuthType.None
    
    override public var authorizationURLParameters: [String : String?] {
        var result = super.authorizationURLParameters
        result["auth_type"] = authType?.rawValue
        return result
    }
    
    public init() {
        // Search for URL Scheme, error if not there
        
        guard let urlScheme = Helpers.registeredURLSchemes(filter: {$0.hasPrefix("fb")}).first,
            range = urlScheme.rangeOfString("\\d+", options: .RegularExpressionSearch) else {
                preconditionFailure("You must configure your Facebook URL Scheme to use Facebook login.")
        }
        let clientId = urlScheme.substringWithRange(range)
        let authorizationEndpoint = NSURL(string: "https://www.facebook.com/dialog/oauth")!
        let redirectEndpoint = NSURL(string: urlScheme + "://authorize")!
        
        super.init(clientId: clientId, urlScheme: urlScheme, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectEndpoint, grantType: .Implicit)
    }
}

public enum FacebookAuthType: String {
    case Rerequest = "rerequest",
    Reauthenticate = "reauthenticate",
    None = ""
}