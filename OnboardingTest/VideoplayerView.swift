//
//  VideoplayerView.swift
//  OnboardingTest
//
//  Created by Kaira Diagne on 25-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol VideoplayerViewDelegate: class {
    @objc optional func videoPlayerViewDidFinishPlaying(_ view: VideoplayerView)
    @objc optional func videoPlayerView(_ view: VideoplayerView, didFailWithError error: Error)
    @objc optional func videoPlayerViewDidStartPlaying(_ view: VideoplayerView)
    @objc optional func videoPlayerViewDidPause(_ view: VideoplayerView)
    @objc optional func videoPlayerViewDidResume(_ view: VideoplayerView)
}

final class VideoplayerView: UIView {
    
    // MARK: Types
    
    private struct Constants {
        static let ButtonHeight: CGFloat = 60
        static let ButtonWidth: CGFloat = 60
    }
    
    private enum ControlsState {
        case showPlayButton
        case showPauseButton
        case disabled
    }
    
    // MARK: Properties
    
    // View
    private var playerLayer: AVPlayerLayer?
    
    private var controlsContainerView = UIView(frame: .zero)
    
    private var pausePlayButton = UIButton(frame: .zero)
     
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(handle(tapGesture:)))
    }()
    
    weak var delegate: VideoplayerViewDelegate?
    
    // Video
    @objc private var player: AVPlayer?
    
    private var timeObserverToken: Any?
    
    private var controlsState: ControlsState = .disabled
    
    private var videoIsPlaying: Bool {
        return player?.rate == 1.0
    }
    
    private var didReachEndOfVideo = false
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .black
        
        addSubview(controlsContainerView)
        controlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        controlsContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        controlsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        controlsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        controlsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.translatesAutoresizingMaskIntoConstraints = false
        pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: Constants.ButtonHeight).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: Constants.ButtonWidth).isActive = true
        
        controlsContainerView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        
        controlsContainerView.backgroundColor = .clear
        controlsContainerView.addGestureRecognizer(tapGestureRecognizer)
        set(controlsState: controlsState, animated: true)
    
        pausePlayButton.tintColor = .white
        pausePlayButton.addTarget(self, action: #selector(pausePlayButtonClick(button:)), for: .touchUpInside)
        
        let finishSelector = #selector(handleDidFinishPlaying(notification:))
        NotificationCenter.default.addObserver(self, selector: finishSelector, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        let failureSelector = #selector(handleFailure(notification:))
        NotificationCenter.default.addObserver(self, selector: failureSelector, name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        let backgroundSelector = #selector(didEnterBackground(notification:))
        NotificationCenter.default.addObserver(self, selector: backgroundSelector, name: .UIApplicationDidEnterBackground, object: nil)
        // TODO: background and foreground notifications??
    }
    
    deinit {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        removeObserver(self, forKeyPath: #keyPath(player.rate), context: nil)
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = bounds
    }
    
    // MARK: Notifications
    
    @objc private func handleDidFinishPlaying(notification: Notification) {
        didReachEndOfVideo = true
        delegate?.videoPlayerViewDidFinishPlaying?(self)
    }
    
    @objc private func handleFailure(notification: Notification) {
        spinner.stopAnimating()
        // TODO: - Determine error
        delegate?.videoPlayerView?(self, didFailWithError: NSError())
    }
    
    @objc private func didEnterBackground(notification: Notification) {
        player?.pause()
    }
    
    // MARK: Gestures
    
    @objc private func handle(tapGesture: UITapGestureRecognizer) {
        if controlsState == .disabled && videoIsPlaying {
            controlsState = .showPauseButton
        } else if controlsState == .disabled {
            controlsState = .showPlayButton
        } else {
            controlsState = .disabled
        }
        
        set(controlsState: controlsState, animated: true)
    }
    
    // MARK: Actions
    
    @objc private func pausePlayButtonClick(button: UIButton) {
        if player?.rate != 1.0 {
            play()
        } else  {
            pause()
        }
    }
    
    // MARK: Setup
    
    func loadVideo(withPath path: String) {
        guard let path = Bundle.main.path(forResource: path, ofType: "mp4") else {
            // TODO: - Log
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: player)
        layer.insertSublayer(playerLayer!, at: 0)
        setNeedsLayout()
        
        addObserver(self, forKeyPath: #keyPath(player.rate), options: [.new], context: nil)
    }
    
    func playNewVideo(withpath path: String) {
        loadVideo(withPath: path)
        play()
    }
    
    func play() {
        set(controlsState: .disabled, animated: true)
        spinner.startAnimating()
        
        if didReachEndOfVideo {
            player?.seek(to: kCMTimeZero)
        }
        
        player?.play()
    }
    
    func pause() {
        player?.pause()
        set(controlsState: .showPlayButton, animated: true)
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: kCMTimeZero)
    }
    
    // MARK: KVO
    
    func addTimeObservers(times: [NSValue], updateBlock: @escaping (() -> Void)) {
        timeObserverToken = player?.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            updateBlock()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(player.rate) {
            if let newRate = change?[.newKey] as? NSNumber {
                if newRate == 1.0 {
                    if spinner.isAnimating {
                        spinner.stopAnimating()
                    }
                } else if newRate == 0.0 {
                    set(controlsState: .showPlayButton, animated: true)
                }
            }
        }
    }
    
    // MARK: State
    
    private func set(controlsState state: ControlsState, animated: Bool) {
        let updateBlock = {
            switch state {
            case .showPlayButton:
                self.pausePlayButton.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
                self.pausePlayButton.alpha = 1.0
            case .showPauseButton:
                self.pausePlayButton.setImage(#imageLiteral(resourceName: "iconPause"), for: .normal)
                self.pausePlayButton.alpha = 1.0
            case .disabled:
                self.pausePlayButton.alpha = 0.0
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                updateBlock()
            }, completion: nil)
        } else {
            updateBlock()
        }
        
    }
    
}
