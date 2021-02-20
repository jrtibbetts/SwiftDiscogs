//  Copyright © 2017 Poikile Creations. All rights reserved.

import CoreData
import UIKit

/// A `FetchedResultsModel` for table views.
open class FetchedResultsTableModel: FetchedResultsModel,
                                     UITableViewDataSource,
                                     UITableViewDelegate,
                                     NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    /// `true` if the section index should be shown on the right edge of the
    /// table. This can be overridden to return dynamic values depending on the
    /// sorting criteria, etc.
    public var showSectionIndex: Bool = true

    /// The table view for which this model is a delegate and data source.
    let tableView: UITableView

    // MARK: - Initialization

    /// Construct a model for a specific table view.
    ///
    /// - parameter tableView: The `UITableView`. The model sets itself as the
    /// table view's delegate and data source.
    /// - parameter context: The managed object context.
    /// - parameter fetchedResultsController: The fetched results controller
    /// that will populate this model with data.
    public init(_ tableView: UITableView,
                context: NSManagedObjectContext,
                fetchedResultsController: NSFetchedResultsController<NSManagedObject>) {
        self.tableView = tableView
        super.init(context: context, fetchedResultsController: fetchedResultsController)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.fetchedResultsController.delegate = self
    }

    // MARK: - UITableViewDataSource & UITableViewDelegate

    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if showSectionIndex {
            return fetchedResultsController.sectionIndexTitles
        } else {
            return nil
        }
    }

    /// Get the number of sections from the fetched results controller.
    ///
    /// - parameter tableView: The table view.
    ///
    /// - returns: The number of sections.
    open func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }

    /// Get the number of sections from the fetched results controller.
    ///
    /// - parameter tableView: The table view.
    ///
    /// - returns: The number of rows in the specified section.
    open func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(in: section)
    }

    // This default implementation barfs up an assertion failure. You must
    // override it and *not* call `super.tableView(_, cellForRowAt:)`.
    open func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "tableCell")
    }

    open func tableView(_ tableView: UITableView,
                        canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    open func tableView(_ tableView: UITableView,
                        commit editingStyle: UITableViewCell.EditingStyle,
                        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteElement(at: indexPath)

            do {
                try saveContext()
                try fetchedResultsController.performFetch()
            } catch {
                // How can we handle the error?
            }
        }
    }

    open func tableView(_ tableView: UITableView,
                        sectionForSectionIndexTitle title: String,
                        at index: Int) -> Int {
        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }

    // MARK: - Fetched results controller

    /// Tell the table view that updates are about to begin.
    open func controllerWillChangeContent(_ controller: RequestResultFRC) {
        self.tableView.beginUpdates()
    }

    open func controller(_ controller: RequestResultFRC,
                         didChange sectionInfo: NSFetchedResultsSectionInfo,
                         atSectionIndex sectionIndex: Int,
                         for type: NSFetchedResultsChangeType) {
        let sectionIndices = IndexSet(integer: sectionIndex)

        switch type {
        case .insert:
            tableView.insertSections(sectionIndices, with: .fade)
        case .delete:
            tableView.deleteSections(sectionIndices, with: .fade)
        default:
            return
        }
    }

    open func controller(_ controller: RequestResultFRC,
                         didChange anObject: Any,
                         at indexPath: IndexPath?,
                         for type: NSFetchedResultsChangeType,
                         newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            break
        }
    }

    open func controllerDidChangeContent(_ controller: RequestResultFRC) {
        self.tableView.endUpdates()
    }

    // Implementing the above methods to update the table view in response to
    // individual changes may have performance implications if a large number of
    // changes are made simultaneously. If this proves to be an issue, you can
    // instead just implement controllerDidChangeContent: which notifies the
    // delegate that all section and object changes have been processed.

    open func controllerDidChangeContent(controller: RequestResultFRC) {
        // In the simplest, most efficient, case, reload the table view.
        self.tableView.reloadData()
    }

}
