//
//  PlayerViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit

protocol PlayerViewControllerDelegate: AnyObject {
    func playerViewControllerDidTapPlayPause(completion: (Bool) -> Void)
    func playerViewControllerDidTapForward(completion: (Bool) -> Void)
    func playerViewControllerDidTapBackward(completion: @escaping (Bool) -> Void)
    func playerViewControllerDidSlideVolume(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlaybackPresenterDatasource?
    weak var delegate: PlayerViewControllerDelegate?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        setupBarButton()
        setupDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
        
        controlsView.frame = CGRect(
            x: 10.0,
            y: imageView.bottom + 10.0,
            width: view.width - 20.0,
            height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15.0
        )
    }
    
    private func setupDataSource() {
        imageView.downloadImage(from: URL(string: dataSource?.imageURL ?? ""))
        controlsView.setup(
            with: PlayerControlsViewViewModel(
                            title: dataSource?.songName,
                            subtitle: dataSource?.subtitle
            )
        )
    }
    
    private func setupBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapClose)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction)
        )
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
        // action
    }
    
    func refreshUI() {
        setupDataSource()
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView, completion: (Bool) -> Void) {
        delegate?.playerViewControllerDidTapForward(completion: completion)
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView, completion: @escaping (Bool) -> Void) {
        delegate?.playerViewControllerDidTapBackward(completion: completion)
    }
    
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView, completion: (Bool) -> Void) {
        delegate?.playerViewControllerDidTapPlayPause(completion: completion)
    }
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideVolume value: Float) {
        delegate?.playerViewControllerDidSlideVolume(value)
    }
}

