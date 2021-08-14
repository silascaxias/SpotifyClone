//
//  UserProfile.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import Foundation

struct UserProfile: Codable {
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
    
    let country: String?
    let displayName: String?
    let email: String?
    let explicitContent: ExplicitContent?
    let externalUrls: ExternalUrls?
    let followers: Followers?
    let id: String?
    let images: [Image]?
    let product: String?
    
    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case followers, id, images, product
    }
}

// MARK: - ExplicitContent
struct ExplicitContent: Codable {
    let filterEnabled: Bool?
    let filterLocked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String?
}

// MARK: - Followers
struct Followers: Codable {
    let href: String?
    let total: Int?
}

// MARK: - Image
struct Image: Codable {
    let url: String?
}
