//
//  AudioTrack.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import Foundation

struct AudioTrack: Codable {
    let id, name: String?
    let album: Album?
    let discNumber: Int?
    let durationMs: Int?
    let artists: [Artist]?
    let availableMarkets: [String]?
    let explicit: Bool?
    let externalUrls: ExternalUrls?

    enum CodingKeys: String, CodingKey {
        case id, name, album, explicit, artists
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
    }
}
