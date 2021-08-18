//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 16/08/21.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        creatorNameLabel.frame = CGRect(
            x: 3.0,
            y: contentView.height - 30.0,
            width: contentView.width - 6.0,
            height: 30.0
        )
        
        playlistNameLabel.frame = CGRect(
            x: 3.0,
            y: contentView.height - 60.0,
            width: contentView.width - 6.0,
            height: 30.0
        )
        
        let imageSize = contentView.height - 70.0
        playlistImageView.frame = CGRect(
            x: (contentView.width - imageSize) / 2,
            y: 3.0,
            width: imageSize,
            height: imageSize
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistImageView.image = nil
    }
    
    func setup(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistImageView.downloadImage(from: viewModel.imageURL)
    }
}

struct FeaturedPlaylistCellViewModel {
    let name: String
    let imageURL: URL?
    let creatorName: String
    
    func setup(
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.reuseIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.reuseIdentifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell
        cell?.setup(with: self)
        return cell ?? UICollectionViewCell()
    }
}
