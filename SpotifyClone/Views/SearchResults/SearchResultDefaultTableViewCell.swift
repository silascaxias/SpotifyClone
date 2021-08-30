//
//  SearchResultDefaultTableViewCell.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 18/08/21.
//

import UIKit

class SearchResultDefaultTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.height - 10.0
        
        iconImageView.frame = CGRect(
            x: 10.0,
            y: 5.0,
            width: imageSize,
            height: imageSize
        )
        
        iconImageView.layer.cornerRadius = imageSize / 2.0
        iconImageView.layer.masksToBounds = true
        
        label.frame = CGRect(
            x: iconImageView.right + 10.0,
            y: 0,
            width: contentView.width - iconImageView.right - 15.0,
            height: contentView.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
    }
    
    func setup(with viewModel: SearchResultDefaultViewModel) {
        label.text = viewModel.title
        iconImageView.downloadImage(from: viewModel.imageURL)
    }
}

struct SearchResultDefaultViewModel {
    let title: String
    let imageURL: URL?
    
    func setup(
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
            
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.reuseIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultDefaultTableViewCell
        cell?.setup(with: self)
        return cell ?? UITableViewCell()
    }
}
