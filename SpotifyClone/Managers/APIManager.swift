//
//  APIManager.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    private func fullURL(api: API) -> URL? { URL(string: Configurations.baseAPIURL + api.rawValue) }
    
    public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public func getData(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(
            with: fullURL(api: .me),
            type: .GET
        ) { [weak self] request in
            self?.getData(from: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.onGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
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
    
    public func refrechAccessToken(
        refreshToken: String,
        completion: @escaping (Bool) -> Void,
        updateRefreshing: @escaping () -> Void,
        updateRefreshingBlocks: @escaping (String) -> Void) {
        
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
        
        APIManager.shared.getData(from: request) { data, _, error in
            updateRefreshing()
            
            guard let data = data, error == nil  else {
                completion(false)
                return
            }
            
            do {
                let authenticationResponde = try JSONDecoder().decode(AuthenticationResponde.self, from: data)
                print("Successfully refreshed")
                updateRefreshingBlocks(authenticationResponde.accessToken)
                authenticationResponde.saveData()
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }

    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void) {
        
        AuthenticatorManager.shared.withValidToken { token in
            guard let url = url else { return }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    // MARK: - Enums
    
    enum APIError: Error {
        case onGetData
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum API: String {
        case me = "/me"
    }
}
