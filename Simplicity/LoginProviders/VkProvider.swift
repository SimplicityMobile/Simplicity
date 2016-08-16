//
//  VkProvider.swift
//  FoodBerry
//
//  Created by Maxim Pedchenko on 16.08.16.
//  Copyright © 2016 TakeAwayTeam. All rights reserved.
//


public class VkProvider: OAuth2 {
    public init() {
        guard let urlScheme = Helpers.registeredURLSchemes(filter: {$0.hasPrefix("vk")}).first,
            range = urlScheme.rangeOfString("\\d+", options: .RegularExpressionSearch) else {
                preconditionFailure("You must configure your VK URL Scheme to use VK login.")
        }
    
        let clientId = urlScheme.substringWithRange(range)
        
        let appURL = NSURL(string: "vkauthorize://authorize")!
        let safariURL = NSURL(string: "https://oauth.vk.com/authorize")!
    
        let authorizationEndpoint = UIApplication.sharedApplication().canOpenURL(appURL) ? appURL : safariURL
        let redirectEndpoint = NSURL(string: urlScheme + "://authorize")!
        
        super.init(clientId: clientId, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectEndpoint, grantType: .Implicit)
    }
}
