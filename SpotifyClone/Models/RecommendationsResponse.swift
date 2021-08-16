//
//  RecommendationsResponse.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 16/08/21.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
