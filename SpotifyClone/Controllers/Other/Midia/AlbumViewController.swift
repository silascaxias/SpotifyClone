//
//  AlbumViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 16/08/21.
//

import UIKit

class AlbumViewController: UIViewController {
    
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

    private var viewModels = [AlbumTrackCellViewModel]()
    
    private let album: Album
    
    private var tracks = [AudioTrack]()
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = album.name
        view.backgroundColor = .systemBackground
        
        setupView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
    private func setupView() {
        title = album.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func fetchData() {
        APIManager.shared.getAlbumDetails(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self?.tracks = result.tracks?.items ?? []
                    self?.viewModels = result.tracks?.items?.compactMap({
                        AlbumTrackCellViewModel(
                            name: $0.name ?? "-",
                            artistName: $0.artists?.first?.name ?? "-"
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

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModels[indexPath.row].setup(collectionView: collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return PlaylistHeaderReusableViewModel (
            name: album.name ?? "-",
            ownerName: album.artists?.first?.name ?? "-",
            description: "Release Date: \(String.formattedDate(string: album.releaseDate ?? "-"))",
            imageURL: URL(string: album.images?.first?.url ?? ""),
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
        
        var track = tracks[indexPath.row]
        track.album = self.album
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    
    func didTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }
}

