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
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
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
        
        refrechAccessToken(refreshToken: refreshToken, completion: completion ?? { _ in})
    }
    
    public func fetchToken(with code: String, completion: @escaping ((Bool) -> Void)) {
        if let url = URL(string: Configurations.tokenAPIURL) {
            
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "redirect_uri", value: Configurations.redirectURI )
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = components.query?.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let basicToken = "\(Configurations.clientID):\(Configurations.clientSecret)"
            let data = basicToken.data(using: .utf8)
            guard let base64String = data?.base64EncodedString() else {
                print("Failed to get BASE64")
                completion(false)
                return
            }
            
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            
            APIManager.shared.getData(from: request) { data, _, error in
                guard let data = data, error == nil  else {
                    completion(false)
                    return
                }
                
                do {
                    let authenticationResponde = try JSONDecoder().decode(AuthenticationResponde.self, from: data)
                    authenticationResponde.saveData()
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
    public func refrechAccessToken(refreshToken: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: Configurations.tokenAPIURL) else {
            return
        }
    
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken )
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = "\(Configurations.clientID):\(Configurations.clientSecret)"
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get BASE64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        APIManager.shared.getData(from: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            
            guard let data = data, error == nil  else {
                completion(false)
                return
            }
            
            do {
                let authenticationResponde = try JSONDecoder().decode(AuthenticationResponde.self, from: data)
                self?.onRefreshBlocks.forEach{ $0(authenticationResponde.accessToken) }
                self?.onRefreshBlocks.removeAll()
                authenticationResponde.saveData()
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }

    }
}
