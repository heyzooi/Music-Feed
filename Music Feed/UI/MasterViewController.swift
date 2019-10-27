//
//  MasterViewController.swift
//  Music Feed
//
//  Created by Victor Hugo Carvalho Barros on 2019-10-26.
//  Copyright © 2019 HZ Apps. All rights reserved.
//

import UIKit
import AppleFeed
import Combine
import os

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController?
    var albums = [Album]() {
        didSet {
            tableView.reloadData()
        }
    }

    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            let navigationController = controllers[controllers.count - 1] as? UINavigationController
            detailViewController = navigationController?.topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? false
        super.viewWillAppear(animated)

        cancellable = AppleFeed.shared.fetchFeed(
            country: .unitedStates,
            mediaType: .appleMusic,
            feedType: .topAlbums
        ).sink(
            receiveCompletion: {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    os_log("%s", error.localizedDescription)
                }
            },
            receiveValue: { self.albums = $0.feed.results }
        )
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AlbumCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.prepareForReuse()
        cell.album = albums[indexPath.row]
        cell.reloadCallback = { tableView.reloadRows(at: [indexPath], with: .fade) }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            let detailViewController = self.detailViewController ?? DetailViewController()
            detailViewController.album = albums[indexPath.row]
        default:
            guard let split = splitViewController else {
                return
            }
            let detailViewController = self.detailViewController ?? DetailViewController()
            detailViewController.album = albums[indexPath.row]
            let controllers = split.viewControllers
            let navigationController = controllers[controllers.count - 1] as? UINavigationController
            navigationController?.popToRootViewController(animated: false)
            navigationController?.pushViewController(detailViewController, animated: true)
            self.detailViewController = detailViewController
        }
    }

}
