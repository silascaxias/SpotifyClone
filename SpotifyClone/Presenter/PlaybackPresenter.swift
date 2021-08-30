//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 18/08/21.
//

import AVFoundation
import UIKit

protocol PlaybackPresenterDatasource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: String? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var tracks = [AVPlayer]()
    
    var playerViewController = PlayerViewController()
    
    var index = 0
    
    var models = [PlaybackModel]()
    
    var playbackMusicType: PlabackMusicType = .single
    
    var currentTrack: AVPlayer? {
        switch playbackMusicType {
            case .single: return tracks.count > 0 ? tracks[0] : nil
            case .playlist: return tracks.indices.contains(index) ? tracks[index] : nil
        }
    }
    
    var currentModel: PlaybackModel? {
        switch playbackMusicType {
            case .single: return models.count > 0 ? models[0] : nil
            case .playlist: return models.indices.contains(index) ? models[index] : nil
        }
    }
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) {
        
        guard let url = URL(string: track.previewURL ?? "") else {
            return
        }
        
        models.removeAll()
        tracks.append(AVPlayer(url: url))
        models.append(PlaybackModel(songName: track.name, subtitle: track.artists?.first?.name, imageURL: track.album?.images?.first?.url))
        
        playbackMusicType = .single
        
        index = 0
        
        setupPlayer(playing: false)
        
        playerViewController.dataSource = self
        playerViewController.delegate = self
        
        present(from: viewController, to: playerViewController) { [weak self] in
            self?.currentTrack?.play()
            self?.playerViewController.refreshUI()
        }
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        models.removeAll()
        self.tracks = tracks.filter({ !($0.previewURL?.isEmpty ?? true)}).compactMap({ AVPlayer(url: URL(string: $0.previewURL ?? "")!) })
        self.models = tracks.compactMap({ PlaybackModel(songName: $0.name, subtitle: $0.artists?.first?.name, imageURL: $0.album?.images?.first?.url) })
        
        playbackMusicType = .playlist
        index = 0
        
        if self.tracks.isEmpty {
            return
        }
        
        setupPlayer(playing: false)
        
        playerViewController.dataSource = self
        playerViewController.delegate = self
        present(from: viewController, to: playerViewController, completion: { [weak self] in
            self?.currentTrack?.play()
            self?.playerViewController.refreshUI()
        })
    }
    
    func present(from viewController: UIViewController, to playerViewController: PlayerViewController, completion: (() -> Void)?) {
        viewController.present(UINavigationController(rootViewController: playerViewController), animated: true, completion: completion)
    }
    
    func setupPlayer(playing: Bool, completion: ((Bool) -> Void)? = nil) {

        currentTrack?.volume = playerViewController.controlsView.volumeSlider.value
        if playing { currentTrack?.play() }
        completion?(playing)
    }
}

extension PlaybackPresenter: PlaybackPresenterDatasource {
    
    var songName: String? {
        return currentModel?.songName ?? ""
    }
    
    var subtitle: String? {
        
        return currentModel?.subtitle ?? ""
    }
    
    var imageURL: String? {
        return currentModel?.imageURL ?? ""
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    
    func playerViewControllerDidTapPlayPause(completion: (Bool) -> Void) {
        if currentTrack?.timeControlStatus == .playing {
            currentTrack?.pause()
            completion(false)
        } else {
            currentTrack?.play()
            completion(true)
        }
    }
    
    func playerViewControllerDidTapForward(completion: (Bool) -> Void) {
        if tracks.indices.contains(index + 1) {
            currentTrack?.seek(to: .zero)
            currentTrack?.pause()
            
            index += 1
            setupPlayer(playing: true)
            self.playerViewController.refreshUI()
            completion(true)
        } else {
            currentTrack?.pause()
            completion(false)
        }
    }
    
    func playerViewControllerDidTapBackward(completion: @escaping (Bool) -> Void) {
        if tracks.indices.contains(index - 1) {
            currentTrack?.seek(to: .zero)
            currentTrack?.pause()
            index -= 1
            setupPlayer(playing: true)
            self.playerViewController.refreshUI()
            completion(true)
        } else {
            currentTrack?.pause()
            completion(false)
        }
    }
    
    func playerViewControllerDidSlideVolume(_ value: Float) {
        currentTrack?.volume = value
    }
}

enum PlabackMusicType {
    case single
    case playlist
}

struct PlaybackModel {
    var songName: String?
    var subtitle: String?
    var imageURL: String?
}
