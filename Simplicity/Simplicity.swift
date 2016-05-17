//
//  Simplicity.swift
//  Simplicity
//
//  Created by Edward Jiang on 5/10/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit
import SafariServices

public typealias ExternalLoginCallback = (accessToken: String?, error: NSError?) -> Void

public class Simplicity: NSObject {
    static var currentLoginProvider: LoginProvider?
    static var callback: ExternalLoginCallback?
    static var safari: UIViewController?
    
    public static func login(loginProvider: LoginProvider, callback: ExternalLoginCallback? = nil) {
        self.currentLoginProvider = loginProvider
        self.callback = callback
        
        presentSafariView(loginProvider.authorizationURL)
    }
    
    /// Deep link handler (iOS9)
    public static func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        safari?.dismissViewControllerAnimated(true, completion: nil)
        if url.scheme != currentLoginProvider?.urlScheme {
            return false
        }
        currentLoginProvider?.linkHandler(url, callback: callback)
        
        return true
    }
    
    /// Deep link handler (<iOS9)
    public static func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return self.application(application, openURL: url, options: [String: AnyObject]())
    }
    
    static func presentSafariView(url: NSURL) {
        if #available(iOS 9, *) {
            safari = SFSafariViewController(URL: url)
            UIApplication.sharedApplication().delegate?.window??.rootViewController?.presentViewController(safari!, animated: true, completion: nil)
        } else {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}