//
//  SearchResultsViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var sections: [SearchSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func update(with results: [SearchResult]) {
        let artist = results.filter({ $0.isArtist() })
        let albums = results.filter({ $0.isAlbum() })
        let tracks = results.filter({ $0.isTrack() })
        let playlists = results.filter({ $0.isPlaylist() })
        
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Artists", results: artist)
        ]
        
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        let subtitleCell: SearchResultSubtitleViewModel?
        
        switch result {
            case .artist(let artist):
                return SearchResultDefaultViewModel(
                    title: artist.name ?? "-",
                    imageURL: URL(
                        string: artist.images?.first?.url ?? ""
                    )
                ).setup(tableView: tableView, indexPath: indexPath)
            case .album(let album):
                subtitleCell = SearchResultSubtitleViewModel(
                    title: album.name ?? "-",
                    subtitle: album.artists?.first?.name ?? "-",
                    imageURL: URL(string: album.images?.first?.url ?? "")
                )
            case .track(let track):
                subtitleCell =  SearchResultSubtitleViewModel(
                    title: track.name ?? "-",
                    subtitle: track.artists?.first?.name ?? "-",
                    imageURL: URL(string: track.album?.images?.first?.url ?? "")
                )
            case .playlist(let playlist):
                subtitleCell =  SearchResultSubtitleViewModel(
                    title: playlist.name ?? "-",
                    subtitle: playlist.desc ?? "-",
                    imageURL: URL(string: playlist.images?.first?.url ?? "")
                )
        }
        
        return subtitleCell?.setup(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
}
