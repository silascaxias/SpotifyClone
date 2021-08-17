//
//  UserDefaults.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 15/08/21.
//

import UIKit

enum UserDefaultsKey: String {
    case ACCESS_TOKEN = "ACCESS_TOKEN"
    case REFRESH_TOKEN = "REFRESH_TOKEN"
    case EXPIRATION_DATE = "EXPIRATION_DATE"
    case CACHE_PROFILE_IMAGE = "CACHE_PROFILE_IMAGE"
}

extension UserDefaults {
    
    var accessToken: String? {
        get { return string(forKey: UserDefaultsKey.ACCESS_TOKEN.rawValue) }
        set { set(newValue, forKey: UserDefaultsKey.ACCESS_TOKEN.rawValue) }
    }
    
    var refreshToken: String? {
        get { return string(forKey: UserDefaultsKey.REFRESH_TOKEN.rawValue) }
        set { set(newValue, forKey: UserDefaultsKey.REFRESH_TOKEN.rawValue) }
    }
    
    var expirationDate: Date? {
        get { return value(forKey: UserDefaultsKey.EXPIRATION_DATE.rawValue) as? Date }
        set { set(newValue, forKey: UserDefaultsKey.EXPIRATION_DATE.rawValue) }
    }
    
    func setImageCache(key: String, image: Data?) {
        set(image, forKey: key)
    }
    
    func getImageCache(key: String) -> Data? {
        return value(forKey: key) as? Data
    }
}
