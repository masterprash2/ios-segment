#
# Be sure to run `pod lib lint PowerAdapter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PowerAdapter'
  s.version          = '0.1.8'
  s.summary          = 'PowerAdapter.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/masterprash2/ios-segment'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'masterprash2' => 'prashant.rathore' }
  s.source           = { :git => 'https://github.com/masterprash2/ios-segment.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PowerAdapter/Classes/**/*'
  s.dependency 'RxSwift', '5.0.1'
  s.dependency 'RxCocoa', '5.0.1'
  s.dependency 'RxSwiftExt', '5.2.0'
  s.dependency 'DeepDiff'
  
  
  # s.resource_bundles = {
  #   'PowerAdapter' => ['PowerAdapter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
