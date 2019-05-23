//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import Foundation

public class DiscogsContainer: NSPersistentContainer {

    // MARK: - Core Data

    static var instance = DiscogsContainer()

    var context: NSManagedObjectContext {
        return viewContext
    }

    // MARK: - Initialization

    public init() {
        let bundle = Bundle(for: DiscogsContainer.self)
        let modelURL = bundle.url(forResource: "DiscogsCollection", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        super.init(name: "DiscogsCollection", managedObjectModel: model)

        loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: - Core Data Saving support

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Entities

}
