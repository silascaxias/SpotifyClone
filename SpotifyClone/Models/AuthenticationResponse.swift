//
//  AuthenticationResponse.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import Foundation

struct AuthenticationResponde: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String?
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope = "scope"
        case tokenType = "token_type"
    }
    
    func saveData() {
        UserDefaults.standard.accessToken = accessToken
        UserDefaults.standard.expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
        if let _refreshToken = refreshToken { UserDefaults.standard.refreshToken = _refreshToken }
    }
}
