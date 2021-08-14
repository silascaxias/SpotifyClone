//
//  Extensions.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
}

extension UserDefaults {
    
    private struct Key {
        
        static let ACCESS_TOKEN = "ACCESS_TOKEN"

        static let REFRESH_TOKEN = "REFRESH_TOKEN"
        
        static let EXPIRATION_DATE = "EXPIRATION_DATE"
        
        static let CACHE_PROFILE_IMAGE = "CACHE_PROFILE_IMAGE"
    }
    
    var accessToken: String? {
        get { return string(forKey: Key.ACCESS_TOKEN) }
        set { set(newValue, forKey: Key.ACCESS_TOKEN) }
    }
    
    var refreshToken: String? {
        get { return string(forKey: Key.REFRESH_TOKEN) }
        set { set(newValue, forKey: Key.REFRESH_TOKEN) }
    }
    
    var expirationDate: Date? {
        get { return value(forKey: Key.EXPIRATION_DATE) as? Date }
        set { set(newValue, forKey: Key.EXPIRATION_DATE) }
    }
    
    var cacheProfileImage: Data? {
        get { return value(forKey: Key.CACHE_PROFILE_IMAGE) as? Data }
        set { set(newValue, forKey: Key.CACHE_PROFILE_IMAGE) }
    }
}

extension UIImageView {
    
    func downloadImage(from url: URL) {
        if let dataImage = UserDefaults.standard.cacheProfileImage {
            
            DispatchQueue.main.async { self.image = UIImage(data: dataImage) }
            return
        }
        
        APIManager.shared.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }

            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            DispatchQueue.main.async() { [weak self] in
                let image = UIImage(data: data)
                UserDefaults.standard.cacheProfileImage = data
                self?.image = image
            }
        }
    }
}
