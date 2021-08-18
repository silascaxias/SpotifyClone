//
//  NewReleaseCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 16/08/21.
//

import UIKit

class NewReleaseCollectionViewCell: UICollectionViewCell {
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .thin)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = contentView.height - 10.0
        
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(
                width: contentView.width - imageSize - 10.0,
                height: contentView.height - 10.0
            )
        )
        
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        albumImageView.frame = CGRect(x: 5.0, y: 5.0, width: imageSize, height: imageSize)
        
        let albumNameLabelHeight = min(60, albumLabelSize.height)
        
        albumNameLabel.frame = CGRect(
            x: albumImageView.right + 10.0,
            y: 5.0,
            width: albumLabelSize.width,
            height: albumNameLabelHeight
        )
        
        artistNameLabel.frame = CGRect(
            x: albumImageView.right + 10.0,
            y: albumNameLabel.bottom,
            width: contentView.width - albumImageView.right - 10.0,
            height: 30
        )
        
        numberOfTracksLabel.frame = CGRect(
            x: albumImageView.right + 10.0,
            y: contentView.bottom - 44.0,
            width: numberOfTracksLabel.width,
            height: 44
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumImageView.image = nil
    }
    
    func setup(with viewModel: NewReleasesCellViewModell) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumImageView.downloadImage(from: viewModel.imageURL)
    }
}

struct NewReleasesCellViewModell {
    let name: String
    let imageURL: URL?
    let numberOfTracks: Int
    let artistName: String
    
    func setup(
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.reuseIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.reuseIdentifier, for: indexPath) as? NewReleaseCollectionViewCell
        cell?.setup(with: self)
        return cell ?? UICollectionViewCell()
    }
}
