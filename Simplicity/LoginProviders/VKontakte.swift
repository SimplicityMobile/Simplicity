//
//  VKontakte.swift
//  Simplicity
//
//  Created by Andrey Toropchin on 14.07.16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

/**
 Class implementing VKontakte (VK.com) implicit grant flow.

 ## Using VKontakte in your app.

 To get started, you first need to [create an application](https://vk.com/dev/) with VKontakte. 
 After registering your app, go into your client settings page.
 Set App Bundle ID for iOS to your App Bundle in Xcode -> Target -> Bundle Identifier (e.g. com.developer.applicationName)

 Finally, open up your App's Xcode project and go to the project's
 info tab. Under "URL Types", add a new entry, and in the URL schemes form
 field, type in `vk[CLIENT_ID_HERE]`. Then, you can initiate the login
 screen by calling:
 ```
 Simplicity.login(VKontakte()) { (accessToken, error) in
 // Insert code here
 }
 ```
 */

public class VKontakte: OAuth2 {

    public init() {
        guard let urlScheme = Helpers.registeredURLSchemes(filter: {$0.hasPrefix("vk")}).first,
            let range = urlScheme.range(of: "\\d+", options: .regularExpression) else {
                preconditionFailure("You must configure your VK URL Scheme to use VK login.")
        }
        let clientId = urlScheme.substring(with: range)
        let authorizationEndpoint = URL(string: "https://oauth.vk.com/authorize")!
        let redirectEndpoint = URL(string: urlScheme + "://authorize")!

        super.init(clientId: clientId, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectEndpoint, grantType: .Implicit)
    }
}
