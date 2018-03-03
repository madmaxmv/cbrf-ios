//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import CoreData

class Currency: NSManagedObject {
    @NSManaged var isIncluded: Bool
    @NSManaged var order: Int32
    @NSManaged var currencyId: String
    @NSManaged var currencyCode: String
    @NSManaged var characterCode: String
    @NSManaged var name: String
    @NSManaged var nominal: Int64
    
    @NSManaged var rates: [Rate]
    
}

extension Currency: Managed { }

extension Currency {
    static func predicate(byId currencyId: String) -> NSPredicate {
        return NSPredicate(format: "currencyId = %@", currencyId)
    }
}
