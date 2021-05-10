//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    public func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        return obj
    }

    @discardableResult
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            debugPrint(error.localizedDescription)
            return false
        }
    }

    public func performSaveOrRollback() {
        perform {
            self.saveOrRollback()
        }
    }

    public func performChanges(block: @escaping (NSManagedObjectContext) -> Void) {
        perform { [weak self] in
            if let `self` = self {
                block(self)
                self.saveOrRollback()
            }
        }
    }

    public func perform(_ block: @escaping (NSManagedObjectContext) -> Void) {
        perform { [weak self] in
            if let `self` = self {
                block(self)
            }
        }
    }

    public func performAndWait(_ block: @escaping (NSManagedObjectContext) -> Void) {
        performAndWait { [weak self] in
            if let `self` = self {
                block(self)
            }
        }
    }
}
