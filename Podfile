# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'RatesUp' do
  use_frameworks!

  pod 'ReSwift'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxOptional'
  pod 'RxDataSources'
  pod 'Action'
  pod 'RxFeedback'
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
