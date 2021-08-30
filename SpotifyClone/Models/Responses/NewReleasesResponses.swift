//
//  NewReleasesResponses.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 15/08/21.
//

import Foundation


// MARK: - Welcome
struct NewReleasesResponses: Codable {
    let albums: AlbumsResponse?
}

// MARK: - Albums
struct AlbumsResponse: Codable {
    let items: [Album]?
}

// MARK: - Item
struct Album: Codable {
    let id: String?
    let totalTracks: Int?
    let albumType: String?
    let artists: [Artist]?
    let availableMarkets: [String]?
    let releaseDatePrecision: String?
    let images: [Image]?
    let releaseDate: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case totalTracks = "total_tracks"
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case releaseDatePrecision = "release_date_precision"
        case images
        case releaseDate = "release_date"
        case name
    }
}
