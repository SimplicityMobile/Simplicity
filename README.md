# Simplicity

[![Version](https://img.shields.io/cocoapods/v/Simplicity.svg?style=flat)](http://cocoapods.org/pods/Simplicity)
[![License](https://img.shields.io/cocoapods/l/Simplicity.svg?style=flat)](http://cocoapods.org/pods/Simplicity)
[![Platform](https://img.shields.io/cocoapods/p/Simplicity.svg?style=flat)](http://cocoapods.org/pods/Simplicity)

Requires XCode 7.3+ / Swift 2.3+

Simplicity is a framework that allows for easy login via external providers on iOS. 

Simplicity supports Facebook and Google Login, and can be easily extended to support other external login providers, including OAuth, OpenID, SAML, and other custom protocols. 

## Why use Simplicity?

Facebook and Google's SDKs are heavyweight, and take time to set up and use. Simplicity makes it easier to implement login across multiple providers without adding lots of code to your app. 

Logging in with Simplicity is as easy as:

```Swift
Simplicity.login(Facebook()) { (authToken, error) in
  // Handle access token here
}
```

## Work In Progress

Simplicity is a work in progress, and is being written by [Edward Jiang](https://twitter.com/edwardstarcraft). Work is sponsored by [Stormpath](https://stormpath.com/), a service provider for authentication and authorization. 

This notice will be removed when you can install Simplicity from Cocoapods. While you wait, please star this project! 

## Usage

To install Simplicity, just use [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "Simplicity"
```

### Getting Started

To get started with Simplicity, find the login provider you want to use and read the documentation for how to set it up. Each login provider has different configuration options depending on its capabilities. However, most login providers will autoconfigure based on your Info.plist file so you'll have to do minimal setup. 

### Add the link handlers to the AppDelegate

We need to add the link handlers to the AppDelegate so Simplicity can handle responses from the login providers and their access tokens. Add to `AppDelegate.swift`:

```Swift
import Simplicity

func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
  return Simplicity.application(app, openURL: url, options: options)
}

func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
  return Simplicity.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
}
```

### Perform the login!

```Swift
// Login with an external provider.
Simplicity.login(Facebook()) { (authToken, error) in
  // Handle access token here
}
```

## Stormpath

Development of Simplicity is supported by [Stormpath](https://stormpath.com), an API service for authentication and user management. If you're building a backend API for your app, and don't want to manage authentication, consider using Stormpath to help you implement a secure REST API. Read our tutorial on how to [build a REST API for your mobile apps using Node.js](https://stormpath.com/blog/tutorial-build-rest-api-mobile-apps-using-node-js).

## Twitter, LinkedIn, and GitHub

We can't implement Twitter, GitHub, LinkedIn, Slack, or other login types because we can't do authorization_code grants without a client secret. Client secrets are fundamentally insecure on mobile clients, so we need to create a companion server to help with the authentication request.

If this is something you'd like to see, please +1 or follow this [GitHub Issue to create a companion server](https://github.com/SimplicityMobile/Simplicity/issues/1) so I know that there's demand for this. 

## Other External Login Providers

Want another external login provider implemented? Please [open a GitHub issue](https://github.com/SimplicityMobile/Simplicity/issues) so I know it's in demand, or consider contributing to this project!

## Contributing

Please send a pull request with your new LoginProvider implemented. Please try to have the LoginProvider autoconfigure, so it's less work for the end user. 

## License

Simplicity is available under the Apache 2.0 license. See the LICENSE file for more info.
