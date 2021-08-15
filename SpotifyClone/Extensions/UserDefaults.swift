//
//  UserDefaults.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 15/08/21.
//

import UIKit

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
