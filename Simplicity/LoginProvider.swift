//
//  LoginProvider.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

public protocol LoginProvider {
    var authorizationURL: NSURL { get }
    var urlScheme: String { get }
    
    func linkHandler(url: NSURL, callback: ExternalLoginCallback?)
    
}