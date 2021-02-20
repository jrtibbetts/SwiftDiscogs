//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import Foundation

public extension NSManagedObject {

    class func all<T: NSManagedObject>(inContext context: NSManagedObjectContext,
                                       sortedBy sortCriteria: [NSSortDescriptor] = []) throws -> [T] {
        return try context.fetch(fetchRequestForAll(sortedBy: sortCriteria))
    }
//
//    class func deleteAll(fromCoordinator coordinator: NSPersistentStoreCoordinator,
//                         context: NSManagedObjectContext) throws {
//        let allRequest = Self.fetchRequestForAll()
//        // swiftlint:disable force_cast
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: allRequest as! NSFetchRequest<NSFetchRequestResult>)
//        // swiftlint:enable force_cast
//
//        let error = try coordinator.execute(deleteRequest, with: context) as? Error
//
//        print("Failed to delete: \(error?.localizedDescription)")
//    }

    class func fetchRequest<T: NSManagedObject>(sortDescriptors sortCriteria: [NSSortDescriptor],
                                                predicate: NSPredicate? = NSPredicate(value: true)) -> NSFetchRequest<T> {
        let entityName = String(describing: self)
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = sortCriteria
        request.predicate = predicate

        return request
    }

    class func fetchRequestForAll<T: NSManagedObject>(
        sortedBy sortCriteria: [NSSortDescriptor] = []) -> NSFetchRequest<T> {
        return fetchRequest(sortDescriptors: sortCriteria)
    }

}
