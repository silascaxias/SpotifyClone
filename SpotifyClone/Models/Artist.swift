//
//  Artist.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import Foundation

struct Artist: Codable {
    let id: String?
    let externalUrls: ExternalUrls?
    let name: String?
    let type: String?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case name, type, id, images
    }
}
