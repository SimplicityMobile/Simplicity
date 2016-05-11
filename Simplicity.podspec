#
# Be sure to run `pod lib lint Simplicity.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "Simplicity"
s.version          = "0.1.0"
s.summary          = "A framework for authenticating with external providers on iOS"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
A framework for authenticating with external providers on iOS
DESC

s.homepage         = "https://github.com/SimplicityMobile/Simplicity"
# s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'Apache2'
s.author           = { "Edward Jiang" => "edward@stormpath.com" }
s.source           = { :git => "https://github.com/SimplicityMobile/Simplicity.git", :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '8.0'

s.source_files = 'Simplicity/**/*.swift'

# s.resource_bundles = {
#   'Simplicity' => ['Simplicity/Assets/*.png']
# }

s.public_header_files = 'Simplicity/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end