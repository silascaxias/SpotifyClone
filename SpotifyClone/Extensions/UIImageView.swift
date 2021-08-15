//
//  UIImageView.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 15/08/21.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from url: URL) {
        if let dataImage = UserDefaults.standard.cacheProfileImage {
            
            DispatchQueue.main.async { self.image = UIImage(data: dataImage) }
            return
        }
        
        APIManager.shared.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let image = UIImage(data: data)
            UserDefaults.standard.cacheProfileImage = data
            DispatchQueue.main.async {  self.image = image }
        }
    }
}
