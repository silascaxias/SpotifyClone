//
//  PlaylistHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 17/08/21.
//

import UIKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func didTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22.0, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18.0, weight: .light)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapPlayAll() {
        delegate?.didTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = height / 1.8
        imageView.frame = CGRect(
            x: (width - imageSize) / 2.0,
            y: 20,
            width: imageSize,
            height: imageSize
        )
        
        nameLabel.frame = CGRect(
            x: 10,
            y: imageView.bottom,
            width: width - 20.0,
            height: 44
        )
        
        descriptionLabel.frame = CGRect(
            x: 10,
            y: nameLabel.bottom,
            width: width - 20.0,
            height: 44
        )
        
        ownerLabel.frame = CGRect(
            x: 10,
            y: descriptionLabel.bottom,
            width: width - 20.0,
            height: 44
        )
        
        playAllButton.frame = CGRect(
            x: width - 80.0,
            y: height - 80.0,
            width: 60,
            height: 60
        )
    }
    
    func setup(with viewModel: PlaylistHeaderReusableViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
        imageView.downloadImage(from: viewModel.imageURL)
        delegate = viewModel.delegate
    }
}

struct PlaylistHeaderReusableViewModel {
    let name: String
    let ownerName: String?
    let description: String
    let imageURL: URL?
    let delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    func setup(
        collectionView: UICollectionView,
        kind: String,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.reuseViewIdentifier
        )
        
        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.reuseViewIdentifier,
            for: indexPath
        ) as? PlaylistHeaderCollectionReusableView
        
        cell?.setup(with: self)
        
        return cell ?? UICollectionReusableView()
    }
}
