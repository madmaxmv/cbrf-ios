//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

protocol AppServices {
    
    var ratesService: RatesService { get }
    
    init(groupIdentifier: String)
}

class Services: AppServices {

    let groupIdentifier: String
    
    var storeDirectory: URL {
        let fileManager = FileManager.default
        return fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
            ?? fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    lazy var remote: CentralBankService = {
        return APIService()
    }()
    
    lazy var store: LocalStore? = {
        do {
            return try LocalStore(withStoreAtDirectory: storeDirectory)
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }()
    
    lazy var dateConverter: DateConverter = {
        return .gregorian
    }()
    
    lazy var ratesService: RatesService = {
        return RatesService(remote: remote,
                            store: store,
                            dateConverter: dateConverter)
    }()

    required init(groupIdentifier: String) {
        self.groupIdentifier = groupIdentifier
    }
}
