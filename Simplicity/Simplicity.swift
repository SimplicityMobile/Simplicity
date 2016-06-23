//
//  Simplicity.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit
import SafariServices

/// Callback handler after an external login completes.
public typealias ExternalLoginCallback = (accessToken: String?, error: NSError?) -> Void

/**
 Simplicity is a framework for authenticating with external providers on iOS.
 */
public final class Simplicity {
    private static var currentLoginProvider: LoginProvider?
    private static var callback: ExternalLoginCallback?
    private static var safari: UIViewController?
    
    /**
     Begin the login flow by redirecting to the LoginProvider's website.
     
     - parameters:
     - loginProvider: The login provider object configured to be used.
     - callback: A callback with the access token, or a SimplicityError.
     */
    public static func login(loginProvider: LoginProvider, callback: ExternalLoginCallback) {
        self.currentLoginProvider = loginProvider
        self.callback = callback
        
        presentSafariView(loginProvider.authorizationURL, fromViewController: UIApplication.sharedApplication().delegate?.window??.rootViewController)
    }
    
    public static func login(loginProvider: LoginProvider, fromViewController: UIViewController?, callback: ExternalLoginCallback) {
        self.currentLoginProvider = loginProvider
        self.callback = callback
        
        presentSafariView(loginProvider.authorizationURL, fromViewController: fromViewController)
    }
    
    /// Deep link handler (iOS9)
    public static func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        safari?.dismissViewControllerAnimated(true, completion: nil)
        guard let callback = callback where url.scheme == currentLoginProvider?.urlScheme else {
            return false
        }
        currentLoginProvider?.linkHandler(url, callback: callback)
        currentLoginProvider = nil
        
        return true
    }
    
    /// Deep link handler (<iOS9)
    public static func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return self.application(application, openURL: url, options: [String: AnyObject]())
    }
    
    private static func presentSafariView(url: NSURL, fromViewController:UIViewController?) {
        if #available(iOS 9, *) {
            safari = SFSafariViewController(URL: url)
            if let controller = fromViewController {
                controller.presentViewController(safari!, animated: true, completion: nil)
            }
        } else {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}