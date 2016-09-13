# Simplicity

[![Version](https://img.shields.io/cocoapods/v/Simplicity.svg?style=flat)](http://cocoapods.org/pods/Simplicity)
[![License](https://img.shields.io/cocoapods/l/Simplicity.svg?style=flat)](http://cocoapods.org/pods/Simplicity)
[![Platform](https://img.shields.io/cocoapods/p/Simplicity.svg?style=flat)](http://cocoapods.org/pods/Simplicity) [![codebeat badge](https://codebeat.co/badges/be32bb87-36e8-47e3-9324-5eae153a4d6d)](https://codebeat.co/projects/github-com-simplicitymobile-simplicity)
[![Slack Status](https://talkstormpath.shipit.xyz/badge.svg)](https://talkstormpath.shipit.xyz)

Simplicity is a simple way to implement Facebook and Google login in your iOS apps. 

Simplicity can be easily extended to support other external login providers, including OAuth2, OpenID, SAML, and other custom protocols, and will support more in the future. We always appreciate pull requests!

## Why use Simplicity?

Facebook and Google's SDKs are heavyweight, and take time to set up and use. You can use Simplicity and only have to manage one SDK for logging in with an external provider in your app. Simplicity adds just 200KB to your app's binary, compared to 5.4MB when using the Facebook & Google SDKs. 

Simplicity is also extensible, and already supports other login providers, like VKontakte (the largest European social network) and generic OAuth providers. 

Logging in with Simplicity is as easy as:

```Swift
Simplicity.login(Facebook()) { (accessToken, error) in
  // Handle access token here
}
```

## Stormpath

Simplicity is maintained by [Stormpath](https://stormpath.com), an API service for authentication, authorization, and user management. If you're building a backend API for your app, consider using Stormpath to help you implement a secure REST API. Read our tutorial on how to [build a REST API for your mobile apps using Node.js](https://stormpath.com/blog/tutorial-build-rest-api-mobile-apps-using-node-js).

## Installation

Requires XCode 8+ / Swift 3+

To install Simplicity, we use [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'Simplicity'
```

**Carthage**

To use Simplicity with [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```ogdl
github "SimplicityMobile/Simplicity"
```

**Swift 2**

Older versions of Simplicity support Swift 2.3 (Xcode 8) or Swift 2.2 (Xcode 7).

* Swift 2.3 support is on branch [`swift2.3`](https://github.com/SimplicityMobile/Simplicity/tree/swift2.3)
* Swift 2.2 support is on version [`1.x`](https://github.com/SimplicityMobile/Simplicity/tree/1.0.2)

### Add the link handlers to the AppDelegate

When a user finishes their log in flow, Facebook or Google will redirect back into the app. Simplicity will listen for the access token or error. You need to add the following lines of code to `AppDelegate.swift`:

```Swift
import Simplicity

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
    return Simplicity.application(app, open: url, options: options)
}

func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return Simplicity.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
}
```

# Usage

Simplicity is very flexible and supports a number of configuration options for your login providers. To view, please see the [full API docs on CocoaDocs](http://cocoadocs.org/docsets/Simplicity/). 

## Using Facebook Login
 
To get started, you first need to [register an application](https://developers.facebook.com/?advanced_app_create=true) with Facebook. After registering your app, go into your app dashboard's settings page. Click "Add Platform", and fill in your Bundle ID, and turn "Single Sign On" on.

Finally, open up your App's Xcode project and go to the project's info tab. Under "URL Types", add a new entry, and in the URL schemes form field, type in `fb[APP_ID_HERE]`, replacing `[APP_ID_HERE]` with your Facebook App ID.

Then, you can initiate the login screen by calling:

```Swift
Simplicity.login(Facebook()) { (accessToken, error) in
  // Handle access token here
}
```

By request, you can also call `.login` on any `LoginProvider`: 

```Swift
Facebook().login { (accessToken, error) in
  // Handle access token here
}
```

## Using Google Login

To get started, you first need to [register an application](https://console.developers.google.com/project) with Google. Click "Enable and Manage APIs", and then the [credentials tab](https://console.developers.google.com/apis/credentials). Create an OAuth Client ID for "iOS". 

Next, open up your App's Xcode project and go to the project's info tab. Under "URL Types", add a new entry, and in the URL schemes form field, type in your Google iOS Client's `iOS URL scheme` from the Google Developer Console.

Then, you can initiate the login screen by calling:

```Swift
Simplicity.login(Google()) { (accessToken, error) in
  // Handle access token here
}
```

## Using VKontakte Login

To get started, you first need to [create an application](https://vk.com/dev/) with VKontakte. 
After registering your app, go into your client settings page.
Set App Bundle ID for iOS to your App Bundle in Xcode -> Target -> Bundle Identifier (e.g. com.developer.applicationName)

Finally, open up your App's Xcode project and go to the project's
info tab. Under "URL Types", add a new entry, and in the URL schemes form
field, type in `vk[CLIENT_ID_HERE]`. Then, you can initiate the login
screen by calling:

```
Simplicity.login(VKontakte()) { (accessToken, error) in
  // Handle access token here
}
```

## Generic OAuth Provider

Simplicity supports any OAuth provider that implements the Implicit grant type. 

```Swift
let provider = OAuth2(clientId: clientId, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectEndpoint, grantType: .Implicit)

Simplicity.login(provider) { (accessToken, error) in
  // Handle access token here
}
```

## Requesting Scopes for OAuth Providers

If you need custom scopes, you can modify the Facebook or Google object to get them. 

```Swift
let facebook = Facebook()
facebook.scopes = ["public_profile", "email", "user_friends"]

Simplicity.login(facebook) { (accessToken, error) in
  // Handle access token here
}
```

## Twitter, LinkedIn, and GitHub

We can't implement Twitter, GitHub, LinkedIn, Slack, or other login types because we can't do authorization_code grants without a client secret. Client secrets are fundamentally insecure on mobile clients, so we need to create a companion server to help with the authentication request.

If this is something you'd like to see, please +1 or follow this [GitHub Issue to create a companion server](https://github.com/SimplicityMobile/Simplicity/issues/1) so I know that there's demand for this. 

## Other External Login Providers

Want another external login provider implemented? Please [open a GitHub issue](https://github.com/SimplicityMobile/Simplicity/issues) so I know it's in demand, or consider contributing to this project!

## Contributing

Please send a pull request with your new LoginProvider implemented. LoginProviders should try to autoconfigure where possible. 

## License

Simplicity is available under the Apache 2.0 license. See the LICENSE file for more info.
