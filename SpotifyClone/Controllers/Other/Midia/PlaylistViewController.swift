//
//  PlaylistViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem (
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 2, bottom: 1.0, trailing: 2)
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(60)),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalWidth(1.0)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                ]
                return section
            })
        )
        return collectionView
    }()

    private let playlist: Playlist
    
    private var viewModels = [RecommendedTrackCellViewModel]()
    
    private var tracks = [AudioTrack]()
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func setupView() {
        title = playlist.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
    }
    
    @objc func didTapShare() {
        guard let url = URL(string: playlist.externalUrls?.spotify ?? "") else {
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityViewController, animated: true)
    }
    
    private func fetchData() {
        APIManager.shared.getPlaylistDetails(for: playlist) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let result):
                        self?.tracks = result.tracks?.items?.compactMap({ $0.track }) ?? []
                        self?.viewModels = result.tracks?.items?.compactMap({
                            RecommendedTrackCellViewModel(
                                name: $0.track?.name ?? "-",
                                artistName: $0.track?.artists?.first?.name ?? "-",
                                imageURL: URL(string: $0.track?.album?.images?.first?.url ?? "")
                            )
                        }) ?? []
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - CollectionView

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModels[indexPath.row].setup(collectionView: collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return PlaylistHeaderReusableViewModel (
            name: playlist.name ?? "-",
            ownerName: playlist.owner?.displayName ?? "-",
            description: playlist.desc ?? "-",
            imageURL: URL(string: playlist.images?.first?.url ?? ""),
            delegate: self
        )
        .setup(
            collectionView: collectionView,
            kind: kind,
            cellForItemAt: indexPath
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(
            from: self,
            track: track
        )
    }
    
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    
    func didTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(
            from: self,
            tracks: tracks
        )
    }
}
