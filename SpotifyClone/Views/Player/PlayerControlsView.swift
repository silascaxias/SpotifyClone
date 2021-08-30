//
//  PlayerControlsView.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 19/08/21.
//

import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView, completion: (Bool) -> Void)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView, completion: (Bool) -> Void)
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView, completion: @escaping (Bool) -> Void)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideVolume value: Float)
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlsViewDelegate?
    
    let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My Name Song"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Description"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "backward.fill",
            withConfiguration:
                UIImage.SymbolConfiguration(
                    pointSize: 30.0,
                    weight: .regular
                )
        )
        
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "forward.fill",
            withConfiguration:
                UIImage.SymbolConfiguration(
                    pointSize: 30.0,
                    weight: .regular
                )
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(
            systemName: "pause",
            withConfiguration:
                UIImage.SymbolConfiguration(
                    pointSize: 34.0,
                    weight: .regular
                )
        )
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        volumeSlider.addTarget(self, action: #selector(didSlideVolume(_:)), for: .valueChanged)
        
        clipsToBounds = true
    }
    
    @objc private func didSlideVolume(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideVolume: value)
    }
    
    @objc private func didTapBack() {
        
        delegate?.playerControlsViewDidTapBackwardButton(self) { [weak self] isPlaying in
            self?.updateView(with: isPlaying)
        }
    }
    
    @objc private func didTapNext() {
        
        delegate?.playerControlsViewDidTapForwardButton(self) { [weak self] isPlaying in
            self?.updateView(with: isPlaying)
        }
    }
    
    @objc private func didTapPlayPause() {
        
        delegate?.playerControlsViewDidTapPlayPause(self) { [weak self] isPlaying in
            self?.updateView(with: isPlaying)
        }
    }
    
    func updateView(with isPlaying: Bool) {
        let pauseIcon = UIImage(
            systemName: "pause",
            withConfiguration:
                UIImage.SymbolConfiguration(
                    pointSize: 34.0,
                    weight: .regular
                )
        )
        
        let playIcon = UIImage(
            systemName: "play.fill",
            withConfiguration:
                UIImage.SymbolConfiguration(
                    pointSize: 34.0,
                    weight: .regular
                )
        )
        
        playPauseButton.setImage(isPlaying ? pauseIcon : playIcon, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom + 10.0, width: width, height: 50)
        
        volumeSlider.frame = CGRect(x: 10.0, y: subtitleLabel.bottom + 20.0, width: width - 20.0, height: 44.0)
        
        let buttonSize: CGFloat = 60.0
        playPauseButton.frame = CGRect(x: (width - buttonSize) / 2.0, y: volumeSlider.bottom + 30.0, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left - 80.0 - buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        nextButton.frame = CGRect(x: playPauseButton.right + 80.0, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    
    func setup(with viewModel: PlayerControlsViewViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

struct PlayerControlsViewViewModel {
    let title: String?
    let subtitle: String?
}
