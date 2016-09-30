#
# Be sure to run `pod lib lint Simplicity.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
s.name             = "Simplicity"
s.version          = "2.0.1"
s.summary          = "A simple way to login with Facebook or Google on iOS"

s.description      = <<-DESC
Simplicity is a simple way to implement Facebook and Google login in your iOS and OS X apps.

Simplicity can be easily extended to support other external login providers, including OAuth2, OpenID, SAML, and other custom protocols, and will support more in the future. We always appreciate pull requests!

DESC

s.homepage         = "https://github.com/SimplicityMobile/Simplicity"
s.license          = 'Apache 2.0'
s.author           = { "Edward Jiang" => "edward@stormpath.com" }
s.source           = { :git => "https://github.com/SimplicityMobile/Simplicity.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/EdwardStarcraft'

s.ios.deployment_target = '8.0'

s.source_files = 'Simplicity/**/*.swift'

end
