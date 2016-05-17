//
//  OAuth2Error.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/17/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

public class OAuth2Error: LoginError {
    
    public static let mapping: [String: OAuth2ErrorCode] = [ "invalid_request": .InvalidRequest,
                                                             "unauthorized_client": .UnauthorizedClient,
                                                             "access_denied": .AccessDenied,
                                                             "unsupported_response_type": .UnsupportedResponseType,
                                                             "invalid_scope": .InvalidScope,
                                                             "server_error": .ServerError,
                                                             "temporarily_unavailable": .TemporarilyUnavailable ]
    
    public class func error(callbackParameters: [String: String]) -> LoginError? {
        let errorCode = mapping[callbackParameters["error"] ?? ""]
        let errorDescription = callbackParameters["error_description"]
        
        if let errorCode = errorCode, errorDescription = errorDescription {
            return OAuth2Error(code: errorCode.rawValue, description: errorDescription)
        } else {
            return nil
        }
    }
}

public enum OAuth2ErrorCode: Int {
    case InvalidRequest = 100, UnauthorizedClient, AccessDenied, UnsupportedResponseType, InvalidScope, ServerError, TemporarilyUnavailable
}