//
//  SettingsModels.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 13/08/21.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
