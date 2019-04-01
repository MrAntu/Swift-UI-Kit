# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!
inhibit_all_warnings!

target 'Example' do
  use_frameworks!
  pod 'MJRefresh'
  pod 'DDKit', :path => '.'
  pod 'DDKit/Codable', :path => '.'
  pod 'DDKit/Hud', :path => '.'
  pod 'DDKit/Pop', :path => '.'
  pod 'DDKit/Refresh', :path => '.'
  pod 'DDKit/Request', :path => '.'
  pod 'DDKit/WebJS', :path => '.'
  pod 'DDKit/VideoPlayer', :path => '.'
  pod 'DDKit/PhotoBrowser', :path => '.'
  pod 'DDKit/CustomCamera', :path => '.'
  pod 'DDKit/Scan', :path => '.'
  pod 'DDKit/Mediator', :path => '.'
  pod 'DDKit/Router', :path => '.'
  pod 'DDKit/MagicTextField', :path => '.'
  pod 'DDKit/EmptyDataView', :path => '.'
  pod 'DDKit/DevelopConfig', :path => '.'
  pod 'DDKit/PageTabsController', :path => '.'
  pod 'DDKit/Picker', :path => '.'
  pod 'DDKit/CityList', :path => '.'
  pod 'DDKit/NumberSelect', :path => '.'
  pod 'DDKit/Chainable', :path => '.'

  pod 'CryptoSwift'
  pod 'SwiftLint'
end

target 'DDKit' do
  pod 'Alamofire'
  pod 'PromiseKit'
  pod 'PKHUD'
  pod 'SnapKit'
  pod 'Kingfisher'
  pod 'MBProgressHUD'
  pod 'MJRefresh'
  pod 'Cache'
  pod 'DDKit/CustomCamera', :path => '.'
  pod 'SwiftLint'
  pod 'AFNetworking/Reachability'
  pod 'ActionSheetPicker-3.0'
  pod 'RxSwift'
  pod 'RxCocoa'
end

post_install do |installer|
    system("git config --local core.hooksPath '.githooks'")
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGN_STYLE'] = "Automatic"
        end
    end
end
