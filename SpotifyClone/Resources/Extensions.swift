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
    }
    
    var accessToken: String? {
        get { return string(forKey: Key.ACCESS_TOKEN) }
        set { setValue(newValue, forKey: Key.ACCESS_TOKEN) }
    }
    
    var refreshToken: String? {
        get { return string(forKey: Key.REFRESH_TOKEN) }
        set { setValue(newValue, forKey: Key.REFRESH_TOKEN) }
    }
    
    var expirationDate: Date? {
        get { return value(forKey: Key.EXPIRATION_DATE) as? Date }
        set { setValue(newValue, forKey: Key.REFRESH_TOKEN) }
    }
}
