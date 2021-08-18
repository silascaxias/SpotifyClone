//
//  Playlist.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import Foundation

struct Playlist: Codable {
    let desc: String?
    let externalUrls: ExternalUrls?
    let id: String?
    let images: [Image]?
    let name: String?
    let owner: User?
    
    enum CodingKeys: String, CodingKey {
        case id, images, name, owner
        case desc = "description"
        case externalUrls = "external_urls"
    }
}
