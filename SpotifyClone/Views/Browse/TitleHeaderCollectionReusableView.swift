//
//  TitleHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 17/08/21.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20.0, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(
            x: 15.0,
            y: 0,
            width: width - 30.0,
            height: height
        )
    }
    
    func setup(
        title: String,
        collectionView: UICollectionView,
        kind: String,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.reuseViewIdentifier
        )
        
        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TitleHeaderCollectionReusableView.reuseViewIdentifier,
            for: indexPath
        ) as? TitleHeaderCollectionReusableView
        
        cell?.label.text = title
        
        return cell ?? UICollectionReusableView()
    }
}
