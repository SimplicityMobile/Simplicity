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
public typealias ExternalLoginCallback = (String?, NSError?) -> Void

/**
 Simplicity is a framework for authenticating with external providers on iOS.
 */
public final class Simplicity {
    private static var currentLoginProvider: LoginProvider?
    private static var callback: ExternalLoginCallback?
    private static var safari: UIViewController?
    @available(iOS 11.0, *)
    private static var authSession: SFAuthenticationSession?
    
    /**
     Begin the login flow by redirecting to the LoginProvider's website.
     
     - parameters:
     - loginProvider: The login provider object configured to be used.
     - callback: A callback with the access token, or a SimplicityError.
     */
    public static func login(_ loginProvider: LoginProvider, callback: @escaping ExternalLoginCallback) {
        self.currentLoginProvider = loginProvider
        self.callback = callback
        
        if #available(iOS 11, *) {
            if self.presentAuthentificationSession(url: loginProvider.authorizationURL, callbackURL: loginProvider.urlScheme) == false {
                self.presentSafariView(loginProvider.authorizationURL)
            }
        } else {
            self.presentSafariView(loginProvider.authorizationURL)
        }
    }
    
    /// Deep link handler (iOS9)
    public static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if let safari = self.safari {
            safari.dismiss(animated: true, completion: nil)
            self.safari = nil
        }
        if #available(iOS 11.0, *) {
            if let auth = self.authSession {
                auth.cancel()
                self.authSession = nil
            }
        }
        guard let callback = self.callback,
            let currentLoginProvider = self.currentLoginProvider,
            url.scheme == currentLoginProvider.urlScheme
            else { return false }
        currentLoginProvider.linkHandler(url, callback: callback)
        self.currentLoginProvider = nil
        
        return true
    }
    
    /// Deep link handler (<iOS9)
    public static func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return self.application(application, open: url, options: [UIApplication.OpenURLOptionsKey: Any]())
    }
    
    private static func presentSafariView(_ url: URL) {
        if #available(iOS 9, *) {
            safari = SFSafariViewController(url: url)
            var topController = UIApplication.shared.keyWindow?.rootViewController
            while let vc = topController?.presentedViewController {
                topController = vc
            }
            topController?.present(safari!, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @available(iOS 11.0, *)
    private static func presentAuthentificationSession(url: URL, callbackURL: String) -> Bool {
        
        let session = SFAuthenticationSession(url: url, callbackURLScheme: nil) { (url, error) in
            self.authSession = nil
            if let url = url {
                _ = self.application(UIApplication.shared, open: url, options: [:])
            }
        }
        self.authSession = session
        return session.start()
        
    }
}
