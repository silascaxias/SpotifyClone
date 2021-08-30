//
//  AllCategoriesResponse.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 18/08/21.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories?
}

struct Categories: Codable {
    let items: [Category]?
}

struct Category: Codable {
    let id: String?
    let icons: [Image]?
    let name: String?
}
