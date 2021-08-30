//
//  SearchViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Songs, Artists, Albums"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2.0,
                leading: 7.0,
                bottom: 2.0,
                trailing: 7.0
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(150.0)
                ),
                subitem: item,
                count: 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 10.0,
                leading: 0.0,
                bottom: 10.0,
                trailing: 0.0
            )
            
            return NSCollectionLayoutSection(group: group)
    }))
    
    var categories = [Category]()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        fetchData()
    }
    
    func fetchData() {
        APIManager.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let categories):
                        self?.categories = categories
                        self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    
    func didTapResult(_ result: SearchResult) {
        
        var viewController = UIViewController()
        
        switch result {
            case .artist(let artist):
                guard let url = URL(string: artist.externalUrls?.spotify ?? "") else {
                    return
                }
                let safaryViewController = SFSafariViewController(url: url)
                present(safaryViewController, animated: true)
            case .album(let album): viewController = AlbumViewController(album: album)
            case .track(let track): return PlaybackPresenter.startPlayback(from: self, track: track)
            case .playlist(let playlist): viewController = PlaylistViewController(playlist: playlist)
        }
        
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - CollectionView

extension SearchViewController: UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.row]
        return CategoryCellViewModel(category: category).setup(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let category = categories[indexPath.row]
        let categoryViewController = CategoryViewController(category: category)
        categoryViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultsController.delegate = self
        
        APIManager.shared.getSearchResults(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let result):
                        resultsController.update(with: result)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
}
