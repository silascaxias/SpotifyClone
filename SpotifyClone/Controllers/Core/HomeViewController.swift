//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var newAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    private var collectionView: UICollectionView = UICollectionView (
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.tintColor = .label
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var sections = [BrowseSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        
        setupView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        view.addSubview(indicatorView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponses?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        APIManager.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
                case .success(let result): newReleases = result;
                case .failure(let error): print(error.localizedDescription);
            }
        }
        
        APIManager.shared.getFeaturedPlaylists { result in
            defer {
                group.leave()
            }
            switch result {
                case .success(let result): featuredPlaylist = result;
                case .failure(let error): print(error.localizedDescription);
            }
        }
        
        APIManager.shared.getRecommendedGenres { result in
            switch result {
                case .success(let result):
                    let genres = result.genres
                    var seeds = Set<String>()
                    while seeds.count < 5 {
                        if let random = genres.randomElement() {
                            seeds.insert(random)
                        }
                    }
                    
                    APIManager.shared.getRecommendations(genres: seeds) { _result in
                        defer {
                            group.leave()
                        }
                        switch _result {
                            case .success( let result): recommendations = result;
                            case .failure(let error): print(error.localizedDescription);
                        }
                    }
                case .failure(let error): print(error.localizedDescription);
            }
        }
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums?.items,
                  let playlists = featuredPlaylist?.playlists?.items,
                  let tracks = recommendations?.tracks else {
                return
            }
            
            self.setupModels(newAlbums: newAlbums, playlists: playlists, tracks: tracks)
        }
    }
    
    private func setupModels(
        newAlbums: [Album],
        playlists: [Playlist],
        tracks: [AudioTrack]
    ) {
        
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        
        sections.append(.newReleases(newAlbums.compactMap({
            return NewReleasesCellViewModell(
                name: $0.name ?? "-",
                imageURL: URL(string: $0.images?.first?.url ?? ""),
                numberOfTracks: $0.totalTracks ?? 0,
                artistName: $0.artists?.first?.name ?? "-"
            )
        })))
        
        sections.append(.featuredPlaylist(playlists.compactMap({
            return FeaturedPlaylistCellViewModel(
                name: $0.name ?? "-",
                imageURL:URL(string: $0.images?.first?.url ?? ""),
                creatorName: $0.owner?.displayName ?? "-")
        })))
        
        sections.append(.recommendedTracks(tracks.compactMap({
            return RecommendedTrackCellViewModel(
                name: $0.name ?? "-",
                artistName: $0.artists?.first?.name ?? "-",
                imageURL: URL(string: $0.album?.images?.first?.url ?? ""))
        })))
        
        collectionView.reloadData()
    }
    
    @objc func didTapSettings() {
        let settingsViewController = SettingsViewController()
        settingsViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
}

// MARK: - CollectionView

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
            case .newReleases(let viewModels): return viewModels.count
            case .featuredPlaylist(let viewModels): return viewModels.count
            case .recommendedTracks(let viewModels): return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
            case .newReleases(let viewModel):
                return viewModel[indexPath.row].setup(collectionView: collectionView, cellForItemAt: indexPath)
            case .featuredPlaylist(let viewModel):
                return viewModel[indexPath.row].setup(collectionView: collectionView, cellForItemAt: indexPath)
            case .recommendedTracks(let viewModel):
                return viewModel[indexPath.row].setup(collectionView: collectionView, cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        var viewController = UIViewController()
        
        let type = sections[indexPath.section]
        switch type {
            case .newReleases(_):
                let album = newAlbums[indexPath.row]
                viewController = AlbumViewController(album: album)
            case .featuredPlaylist(_):
                let playlist = playlists[indexPath.row]
                viewController = PlaylistViewController(playlist: playlist)
            case .recommendedTracks(_):
                let track = tracks[indexPath.row]
                return PlaybackPresenter.startPlayback(
                    from: self,
                    track: track
                )
        }
        
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return TitleHeaderCollectionReusableView().setup(
            title: sections[indexPath.section].title,
            collectionView: collectionView,
            kind: kind,
            cellForItemAt: indexPath
        )
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50.0)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        
        switch section {
            case 0:
                let item = NSCollectionLayoutItem (
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(390)),
                    subitem: item,
                    count: 3
                )
                
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.9),
                        heightDimension: .absolute(390)),
                    subitem: verticalGroup,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = supplementaryViews
                return section
            case 1:
                let item = NSCollectionLayoutItem (
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(200)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(400)
                    ),
                    subitem: item,
                    count: 2
                )
                
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(200),
                        heightDimension: .absolute(400)
                    ),
                    subitem: verticalGroup,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = supplementaryViews
                return section
            case 2:
                let item = NSCollectionLayoutItem (
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(80)),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = supplementaryViews
                return section
            default:
                let item = NSCollectionLayoutItem (
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(390)),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = supplementaryViews
                return section
        }
    }

}

enum BrowseSectionType {
    case newReleases([NewReleasesCellViewModell])
    case featuredPlaylist([FeaturedPlaylistCellViewModel])
    case recommendedTracks([RecommendedTrackCellViewModel])
    
    var title: String {
        switch self {
            case .newReleases: return "New Released Albums"
            case .featuredPlaylist: return "Featured Playlist"
            case .recommendedTracks: return "Recommended"
        }
    }
}
