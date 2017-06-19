//
//  VideoPLayerView.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

enum VideoPlayerError {
    case unknown
}

protocol VideoPlayerViewDelegate: class {
    //    func videoPlayerViewDidPausewVideo(_ view: VideoPlayerView)
    //    func videoPlayerViewDidEndVideo(_ view: VideoPlayerView)
    //    func videoPlayerView(_ view: VideoPlayerView, didFailWithError: VideoPlayerError)
    func videoPlayerViewDidClickNextButton(_ view: VideoPlayerView)
}

class VideoPlayerView: UIView {
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    let problemTextView: UITextView = {
        let ptv = UITextView()
        ptv.translatesAutoresizingMaskIntoConstraints = false
        ptv.textColor = UIColor.normalTextColor()
        ptv.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: 200)
        ptv.textAlignment = .center
        ptv.backgroundColor = .clear
        ptv.isEditable = false
        ptv.isScrollEnabled = false
        ptv.text = "Dit is een tesje ter test zeg maat dat je het weet he knakker!"
        return ptv
    }()
    
    let againButton: UIButton = {
        let ab = UIButton(type: UIButtonType.system)
        ab.isHidden = true
        ab.backgroundColor = UIColor.buttonBackgroundColor()
        ab.isHidden = true
        ab.setTitleColor(UIColor.buttonTextColor(), for: .normal)
        ab.setTitle("Speel nogmaals", for: .normal)
        ab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.addTarget(self, action: #selector(handleAgainVideoTapped), for: .touchUpInside)
        ab.layer.cornerRadius = 3
        return ab
    }()
    
    let nextButton: UIButton = {
        
        let ab = UIButton(type: UIButtonType.system)
        ab.isHidden = true
        ab.backgroundColor = UIColor.buttonBackgroundColor()
        ab.isHidden = true
        ab.setTitleColor(UIColor.buttonTextColor(), for: .normal)
        ab.setTitle("Ga verder", for: .normal)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        ab.addTarget(self, action: #selector(handleNextVideoTapped), for: .touchUpInside)
        ab.layer.cornerRadius = 3
        return ab
    }()
    
    
    let controlsContainerView: UIView = {
        let cc = UIView()
        cc.backgroundColor = .clear
        return cc
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        
    }
    
    func handleNextVideoTapped() {
        player.pause()
        controlsContainerView.removeFromSuperview()
        againButton.removeFromSuperview()
        nextButton.removeFromSuperview()
        removeFromSuperview()
        LaunchManager.sharedInstance.getNextScene()
    }
    
    func handleAgainVideoTapped() {
        player.pause()
        LaunchManager.sharedInstance.playAgain()
    }
    
    
    func setUpVideo(withPath: String) {
        guard let path = Bundle.main.path(forResource: withPath, ofType: "mp4") else {
            print("movie not found") //hier een log van Kaira
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        
        let playerLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = self.frame
        
        setupButtons()
        
    }
    
    //werkt, getest
    func placeProblemTextView(with text: String) {
        controlsContainerView.addSubview(problemTextView)
        problemTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        problemTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        problemTextView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        problemTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupButtons() {
        
        addSubview(controlsContainerView)
        controlsContainerView.frame = self.frame
        
        controlsContainerView.addSubview(self.againButton)
        
        againButton.leftAnchor.constraint(equalTo: controlsContainerView.leftAnchor, constant: 40).isActive = true
        againButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        againButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        againButton.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -30).isActive = true
        
        
        controlsContainerView.addSubview(self.nextButton)
        nextButton.rightAnchor.constraint(equalTo: controlsContainerView.rightAnchor, constant: -40).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: -30).isActive = true
        
    }
    
    
    
    
}

