//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 18/08/21.
//

import UIKit

final class PlaybackPresenter {
    
    static func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) {
        let playerViewController = PlayerViewController()
        playerViewController.title = track.name
        present(from: viewController, to: playerViewController)
    }
    
    static func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        let playerViewController = PlayerViewController()
        present(from: viewController, to: playerViewController)
    }
    
    private static func present(from viewController: UIViewController, to playerViewController: PlayerViewController) {
        viewController.present(UINavigationController(rootViewController: playerViewController), animated: true)
    }
}
