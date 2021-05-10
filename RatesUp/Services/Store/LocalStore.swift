//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import CoreData

class LocalStore {

    private var coordinator: NSPersistentStoreCoordinator

    init(withStoreAtDirectory storeURL: URL) throws {
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: LocalStore.managedObjectModel)

        let storeOptions: [AnyHashable: Any] = [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true
        ]

        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                           configurationName: nil,
                                           at: storeURL.appendingPathComponent(Name.store),
                                           options: storeOptions)
    }

    lazy var readContext: NSManagedObjectContext = {
        let coordinator = self.coordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return managedObjectContext
    }()

    lazy var writeContext: NSManagedObjectContext = {
        let coordinator = self.coordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()

    private enum Name {
        static let model = "RatesStore"
        static let store = "RatesStore.sqlite"
    }

    /// The managed object model for the application. This property is not optional.
    /// It is a fatal error for the application not to be able to find and load its model.
    private static var managedObjectModel: NSManagedObjectModel {
        let modelURL = Bundle(for: self).url(forResource: Name.model, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }

    /// Очистка файлов Core Data Store.
    private static func destroyPersistentStore(atDirectory url: URL) throws {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        try coordinator.destroyPersistentStore(at: url.appendingPathComponent(Name.store),
                                               ofType: NSSQLiteStoreType, options: nil)
    }
}
