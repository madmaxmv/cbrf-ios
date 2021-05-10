//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import CoreData

public protocol Managed: NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static var defaultPredicate: NSPredicate { get }
    var managedObjectContext: NSManagedObjectContext? { get }
}

extension Managed {

    public static var defaultSortDescriptors: [NSSortDescriptor] { return [] }
    public static var defaultPredicate: NSPredicate { return NSPredicate(value: true) }

    public static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = defaultPredicate
        return request
    }

    public static func sortedFetchRequest(with predicate: NSPredicate) -> NSFetchRequest<Self> {
        let request = sortedFetchRequest
        guard let existingPredicate = request.predicate else { fatalError("must have predicate") }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [existingPredicate, predicate])
        return request
    }

    public static func predicate(format: String, _ args: CVarArg...) -> NSPredicate {
        predicate(
            withVaList(args) { NSPredicate(format: format, arguments: $0) }
        )
    }

    public static func predicate(_ predicate: NSPredicate) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [defaultPredicate, predicate])
    }

}

extension Managed where Self: NSManagedObject {

    public static var entityName: String {
        return entity().name ?? String(describing: self)
    }

    @discardableResult
    public static func findOrCreate(in context: NSManagedObjectContext,
                                    matching predicate: NSPredicate,
                                    configure: (Self) -> Void) -> Self {
        guard let object = findOrFetch(in: context, matching: predicate) else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }
        return object
    }

    /// Метод удаляет объект из хранилища и создает новый.
    static func recreateObject(in context: NSManagedObjectContext,
                               where predicate: NSPredicate,
                               configure: (Self) -> Void) -> Self {
        if let object = findOrFetch(in: context, matching: predicate) {
            context.delete(object)
        }

        let newObject: Self = context.insertObject()
        configure(newObject)
        return newObject
    }

    public static func findOrFetch(in context: NSManagedObjectContext,
                                   matching predicate: NSPredicate) -> Self? {

        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                }.first
        }
        return object
    }

    public static func fetch(in context: NSManagedObjectContext,
                             configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        do {
            return try context.fetch(request)
        } catch {
            assertionFailure(error.localizedDescription)
            return []
        }
    }

    public static func count(in context: NSManagedObjectContext,
                             configure: (NSFetchRequest<Self>) -> Void = { _ in }) -> Int {
        let request = NSFetchRequest<Self>(entityName: entityName)
        configure(request)
        do {
            return try context.count(for: request)
        } catch {
            assertionFailure(error.localizedDescription)
            return 0
        }
    }

    public static func materializedObject(in context: NSManagedObjectContext,
                                          matching predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }

    public func delete() {
        managedObjectContext?.delete(self)
    }
}
