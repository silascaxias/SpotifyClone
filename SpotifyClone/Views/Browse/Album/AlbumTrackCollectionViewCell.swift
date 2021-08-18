//
//  AlbumTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 17/08/21.
//


import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackNameLabel.frame = CGRect(
            x: 10.0,
            y: 0,
            width: contentView.width - 15.0,
            height: contentView.height / 2
        )
        
        artistNameLabel.frame = CGRect(
            x: 10.0,
            y: contentView.height / 2,
            width: contentView.width - 15.0,
            height: contentView.height / 2
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func setup(with viewModel: AlbumTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}

struct AlbumTrackCellViewModel {
    let name: String
    let artistName: String
    
    func setup(
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.reuseIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.reuseIdentifier, for: indexPath) as? AlbumTrackCollectionViewCell
        cell?.setup(with: self)
        return cell ?? UICollectionViewCell()
    }
}
