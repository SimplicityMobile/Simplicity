//
//  Instagram.swift
//  Simplicity
//
//  Created by Edward Jiang on 6/21/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit

/**
 Class implementing Instagram's implicit grant flow.
 
 ## Using Instagram in your app.
 
 To get started, you first need to [register an
 application](https://www.instagram.com/developer/) with
 Instagram. After registering your app, go into your client settings page. Under 
 the security tab, add `instagram[CLIENT_ID_HERE]://authorize` as a valid 
 redirect URI, replacing `[APP_ID_HERE]` with your Instagram Client ID.
 
 Finally, open up your App's Xcode project and go to the project's
 info tab. Under "URL Types", add a new entry, and in the URL schemes form
 field, type in `instagram[CLIENT_ID_HERE]`. Then, you can initiate the login 
 screen by calling:
 ```
 Simplicity.login(Instagram()) { (accessToken, error) in
 // Insert code here
 }
 ```
 */
public class Instagram: OAuth2 {
    public init() {
        guard let urlScheme = Helpers.registeredURLSchemes(filter: {$0.hasPrefix("instagram")}).first else {
            preconditionFailure("You must configure your Instagram URL Scheme to use Instagram login.")
        }
        let clientId = urlScheme.substringFromIndex(urlScheme.startIndex.advancedBy(9))
        
        let authorizationEndpoint = NSURL(string: "https://api.instagram.com/oauth/authorize/")!
        let redirectEndpoint = NSURL(string: urlScheme + "://authorize")!
        
        super.init(clientId: clientId, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectEndpoint, grantType: .Implicit)
        
        self.scopes = ["basic"]
    }
}
