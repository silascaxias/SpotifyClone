//
//  SearchResultSubtitleTableViewCell.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 18/08/21.
//

import UIKit

class SearchResultSubtitleTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let susbtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
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
        contentView.addSubview(susbtitleLabel)
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
        
        let labelHeight = contentView.height / 2.0
        
        label.frame = CGRect(
            x: iconImageView.right + 10.0,
            y: 0,
            width: contentView.width - iconImageView.right - 15.0,
            height: labelHeight
        )
        
        susbtitleLabel.frame = CGRect(
            x: iconImageView.right + 10.0,
            y: label.bottom,
            width: contentView.width - iconImageView.right - 15.0,
            height: labelHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
        susbtitleLabel.text = nil
    }
    
    func setup(with viewModel: SearchResultSubtitleViewModel) {
        label.text = viewModel.title
        iconImageView.downloadImage(from: viewModel.imageURL)
        susbtitleLabel.text = viewModel.subtitle
    }
}

struct SearchResultSubtitleViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    
    func setup(
        tableView: UITableView,
        indexPath: IndexPath
    ) -> UITableViewCell {
            
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.reuseIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultSubtitleTableViewCell
        cell?.setup(with: self)
        return cell ?? UITableViewCell()
    }
}
