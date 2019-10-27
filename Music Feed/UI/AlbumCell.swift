//
//  AlbumCell.swift
//  Music Feed
//
//  Created by Victor Hugo Carvalho Barros on 2019-10-26.
//  Copyright © 2019 HZ Apps. All rights reserved.
//

import UIKit
import AppleFeed
import Combine
import os

class AlbumCell: UITableViewCell {

    var cancellable: AnyCancellable?

    var reloadCallback: (() -> Void)?

    var album: Album? {
        didSet {
            guard let album = album else {
                return
            }
            if let url = URL(string: album.artworkUrl100) {
                if let data = Cache.shared.images.object(forKey: url as NSURL) {
                    imageView?.image = Image(data: data as Data)
                } else {
                    cancellable = AppleFeed.shared.fetchImage(url: url)
                        .sink(
                            receiveCompletion: {
                                switch $0 {
                                case .finished:
                                    break
                                case .failure(let error):
                                    os_log("%s", error.localizedDescription)
                                }
                            },
                            receiveValue: {
                                self.imageView?.image = $0
                                if let data = $0.pngData() {
                                    Cache.shared.images.setObject(data as NSData, forKey: url as NSURL)
                                }
                                self.reloadCallback?()
                            }
                    )
                }
            }
            textLabel?.text = album.artistName
            detailTextLabel?.text = album.name
        }
    }

    override func prepareForReuse() {
        cancellable?.cancel()
        reloadCallback = nil
        imageView?.image = nil
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }

}
