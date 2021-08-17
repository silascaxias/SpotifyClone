//
//  UICollectionViewCell.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 16/08/21.
//

import UIKit

extension UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
