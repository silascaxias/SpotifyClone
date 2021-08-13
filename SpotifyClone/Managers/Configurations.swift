//
//  Configurations.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 13/08/21.
//

import Foundation

final class Configurations {
    private enum PListKey: String {
        case redirectURI = "REDIRECT_URI"
        case tokenAPIURL = "TOKEN_API_URL"
        case clientSecret = "CLIENT_SECRET"
        case clientID = "CLIENT_ID"
        case baseURL = "BASE_URL"
    }
    
    public static var redirectURI = getString(for: .redirectURI)
    
    public static var tokenAPIURL = getString(for: .tokenAPIURL)
    
    public static var clientSecret = getString(for: .clientSecret)
    
    public static var clientID = getString(for: .clientID)
    
    public static var baseURL = getString(for: .baseURL)
    
    private static func getInfo(for key: PListKey) -> Any? {
        guard let infoDictPath = Bundle.main.path(forResource: "Configurations", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: infoDictPath) else { return nil }
        
        return dict[key.rawValue]
    }
    
    private static func getString(for key: PListKey) -> String {
        return getInfo(for: key) as? String ?? ""
    }

}
