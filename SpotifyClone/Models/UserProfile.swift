//
//  UserProfile.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import Foundation

struct UserProfile {
    static var arrayScopes = [
        "user-read-private",
        "playlist-modify-public",
        "playlist-read-private",
        "playlist-modify-private",
        "user-follow-read",
        "user-library-modify",
        "user-library-read",
        "user-read-email"
    ]
    
    static var scopes = arrayScopes.joined(separator: "%20")
}
