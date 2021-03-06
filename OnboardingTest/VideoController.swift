//
//  VideoController.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 21-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit

protocol VideoControllerDelegate: class {
    func videoControllerNextButtonClick(_ controller: VideoController)
}

class VideoController: UIViewController {
    
    @IBOutlet weak var messageView: MessageView!
    
    @IBOutlet weak var videoView: VideoplayerView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    private let video: Scene
    
    weak var delegate: VideoControllerDelegate?
    
    private var firstLoad = true
    
    // TODO: - Make view controller independent of Scene
    init(video: Scene = .alsHetNietWerkt) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.setTitle("Ga verder", for: .normal)
        nextButton.alpha = 0.0
        
        // Setup for animation
        videoView.alpha = 0
        
        videoView.delegate = self
        videoView.loadVideo(withPath: video.rawValue)
        messageView.set(message: video.videoDescription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstLoad {
            firstLoad = false
            play(video: video)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // TODO: - Will this look good on different device sizes
        nextButton.layer.cornerRadius = 3
    }

    private func play(video: Scene) {
        UIView.animate(withDuration: 0.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.messageView.alpha = 1.0
        }, completion: { completed in
            UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.videoView.alpha = 1.0
                self.messageView.alpha = 0.0
                self.nextButton.alpha = 1.0
            }, completion: { completed in
                self.videoView.play()
            })
        })
    }
    
    @IBAction func nextButtonClick(_ sender: UIButton) {
        delegate?.videoControllerNextButtonClick(self)
    }
    
}

extension VideoController: VideoplayerViewDelegate {
    
    func videoPlayerViewDidStartPlaying(_ view: VideoplayerView) {
        print("Start")
    }
    
    func videoPlayerViewDidResume(_ view: VideoplayerView) {
        print("Resume")
    }
    
    func videoPlayerViewDidPause(_ view: VideoplayerView) {
        print("Paused")
    }
    
    func videoPlayerViewDidFinishPlaying(_ view: VideoplayerView) {
        print("Finished")
    }
    
    func videoPlayerView(_ view: VideoplayerView, didFailWithError error: Error) {
        print("Error")
    }
}
