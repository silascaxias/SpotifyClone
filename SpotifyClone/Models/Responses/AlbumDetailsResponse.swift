//
//  AlbumDetailsResponse.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 16/08/21.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let id: String?
    let name: String?
    let label: String?
    let tracks: TracksResponse?
    let artists: [Artist]?
    let availableMarkets: [String]?
    let images: [Image]?
    let externalUrls: ExternalUrls?

    enum CodingKeys: String, CodingKey {
        case id, name, label, tracks, artists, images
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
    }
}

struct TracksResponse: Codable {
    let items: [AudioTrack]?
}
