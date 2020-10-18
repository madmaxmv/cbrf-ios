# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'RatesUp' do
  use_frameworks!

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxOptional'
  pod 'RxDataSources'
  pod 'RxViewController'

  # Network
  pod 'Moya', :subspecs => ['Core', 'RxSwift']

  # XML parsing
  pod 'SWXMLHash'

  target 'RatesUpTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RatesUpUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
end
