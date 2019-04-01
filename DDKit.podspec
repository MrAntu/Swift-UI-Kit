#
# Be sure to run `pod lib lint DDKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#


Pod::Spec.new do |s|
    s.name             = 'DDKit'
    s.version          = '1.0.3'
    s.summary          = 'private extensions for uikit in swift.'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
hk01 private uikit frameworks in swift.
DESC

s.homepage         = 'https://github.com/hk01-digital'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => './LICENSE' }
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Samuel Ying' => 'xiaoleiyin@hk01.com' }
s.source           = { :git => 'https://github.com/hk01-digital/dd01-ios-ui-kit.git', :tag => s.version.to_s, :submodules => true }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '9.0'
s.swift_version = '4.2'
s.default_subspec = 'Core'

s.subspec 'Core' do |ss|
    ss.source_files = 'DDKit/Core/*'
    # ss.resources    = 'Core/**/Assets/*.png'
    #ss.dependency 'DDKit/Chainable'

end

s.subspec 'Pop' do |ss|
    ss.source_files = 'DDKit/Pop/Classes/*'
    ss.resources    = 'DDKit/Pop/Assets/*'
end

s.subspec 'Refresh' do |ss|
    ss.source_files = 'DDKit/Refresh/*'
    ss.dependency 'MJRefresh'
end

s.subspec 'Hud' do |ss|
    ss.source_files = 'DDKit/Hud/*'
    ss.dependency 'MBProgressHUD'
    ss.dependency 'PKHUD'
    ss.dependency 'SnapKit'
end

s.subspec 'Request' do |ss|
    ss.source_files = 'DDKit/Request/*'
    ss.dependency 'Alamofire'
    ss.dependency 'PromiseKit'
    ss.dependency 'Cache'
end

s.subspec 'Codable' do |ss|
    ss.source_files = 'DDKit/Codable/*'
end

s.subspec 'WebJS' do |ss|
    ss.source_files = 'DDKit/WebJS/*'
end

s.subspec 'VideoPlayer' do |ss|
    ss.source_files = 'DDKit/VideoPlayer/Class/*'
    ss.resources    = 'DDKit/VideoPlayer/Asset/*'
    ss.dependency 'SnapKit'
    ss.dependency 'Alamofire'
end

s.subspec 'PhotoBrowser' do |ss|
    ss.source_files = 'DDKit/PhotoBrowser/Classes/*'
    ss.resources    = 'DDKit/PhotoBrowser/Assets/*'
    ss.dependency 'Kingfisher'
end

s.subspec 'CustomCamera' do |ss|
    ss.source_files = 'DDKit/CustomCamera/Classes/*'
    ss.resources    = 'DDKit/CustomCamera/Assets/*'
    ss.dependency 'SnapKit'
    ss.dependency 'DDKit/Hud'
end

s.subspec 'Scan' do |ss|
    ss.source_files = 'DDKit/Scan/Classes/*'
    ss.resources    = 'DDKit/Scan/Assets/*'
    ss.dependency 'SnapKit'
end

s.subspec 'Mediator' do |ss|
    ss.source_files = 'DDKit/Mediator/*'
end

s.subspec 'Router' do |ss|
    ss.source_files = 'DDKit/Router/*'
end

s.subspec 'MagicTextField' do |ss|
    ss.source_files = 'DDKit/MagicTextField/*'
end

s.subspec 'EmptyDataView' do |ss|
    ss.source_files = 'DDKit/EmptyDataView/Classes/*'
    ss.dependency 'SnapKit'
end

s.subspec 'DevelopConfig' do |ss|
    ss.source_files = 'DDKit/DevelopConfig/*'
    ss.dependency 'SnapKit'
    ss.dependency 'AFNetworking/Reachability'
end

s.subspec 'PageTabsController' do |ss|
    ss.source_files = 'DDKit/PageTabsController/*'
end

s.subspec 'Picker' do |ss|
    ss.source_files = 'DDKit/Picker/*'
    ss.dependency 'ActionSheetPicker-3.0'
end

s.subspec 'CityList' do |ss|
    ss.source_files = 'DDKit/CityList/Classes/*'
    ss.resources    = 'DDKit/CityList/Asset/*'
end

s.subspec 'NumberSelect' do |ss|
    ss.source_files = 'DDKit/NumberSelect/Classes/*'
    ss.resources    = 'DDKit/NumberSelect/Asset/*'
end

s.subspec 'Chainable' do |ss|
    ss.source_files = 'DDKit/Chainable/*'
    #ss.resources    = 'DDKit/NumberSelect/Asset/*'
    ss.dependency 'RxSwift'
    ss.dependency 'RxCocoa'
    ss.dependency 'SnapKit'
end

s.subspec 'Debug' do |ss|
    ss.source_files = 'DDKit/Debug/*'
end


# s.resource_bundles = {
#   'DDKit' => ['DDKit/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
