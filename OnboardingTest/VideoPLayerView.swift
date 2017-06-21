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

protocol VideoPlayerViewDelegate: class {
    func videoPlayerViewDidPause(_ view: VideoPlayerView)
    func videoPlayerViewDidResume(_ view: VideoPlayerView)
    func videoPlayerViewDidClickNextButton(_ view: VideoPlayerView)
    func videoPlayerView(_ view: VideoPlayerView, didFailWithError: Error)
}

// TODO: - KVO for pause play etc
// TODO: - Notifications for end playing and error
// TODO: - Make video player private accessibel

class VideoPlayerView: UIView {

    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    weak var delegate: VideoPlayerViewDelegate?
    
    // ProblemTextViewProperty Give generic frame
    
    // I would move this to the
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
        ab.titleLabel?.font = UIFont.buttonFont()
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
        ab.titleLabel?.font = UIFont.buttonFont()
        ab.addTarget(self, action: #selector(handleNextVideoTapped), for: .touchUpInside)
        ab.layer.cornerRadius = CGFloat.buttonCornerRadius()
        return ab
    }()
    
    let controlsContainerView: UIView = {
        let cc = UIView()
        cc.backgroundColor = .clear
        return cc
    }()
    
    var controlsIsHidden: Bool = true {
        didSet {
            // TODO: - Update visibility of the controls
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = bounds
        controlsContainerView.frame = bounds
    }
    
    func handleNextVideoTapped() {
        player?.pause()
        delegate?.videoPlayerViewDidClickNextButton(self)
        // player?.pause()
        // controlsContainerView.removeFromSuperview()
        // againButton.removeFromSuperview()
        // nextButton.removeFromSuperview()
        // removeFromSuperview()
        // LaunchManager.sharedInstance.getNextScene()
    }
    
    func handleAgainVideoTapped() {
        player?.pause()
        LaunchManager.sharedInstance.playAgain()
    }

    func setUpVideo(withPath: String) {
        guard let path = Bundle.main.path(forResource: withPath, ofType: "mp4") else {
            print("movie not found") //hier een log van Kaira
            return
        }
    
        player = AVPlayer(url: URL(fileURLWithPath: path))
        
        // I figured out why the video wasn't showing: 
        // In the previous implementation you were setting the frame of the view yourself now its being managed by the superview (constraints)
        // Then you would set the playerlayer frame in this method to equal the frame of the view.
        // At the time this method was called the frame was zero and thus we would only hear the audio. 
        // I fixed it by making a playerLayer a property and setting the frame in layoutsubviews to the bounds of this view (its parent).
        // I use bounds because frame is never guarenteed to be correct since it can change for example when you do a scale or rotate.
        // This method is called every time the subviews get layed out (on the end of viewWillAppear, on rotation etc). 
        // THis way playerLayer will always have the correct frame,
        playerLayer = AVPlayerLayer(player: player)
        layer.addSublayer(playerLayer!)
        // Here I mark the view as dirty so layoutSubViews (where the playerlayer its frame gets set) will be triggered on the next runloop
        // A good talk about the whole layout cycle is https://www.youtube.com/watch?v=xjArhdrqAn8
        setNeedsLayout()
    }
    
    //werkt, getest
    func placeProblemTextView(with text: String) {
        controlsContainerView.addSubview(problemTextView)
        problemTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        problemTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        problemTextView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        problemTextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    // I moved this to initialization, visibility of the buttons can for example be handled with the controleIsHidden property
    func setupButtons() {
        
        addSubview(controlsContainerView)
        
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
        
        againButton.isHidden = false
        nextButton.isHidden = false
    }
    
}
