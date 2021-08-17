//
//  RecommendedTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 16/08/21.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
        contentView.addSubview(albumImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumImageView.frame = CGRect(
            x: 5.0,
            y: 2.0,
            width: contentView.height - 4.0,
            height: contentView.height - 4.0
        )
        
        trackNameLabel.frame = CGRect(
            x: albumImageView.right + 10.0,
            y: 0,
            width: contentView.width - albumImageView.right - 15.0,
            height: contentView.height / 2
        )
        
        artistNameLabel.frame = CGRect(
            x: albumImageView.right + 10.0,
            y: contentView.height / 2,
            width: contentView.width - albumImageView.right - 15.0,
            height: contentView.height / 2
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumImageView.image = nil
    }
    
    func setup(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumImageView.downloadImage(from: viewModel.imageURL)
    }
}

struct RecommendedTrackCellViewModel {
    let id: String
    let name: String
    let artistName: String
    let imageURL: URL?
    
    func setup(
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.reuseIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.reuseIdentifier, for: indexPath) as? RecommendedTrackCollectionViewCell
        cell?.setup(with: self)
        return cell ?? UICollectionViewCell()
    }
}
