//
//  OAuth2LoginProvider.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

public protocol OAuth2LoginProvider: LoginProvider {
    var clientId: String { get }
    var scopes: Set<String> { get set }
    var grantType: OAuth2GrantType { get }
    var state: String { get }
}

public enum OAuth2GrantType: String {
    case AuthorizationCode = "authorization_code",
    Implicit = "implicit",
    Custom = ""
}