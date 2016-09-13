//
//  SimplicityError.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/17/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

/**
 An error produced by a LoginProvider on redirecting back to the app. Error 
 domain is "Simplicity"
 */
public class LoginError: NSError {
    /// An error that should never happen. If seen, please open a GitHub issue.
    public static let InternalSDKError = LoginError(code: 0, description: "Internal SDK Error")
    
    /**
     Initializer for LoginError
     
     - parameters:
     - code: Error code for the error
     - description: Localized description of the error.
     */
    public init(code: Int, description: String) {
        var userInfo = [String: Any]()
        userInfo[NSLocalizedDescriptionKey] = description
        
        super.init(domain: "Simplicity", code: code, userInfo: userInfo)
    }
    
    /// Unimplemented stub since NSError implements  requires this init method.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
