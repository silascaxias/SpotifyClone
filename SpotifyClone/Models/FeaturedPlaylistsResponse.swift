//
//  FeaturedPlaylistsResponse.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 15/08/21.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse?
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let id: String
    let displayName: String?
    let externalUrls: ExternalUrls?

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case externalUrls = "external_urls"
    }
}
