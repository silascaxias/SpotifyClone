//
//  PlaylistDetailsResponse.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 16/08/21.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let id: String?
    let desc: String?
    let tracks: PlaylistTracksResponse?
    let images: [Image]?
    let externalUrls: ExternalUrls?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case desc = "description"
        case id
        case tracks, images, name
        case externalUrls = "external_urls"
    }
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]?
}

struct PlaylistItem: Codable {
    let track: AudioTrack?
}
