//
//  AuthenticatorManager.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import Foundation

final class AuthenticatorManager {
    static let shared = AuthenticatorManager()
    
    private var refreshingToken = false
    
    private init() {}
    
    public var signInURL: URL? {
        let stringURL =
            "\(Configurations.baseURL)?response_type=code&" +
            "client_id=\(Configurations.clientID)&" +
            "scope=\(UserProfile.scopes)&" +
            "redirect_uri=\(Configurations.redirectURI)&" +
            "show_dialog=TRUE"
        return URL(string: stringURL)
    }
    
    
    var isSignedIn: Bool {
        return UserDefaults.standard.accessToken != nil
    }
    
    private var needRefreshToken: Bool {
        let fiveMinutes: TimeInterval = 300
        let currentDate = Date().addingTimeInterval(fiveMinutes)
        return currentDate >= UserDefaults.standard.expirationDate ?? Date()
    }
    
    public func fetchToken(with code: String, completion: @escaping ((Bool) -> Void)) {
        APIManager.shared.fetchToken(with: code, completion: completion)
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    // Get a valid token on API calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if needRefreshToken {
            checkIfNeededRefreshToken { result in
                if let token = UserDefaults.standard.accessToken, result {
                    completion(token)
                }
            }
        } else if let token = UserDefaults.standard.accessToken {
            completion(token)
        }
    }
    
    func checkIfNeededRefreshToken(completion: ((Bool) -> Void)?) {
        guard !refreshingToken else {
            return
        }
        
        guard needRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = UserDefaults.standard.refreshToken else {
            return
        }
        
        refreshingToken = true
        
        APIManager.shared.refrechAccessToken(
            refreshToken: refreshToken, completion: completion ?? { _ in}) { [weak self] in
            self?.refreshingToken = false
        } updateRefreshingBlocks: { [weak self] accessToken in
            self?.onRefreshBlocks.forEach{ $0(accessToken) }
            self?.onRefreshBlocks.removeAll()
        }
    }
}
