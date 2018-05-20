# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'CentralBank' do
  use_frameworks!

  pod 'ReSwift'

  # Rx
  pod 'RxSwift',       '~> 4.0'
  pod 'RxCocoa',       '~> 4.0'
  pod 'RxOptional',    '~> 3.3'
  pod 'RxDataSources', '~> 3.0'
  pod 'Action',        '~> 3.1'
  pod 'RxFeedback',    '~> 1.0'
  pod 'RxViewController'

  # Network
  pod 'Moya', '~> 10.0', :subspecs => ['Core', 'RxSwift']

  # XML parsing
  pod 'SWXMLHash', '~> 4.0.0'

  target 'CentralBankTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CentralBankUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
