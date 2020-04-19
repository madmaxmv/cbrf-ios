# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'CentralBank' do
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

  target 'CentralBankTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CentralBankUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
