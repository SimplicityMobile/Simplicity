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
    public static let mapping: [String: OAuth2ErrorCode] = [ "invalid_request": .invalidRequest,
                                                             "unauthorized_client": .unauthorizedClient,
                                                             "access_denied": .accessDenied,
                                                             "unsupported_response_type": .unsupportedResponseType,
                                                             "invalid_scope": .invalidScope,
                                                             "server_error": .serverError,
                                                             "temporarily_unavailable": .temporarilyUnavailable ]
    
    /**
     Constructs a OAuth 2 error object from an OAuth response.
     
     - parameters:
       - callbackParameters: A dictionary of OAuth 2 Error response parameters.
     - returns: OAuth2Error object.
     */
    public class func error(_ callbackParameters: [String: String]) -> LoginError? {
        let errorCode = mapping[callbackParameters["error"] ?? ""]
        
        if let errorCode = errorCode {
            let errorDescription = callbackParameters["error_description"]?.removingPercentEncoding?.replacingOccurrences(of: "+", with: " ") ?? errorCode.description
            
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
    case invalidRequest = 100,
    
    ///  The client ID is not authorized to make this request.
    unauthorizedClient,
    
    /// The user or OAuth server denied this request.
    accessDenied,
    
    /// The grant type requested is not supported. This is programmer error.
    unsupportedResponseType,
    
    /// A scope requested is invalid.
    invalidScope,
    
    /// The authorization server is currently experiencing an error.
    serverError,
    
    /// The authorization server is currently unavailable. 
    temporarilyUnavailable
    
    /// User readable default error message
    public var description: String {
        switch self {
        case .invalidRequest:
            return "The OAuth request is missing a required parameter"
        case .unauthorizedClient:
            return "The client ID is not authorized to make this request"
        case .accessDenied:
            return "You denied the login request"
        case .unsupportedResponseType:
            return "The grant type requested is not supported"
        case .invalidScope:
            return "A scope requested is invalid"
        case .serverError:
            return "The login server experienced an internal error"
        case .temporarilyUnavailable:
            return "The login server is temporarily unavailable. Please try again later. "
        }
    }
}
