#
# Be sure to run `pod lib lint SDWebImageSVGNativeCoder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SDWebImageSVGNativeCoder'
  s.version          = '0.1.1'
  s.summary          = 'SVG-Native vector image coder plugin for SDWebImage.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This SDWebImage coder plugin, use adobe svg-native-viewer library to provide SVG-Native (subset of SVG 1.1) vector image support
                       DESC

  s.homepage         = 'https://github.com/SDWebImage/SDWebImageSVGNativeCoder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dreampiggy' => 'lizhuoli1126@126.com' }
  s.source           = { :git => 'https://github.com/SDWebImage/SDWebImageSVGNativeCoder.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'SDWebImageSVGNativeCoder/Classes/**/*'
  s.pod_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) BOOST_VARIANT_DETAIL_NO_SUBSTITUTE=1',
    'HEADER_SEARCH_PATHS' => '$(inherited) ${PODS_ROOT}/svgnative/svg-native-viewer/svgnative/include ${PODS_ROOT}/svgnative/svg-native-viewer/third_party/boost_variant_property_tree'
  }

  s.dependency 'SDWebImage', '~> 5.10'
  s.dependency 'svgnative', '>= 0.1.0-beta'
  s.libraries 'c++', 'xml2'
end
