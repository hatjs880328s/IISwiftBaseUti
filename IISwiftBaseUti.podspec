#
# Be sure to run `pod lib lint IISwiftBaseUti.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IISwiftBaseUti'
  s.version          = '1.1.0'
  s.summary          = 'IISwift基础服务'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
     包含：
     1.多种破次方排序方法（heapsort/mergesort)
     2.自定义轻量级队列（IIQueue)
     3.GCD二次封装（GCGUtils）
     4.把名单模块IIWhiteModule
     5.oc之Uitlity集成
     6.Swift_core_extension
                       DESC

  s.homepage         = 'https://github.com/hatjs880328s/IISwiftBaseUti'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hatjs880328s' => 'shanwzh@inspur.com' }
  s.source           = { :git => 'https://github.com/hatjs880328s/IISwiftBaseUti.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  # IIOCUtility.framework/Headers/MJRefresh.h
  # s.preserve_paths = 'IIOCUtility/Support Files/module.modulemap'

  # s.source_files = 'IISwiftBaseUti/Classes/**/*'

  s.subspec 'IIBaseUti' do |ss|
      ss.source_files = 'IISwiftBaseUti/Classes/IIBaseUti/*.*'
  end

  s.subspec 'IICoreExtension' do |ss|
      ss.source_files = 'IISwiftBaseUti/Classes/IICoreExtension/*.*'
  end

  s.swift_version = '4.2'
  
  # s.resource_bundles = {
  #   'IISwiftBaseUti' => ['IISwiftBaseUti/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'III18N'
  s.dependency 'SnapKit', '~> 4.2.0'


end
