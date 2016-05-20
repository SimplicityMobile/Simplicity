//
//  OAuth2Error.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/17/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import Foundation

/**
 An OAuth 2 Error response. Subclass of LoginError. 
 Error codes subject to change, so initialize a OAuth2ErrorCode enum with the 
 raw value of the error code to check.
 */
public class OAuth2Error: LoginError {
    /// A mapping of OAuth 2 Error strings to OAuth2ErrorCode enum.
    public static let mapping: [String: OAuth2ErrorCode] = [ "invalid_request": .InvalidRequest,
                                                             "unauthorized_client": .UnauthorizedClient,
                                                             "access_denied": .AccessDenied,
                                                             "unsupported_response_type": .UnsupportedResponseType,
                                                             "invalid_scope": .InvalidScope,
                                                             "server_error": .ServerError,
                                                             "temporarily_unavailable": .TemporarilyUnavailable ]
    
    /**
     Constructs a OAuth 2 error object from an OAuth response.
     
     - parameters:
       - callbackParameters: A dictionary of OAuth 2 Error response parameters.
     - returns: OAuth2Error object.
     */
    public class func error(callbackParameters: [String: String]) -> LoginError? {
        let errorCode = mapping[callbackParameters["error"] ?? ""]
        
        if let errorCode = errorCode {
            let errorDescription = callbackParameters["error_description"]?.stringByRemovingPercentEncoding?.stringByReplacingOccurrencesOfString("+", withString: " ") ?? errorCode.description
            
            return OAuth2Error(code: errorCode.rawValue, description: errorDescription)
        } else {
            return nil
        }
    }
}

/// OAuth 2 Error codes
public enum OAuth2ErrorCode: Int, CustomStringConvertible {
    /**
     The request is missing a required parameter. This is usually programmer 
     error, and should be filed as a GitHub issue.
     */
    case InvalidRequest = 100,
    
    ///  The client ID is not authorized to make this request.
    UnauthorizedClient,
    
    /// The user or OAuth server denied this request.
    AccessDenied,
    
    /// The grant type requested is not supported. This is programmer error.
    UnsupportedResponseType,
    
    /// A scope requested is invalid.
    InvalidScope,
    
    /// The authorization server is currently experiencing an error.
    ServerError,
    
    /// The authorization server is currently unavailable. 
    TemporarilyUnavailable
    
    /// User readable default error message
    public var description: String {
        switch self {
        case .InvalidRequest:
            return "The OAuth request is missing a required parameter"
        case .UnauthorizedClient:
            return "The client ID is not authorized to make this request"
        case .AccessDenied:
            return "You denied the login request"
        case .UnsupportedResponseType:
            return "The grant type requested is not supported"
        case .InvalidScope:
            return "A scope requested is invalid"
        case .ServerError:
            return "The login server experienced an internal error"
        case .TemporarilyUnavailable:
            return "The login server is temporarily unavailable. Please try again later. "
        }
    }
}