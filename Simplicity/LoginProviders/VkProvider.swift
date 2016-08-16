//
//  VkProvider.swift
//  FoodBerry
//
//  Created by Maxim Pedchenko on 16.08.16.
//  Copyright © 2016 TakeAwayTeam. All rights reserved.
//


class VkProvider: OAuth2 {
    public init() {
        guard let urlScheme = Helpers.registeredURLSchemes(filter: {$0.hasPrefix("vk")}).first,
            let range = urlScheme.range(of: "\\d+", options: .regularExpression) else {
                preconditionFailure("You must configure your VK URL Scheme to use VK login.")
        }
    
        let clientId = urlScheme.substring(with: range)
        
        let appURL = URL(string: "vkauthorize://authorize")!
        let safariURL = URL(string: "https://oauth.vk.com/authorize")!
    
        let authorizationEndpoint = UIApplication.shared.canOpenURL(appURL) ? appURL : safariURL
        let redirectEndpoint = URL(string: urlScheme + "://authorize")!
        
        super.init(clientId: clientId, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectEndpoint, grantType: .Implicit)
    }
}
