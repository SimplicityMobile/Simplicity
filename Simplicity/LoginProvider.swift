//
//  LoginProvider.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

/**
 A LoginProvider represents an external login provider that needs to be opened. 
 */
public protocol LoginProvider {
    /// The URL to redirect to when beginning the login process
    var authorizationURL: URL { get }
    
    /// The URL Scheme that this LoginProvider is bound to.
    var urlScheme: String { get }
    
    /**
     Called when the external login provider links back into the application 
     with a URL Scheme matching the login provider's URL Scheme. 
     
     - parameters:
       - url: The URL that triggered that AppDelegate's link handler
       - callback: A callback that returns with an access token or NSError.
     */
    func linkHandler(_ url: URL, callback: @escaping ExternalLoginCallback)
}

public extension LoginProvider {
    func login(_ callback: @escaping ExternalLoginCallback) {
        Simplicity.login(self, callback: callback)
    }
}
