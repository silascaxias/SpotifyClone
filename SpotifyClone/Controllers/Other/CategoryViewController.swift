//
//  CategoryViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 18/08/21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    let category: Category
    
    private var playlists = [Playlist]()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 5.0,
                leading: 5.0,
                bottom: 5.0,
                trailing: 5.0
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(250.0)
                ),
                subitem: item,
                count: 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 5.0,
                leading: 5.0,
                bottom: 5.0,
                trailing: 5.0
            )
            
            return NSCollectionLayoutSection(group: group)
        }))
    
    // MARK: - Init
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category.name
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchCategoryPlaylists()
    }
    
    private func fetchCategoryPlaylists() {
        
        APIManager.shared.getCategoryPlaylists(with: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let result):
                        guard let playlists = result else {
                            return
                        }
                        self?.playlists = playlists
                        self?.collectionView.reloadData()
                    case .failure(let error): print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
}

// MARK: - CollectionView

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let playlist = playlists[indexPath.row]
        
        return FeaturedPlaylistCellViewModel(name: playlist.name ?? "-", imageURL: URL(string: playlist.images?.first?.url ?? ""), creatorName: playlist.owner?.displayName ?? "-").setup(collectionView: collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let playlistViewController = PlaylistViewController(playlist: playlists[indexPath.row])
        navigationController?.pushViewController(playlistViewController, animated: true)
    }
}
