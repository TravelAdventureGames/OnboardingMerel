//
//  SceneLauncher.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

// Als het goed is wordt deze class overbodig omdat we nu separate viewControllers hebben voor videoPLayerView, ScoreView en ProblemView en deze ook kunnen aanspreken vanuit de LaunchManager.

class SceneLauncher: NSObject {
    
    let messageLabel: UILabel = {
        let ml = UILabel()
        ml.backgroundColor = .clear
        ml.textColor = UIColor.normalTextColor()
        ml.font = UIFont.boldSystemFont(ofSize: 20)
        ml.translatesAutoresizingMaskIntoConstraints = false
        ml.numberOfLines = 0
        ml.textAlignment = .center
        return ml
    }()
    
    
    func handleNextVideoTapped() {
        print("next buttontapped")
    }
    
    
    func ShowVideoPlayer(withPath: String, withMessage: String, withTextBeginTimes: [Double], withTextEndTimes: [Double]) {
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            keyWindow.addSubview(view)
            view.frame = keyWindow.frame
            
            let videoPlayerView = VideoPlayerView(frame: keyWindow.frame)
            view.addSubview(videoPlayerView)
            videoPlayerView.setUpVideo(withPath: withPath)
            videoPlayerView.isHidden = true
            
            let messageView = UIView(frame: keyWindow.frame)
            view.addSubview(messageView)
            messageView.backgroundColor = .black
            messageView.alpha = 0.0
            
            messageView.addSubview(messageLabel)
            messageLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor, constant: 0).isActive = true
            messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor, constant: 0).isActive = true
            messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            messageLabel.text = withMessage
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                messageView.alpha = 1.0
                
            }, completion: { (completed) in
                
                UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    messageView.alpha = 0.0
                    videoPlayerView.isHidden = false
                    videoPlayerView.againButton.isHidden = false
                    videoPlayerView.nextButton.isHidden = false
                    
                    
                    
                }, completion: { (completed) in
                    
                    messageView.removeFromSuperview()
                    videoPlayerView.againButton.isHidden = false
                    videoPlayerView.nextButton.isHidden = false
                    videoPlayerView.player?.play()
                    
                })
            })
            
        }
        
    }
    
    func removeAllViews() {
        if let keyWindow = UIApplication.shared.keyWindow {
            for view in keyWindow.subviews {
                view.removeFromSuperview()
            }
        }
    }
    
    func showProblemView(withMessage: String) {
        
        if let keyWindow = UIApplication.shared.keyWindow {
            print("Im here still")
            let view = UIView(frame: keyWindow.frame)
            keyWindow.addSubview(view)
            view.frame = keyWindow.frame
            
            let problemView = ProblemView(frame: keyWindow.frame)
            view.addSubview(problemView)
            problemView.setUpViews()
            problemView.isHidden = true
            
            let messageView = UIView(frame: keyWindow.frame)
            view.addSubview(messageView)
            messageView.backgroundColor = .black
            messageView.alpha = 0.0
            
            messageView.addSubview(messageLabel)
            messageLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor, constant: 0).isActive = true
            messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor, constant: 0).isActive = true
            messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            messageLabel.text = withMessage
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                messageView.alpha = 1.0
                
            }, completion: { (completed) in
                problemView.isHidden = false
                UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    messageView.alpha = 0.0
                    
                    
                }, completion: { (completed) in
                    
                    messageView.removeFromSuperview()
                    
                    
                })
            })
            
            
        }
    }
    
    func showScoreEditView(withMessage: String) {
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            keyWindow.addSubview(view)
            view.frame = keyWindow.frame
            
            let scoreView = ScoreView(frame: keyWindow.frame)
            view.addSubview(scoreView)
            scoreView.setupSlider()
            scoreView.isHidden = true
            
            let messageView = UIView(frame: keyWindow.frame)
            view.addSubview(messageView)
            messageView.backgroundColor = .black
            messageView.alpha = 0.0
            
            messageView.addSubview(messageLabel)
            messageLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor, constant: 0).isActive = true
            messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor, constant: 0).isActive = true
            messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            messageLabel.text = withMessage
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                messageView.alpha = 1.0
                
            }, completion: { (completed) in
                scoreView.isHidden = false
                UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    messageView.alpha = 0.0
                    
                    
                }, completion: { (completed) in
                    
                    messageView.removeFromSuperview()
                    
                    
                })
            })
            
            
        }
        
    }
    
}


