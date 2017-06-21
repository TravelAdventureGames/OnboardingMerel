//
//  VideoController.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 21-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit

// Will communicate to any outside class "Hey I'm done and the user wants to see the next video"
protocol VideoControllerDelegate: class {
    func videoControllerNextButtonClick(_ controller: VideoController)
}

class VideoController: UIViewController {
    
    private let videoView = VideoPlayerView()
    
    private let messageView = MessageView()
    
    private let video: Scene
    
    weak var delegate: VideoControllerDelegate?
    
    private var firstLoad = true
    
    private var showPlayerControls: Bool {
        didSet {
            // Update visibility of player controls
            // This way we can use it in two ways for onboarding or for static video
        }
    }
    
    init(video: Scene = .alsHetNietWerkt, showPlayerControls: Bool = true) {
        self.video = video
        self.showPlayerControls = showPlayerControls
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(messageView)
        view.addSubview(videoView)
        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        videoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        messageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
        messageView.alpha = 0
        videoView.alpha = 0
        
        videoView.delegate = self
        videoView.setUpVideo(withPath: video.rawValue)
        messageView.set(message: video.videoDescription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            firstLoad = false
            play(video: video)
        }
    }

    // This is the same animation that you had just adapted to the vc
    private func play(video: Scene) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.messageView.alpha = 1.0
        }, completion: { completed in
            UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.videoView.alpha = 1.0
                self.messageView.alpha = 0.0
            }, completion: { completed in
                self.videoView.player?.play()
            })
        })
    }

}

extension VideoController: VideoPlayerViewDelegate {
    
    func videoPlayerViewDidClickNextButton(_ view: VideoPlayerView) {
        delegate?.videoControllerNextButtonClick(self)
    }
    
    // Neccesary?
    func videoPlayerViewDidPause(_ view: VideoPlayerView) {
        
    }
    
    // Neccesary?
    func videoPlayerViewDidResume(_ view: VideoPlayerView) {
        
    }
    
    func videoPlayerView(_ view: VideoPlayerView, didFailWithError: Error) {
        // TODO: - We could show alert with a generic error message
    }

}
