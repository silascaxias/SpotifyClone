//
//  Artist.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let externalUrls: ExternalUrls
    let name, type: String

    enum CodingKeys: String, CodingKey {
        case id
        case externalUrls = "external_urls"
        case name, type
    }
}
