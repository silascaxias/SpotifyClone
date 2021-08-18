//
//  GenreCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 17/08/21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage (
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50.0,
                weight: .regular
            )
        )
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        imageView.image = UIImage (
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50.0,
                weight: .regular
            )
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(
            x: contentView.frame.origin.x,
            y: contentView.frame.origin.y,
            width: contentView.width,
            height: contentView.height
        )
        
        label.frame = CGRect(
            x: 10.0,
            y: contentView.height - 30.0,
            width: contentView.width - 20.0,
            height: 30.0
        )
    }
    
    func setup(with viewModel: CategoryCellViewModel) {
        label.text = viewModel.category.name
        contentView.backgroundColor = .clear
        imageView.downloadImage(from: URL(string: viewModel.category.icons?.first?.url ?? ""))
    }
}

struct CategoryCellViewModel {
    let category: Category
    
    func setup(
        collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell {
            
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell
        cell?.setup(with: self)
        return cell ?? UICollectionViewCell()
    }
}
