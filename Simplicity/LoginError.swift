//
//  SimplicityError.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/17/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

public class LoginError: NSError {
    public static let InternalSDKError = LoginError(code: 0, description: "Internal SDK Error")
    
    /**
     Initializer for LoginError
     
     - parameters:
     - code: Error code for the error
     - description: Localized description of the error.
     */
    public init(code: Int, description: String) {
        var userInfo = [String: AnyObject]()
        userInfo[NSLocalizedDescriptionKey] = description
        
        super.init(domain: "Simplicity", code: code, userInfo: userInfo)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
