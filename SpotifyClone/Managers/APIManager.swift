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
    
    private func fullURL(api: API, parameters: String = "") -> URL? { URL(string: Configurations.baseAPIURL + api.rawValue + parameters) }
    
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
    
    public func getNewReleases(completion: @escaping (Result<NewReleasesResponses, Error>) -> Void) {
        createRequest(
            with: fullURL(api: .browseNewReleases, parameters: "?limit=50"),
            type: .GET
        ) { [weak self] request in
            self?.getData(from: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.onGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponses.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        createRequest(
            with: fullURL(api: .browseFeaturedPlaylists, parameters: "?limit=50"),
            type: .GET
        ) { [weak self] request in
            self?.getData(from: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.onGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        
        createRequest(
            with: fullURL(api: .recommendations, parameters: "?limit=50&seed_genres=\(seeds)"),
            type: .GET
        ) { [weak self] request in
            self?.getData(from: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.onGetData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(
            with: fullURL(api: .recommendedGenres),
            type: .GET
        ) { [weak self] request in
            self?.getData(from: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.onGetData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func createRequest (
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
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
        case browseNewReleases = "/browse/new-releases"
        case browseFeaturedPlaylists = "/browse/featured-playlists"
        case recommendations = "/recommendations"
        case recommendedGenres = "/recommendations/available-genre-seeds"
    }
}
