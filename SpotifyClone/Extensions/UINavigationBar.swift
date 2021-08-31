//
//  UINavigationBar.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 31/08/21.
//

import UIKit

extension UINavigationBar {
    
    func setTransparence() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
