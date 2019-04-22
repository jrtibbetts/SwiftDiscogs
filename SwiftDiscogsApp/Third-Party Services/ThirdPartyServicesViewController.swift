//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import UIKit

final class ThirdPartyServicesViewController: UITableViewController{

    // MARK: - Properties

    lazy var discogsService = DiscogsService()

    lazy var iTunesService = MediaLibraryService()

    var services: [ThirdPartyService] = []

    // MARK: - Actions

    @IBAction func signInOrOutTapped(sender: UIButton) {
        if let service = service(atPoint: sender.frame.center) as? AuthenticatedService {
            if service.isSignedIn {
                service.signOut(fromViewController: self)
            } else {
                service.signIn(fromViewController: self)
            }
        }
    }

    @IBAction func startOrStopImportingTapped(sender: UIButton) {
        if let service = service(atPoint: sender.frame.center) as? ImportableService {
            if service.isImporting {
                service.stopImportingData()
            } else {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    let context = appDelegate.medi8Container.viewContext
                    service.importData(intoContext: context)
                }
            }
        }
    }

    private func service<T: ThirdPartyService>(atPoint point: CGPoint) -> T? {
        return service(atPath: tableView.indexPathForRow(at: point)) as? T
    }

    private func service<T: ThirdPartyService>(atPath path: IndexPath?) -> T? {
        if let row = path?.row {
            return services[row] as? T
        } else {
            return nil
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        discogsService.authenticationDelegate = self
        discogsService.importDelegate = self
        iTunesService.importDelegate = self
        services = [discogsService, iTunesService]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return services.isEmpty ? 0 : 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let service = services[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "thirdPartyServiceCell",
                                                 for: indexPath)

        if let cell = cell as? ThirdPartyServiceCell {
            cell.service = service
        }

        return cell
    }

    // MARK: Other Functions

    private func reloadCell(forService service: ThirdPartyService?) {
        if let service = service,
            let row = services.firstIndex(of: service) {
            let path = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [path], with: .fade)
        }
    }

}

// MARK: - AuthenticatedServiceDelegate

extension ThirdPartyServicesViewController: AuthenticatedServiceDelegate {

    func didSignIn(toService service: AuthenticatedService?) {
        reloadCell(forService: service)
    }

    func didSignOut(fromService service: AuthenticatedService?) {
        reloadCell(forService: service)
    }

    func signIn(toService service: AuthenticatedService?,
                failedWithError error: Error?) {
        reloadCell(forService: service)
    }

    func willSignIn(toService service: AuthenticatedService?) {
        reloadCell(forService: service)
    }

    func willSignOut(fromService service: AuthenticatedService?) {
        reloadCell(forService: service)
    }

}

// MARK: - ImportableServiceDelegate

extension ThirdPartyServicesViewController: ImportableServiceDelegate {

    func didBeginImporting(fromService service: ImportableService?) {
        reloadCell(forService: service)
    }

    func didFinishImporting(fromService service: ImportableService?) {
        reloadCell(forService: service)
    }

    func update(importedItemCount: Int,
                totalCount: Int,
                forService service: ImportableService?) {
        reloadCell(forService: service)
    }

    func willBeginImporting(fromService service: ImportableService?) {
        reloadCell(forService: service)
    }

    func willFinishImporting(fromService service: ImportableService?) {
        reloadCell(forService: service)
    }

}
