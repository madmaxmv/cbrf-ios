//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import CoreData

class Rate: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged var value: Double
    
    @NSManaged var currency: Currency
}

extension Rate: Managed { }

extension Rate {
    static func predicate(currency: Currency, on date: Date) -> NSPredicate {
        let predicates = [
            NSPredicate(format: "currency = %@", currency),
            NSPredicate(format: "date = %@", date as CVarArg)
        ]
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}
