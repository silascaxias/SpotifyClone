//
//  SearchResult.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 18/08/21.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
    
    func isArtist() -> Bool {
        switch self {
            case .artist(model: _): return true
            default: return false
        }
    }
    
    func isAlbum() -> Bool {
        switch self {
            case .album(model: _): return true
            default: return false
        }
    }
    
    func isTrack() -> Bool {
        switch self {
            case .track(model: _): return true
            default: return false
        }
    }
    
    func isPlaylist() -> Bool {
        switch self {
            case .playlist(model: _): return true
            default: return false
        }
    }
}

