//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Nivelir

protocol AppServices {
    
    var ratesService: RatesService { get }
    var screenNavigator: ScreenNavigator { get }
}

class Services: AppServices {

    let groupIdentifier: String
    let screenNavigator: ScreenNavigator
    
    var storeDirectory: URL {
        let fileManager = FileManager.default
        return fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
            ?? fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    lazy var remote: RatesAPI = {
        CentralBankAPI(session: .shared)
    }()
    
    lazy var store: LocalStore? = {
        do {
            return try LocalStore(withStoreAtDirectory: storeDirectory)
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }()
    
    lazy var dateConverter: DateConverter = { .gregorian }()
    
    lazy var ratesService: RatesService = {
        RatesService(
            remote: remote,
            store: store,
            dateConverter: dateConverter
        )
    }()

    init(
        groupIdentifier: String,
        screenNavigator: ScreenNavigator
    ) {
        self.groupIdentifier = groupIdentifier
        self.screenNavigator = screenNavigator
    }
}
