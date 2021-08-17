//
//  UIImageView.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 15/08/21.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from url: URL?, keyForCache: String? = nil) {
        if  let keyForCache = keyForCache,
            let dataImage = UserDefaults.standard.getImageCache(key: keyForCache) {
            
            DispatchQueue.main.async { self.image = UIImage(data: dataImage) }
            return
        }
        
        guard let url = url else { return }
        
        APIManager.shared.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let image = UIImage(data: data)
            if let keyForCache = keyForCache {
                UserDefaults.standard.setImageCache(key: keyForCache, image: data)
            }
            DispatchQueue.main.async {  self.image = image }
        }
    }
}
