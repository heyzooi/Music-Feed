//
//  DetailViewController.swift
//  Music Feed
//
//  Created by Victor Hugo Carvalho Barros on 2019-10-26.
//  Copyright © 2019 HZ Apps. All rights reserved.
//

import UIKit
import AppleFeed

private func configureViewForAutoLayout<View: UIView>(view: View = View(), decorate: ((View) -> Void)? = nil) -> View {
    view.translatesAutoresizingMaskIntoConstraints = false
    decorate?(view)
    return view
}

private func buildLabel() -> UILabel {
    return configureViewForAutoLayout { $0.numberOfLines = 0 }
}

class DetailViewController: UIViewController {

    var album: Album? {
        didSet {
            configureView()
        }
    }

    lazy var albumCell: AlbumCell = configureViewForAutoLayout(
        view: AlbumCell(style: .subtitle, reuseIdentifier: "Cell")
    )

    lazy var genreLabel: UILabel = buildLabel()

    lazy var releaseDateLabel: UILabel = buildLabel()

    lazy var copyrightLabel: UILabel = buildLabel()

    lazy var openItunesButton: UIButton = {
        return configureViewForAutoLayout(view: UIButton(type: .system)) {
            $0.setTitle("Open on iTunes", for: .normal)
            $0.backgroundColor = .systemBlue
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.gray, for: .highlighted)
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(self.openItunes(_:)), for: .touchUpInside)
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let views = [
            "albumCell": albumCell,
            "genreLabel": genreLabel,
            "releaseDateLabel": releaseDateLabel,
            "copyrightLabel": copyrightLabel,
            "openItunesButton": openItunesButton
        ]

        for subview in views.values {
            view.addSubview(subview)
        }

        addAlbumCellConstraints(views: views)
        addGenreLabelConstraints(views: views)
        addReleaseDateLabelConstraints(views: views)
        addCopyrightLabelConstraints(views: views)
        addOpenItunesButtonConstraints(views: views)

        configureView()
    }

    func addAlbumCellConstraints(views: [String: UIView]) {
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-[albumCell]",
                metrics: nil,
                views: views
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[albumCell]|",
                metrics: nil,
                views: views
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: albumCell,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 100
            )
        )
    }

    func addGenreLabelConstraints(views: [String: UIView]) {
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[albumCell]-[genreLabel]",
                metrics: nil,
                views: views
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[genreLabel]-|",
                metrics: nil,
                views: views
            )
        )
    }

    func addReleaseDateLabelConstraints(views: [String: UIView]) {
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[genreLabel]-[releaseDateLabel]",
                metrics: nil,
                views: views
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[releaseDateLabel]-|",
                metrics: nil,
                views: views
            )
        )
    }

    func addCopyrightLabelConstraints(views: [String: UIView]) {
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[releaseDateLabel]-[copyrightLabel]",
                metrics: nil,
                views: views
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[copyrightLabel]-|",
                metrics: nil,
                views: views
            )
        )
    }

    func addOpenItunesButtonConstraints(views: [String: UIView]) {
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[openItunesButton]-|",
                metrics: nil,
                views: views
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-20-[openItunesButton]-20-|",
                metrics: nil,
                views: views
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: openItunesButton,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 30
            )
        )
    }

    func configureView() {
        guard let album = album else {
            openItunesButton.isHidden = true
            return
        }
        openItunesButton.isHidden = false
        albumCell.album = album
        genreLabel.text = "Genres\n\(album.genres.map { $0.name }.joined(separator: "\n"))"

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        releaseDateLabel.text = "Release Date\n\(dateFormatter.string(from: album.releaseDate))"

        copyrightLabel.text = "Copyright\n\(album.copyright)"
    }

    @objc
    func openItunes(_ sender: Any) {
        guard let album = album, let url = URL(string: album.url) else {
            return
        }
        UIApplication.shared.open(url)
    }

}
