//
//  UIView.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 17/08/21.
//

import UIKit

extension UIView {
    
    static var reuseViewIdentifier: String {
        return String(describing: self)
    }
}
