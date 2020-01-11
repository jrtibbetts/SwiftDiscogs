//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreData
import Medi8
import OAuthSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    static let shared: AppDelegate = (UIApplication.shared.delegate) as! AppDelegate

    var window: UIWindow?

    // MARK: - AppDelegate

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveMedi8Context()
    }

    // MARK: - OAuth URL callback handling

    let callbackUrl = URL(string: "swiftdiscogsapp://oauth-callback/")!

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host! == callbackUrl.host! && url.scheme! == callbackUrl.scheme! {
            OAuthSwift.handle(url: url)

            return true
        } else {
            return false
        }
    }

    // MARK: - Core Data

    var medi8Context: NSManagedObjectContext {
        return medi8Container.viewContext
    }

    /// A persistent container whose model combines the Medi8 and Discogs
    /// models.
    lazy var medi8Container: NSPersistentContainer = {
        let medi8Bundle = Bundle(for: Medi8.self)
        let discogsBundle = Bundle(for: type(of: self))
        let model = NSManagedObjectModel.mergedModel(from: [medi8Bundle, discogsBundle])!
        let container = NSPersistentContainer(name: "Medi8", managedObjectModel: model)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error
                // appropriately.
                // fatalError() causes the application to generate a crash log
                // and terminate. You should not use this function in a
                // shipping application, although it may be useful during
                // development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or
                 * disallows writing.
                 * The persistent store is not accessible, due to permissions
                 * or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 * Check the error message to determine what the actual problem
                 * was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    func saveMedi8Context () {
        let context = medi8Container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error
                // appropriately.
                // fatalError() causes the application to generate a crash log
                // and terminate. You should not use this function in a
                // shipping application, although it may be useful during
                // development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
