//
//  ScoreView.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

class ScoreView: UIView {
    
    let bw: CGFloat = 3
    
    let scoreSlider: UISlider = {
        let sl = UISlider()
        sl.translatesAutoresizingMaskIntoConstraints = false
        sl.minimumValue = 0
        sl.maximumValue = 10
        sl.value = 1.0
        sl.addTarget(self, action: #selector(scoreChanged), for: .valueChanged)
        sl.addTarget(self, action: #selector(didEndScoreChange), for: ([.touchUpInside, .touchUpOutside, .touchCancel]))
        return sl
    }()
    
    let currentScoreTitle: UILabel = {
        let cst = UILabel()
        cst.translatesAutoresizingMaskIntoConstraints = false
        cst.textColor = .white
        cst.font = UIFont.boldSystemFont(ofSize: 14)
        cst.textAlignment = .center
        cst.text = "Huidige score"
        return cst
    }()
    
    let currentScoreLabel: UILabel = {
        let csl = UILabel()
        csl.translatesAutoresizingMaskIntoConstraints = false
        csl.textColor = .white
        csl.textAlignment = .center
        csl.font = UIFont.monospacedDigitSystemFont(ofSize: 38, weight: 400)
        csl.layer.borderWidth = Border.standardWidth
        csl.layer.borderColor = UIColor.white.cgColor
        return csl
    }()
    
    let previousScoreTitle: UILabel = {
        let cst = UILabel()
        cst.translatesAutoresizingMaskIntoConstraints = false
        cst.textColor = .white
        cst.font = UIFont.boldSystemFont(ofSize: 14)
        cst.textAlignment = .center
        cst.text = "Vorige score"
        return cst
    }()
    
    let previousScoreLabel: UILabel = {
        let csl = UILabel()
        csl.translatesAutoresizingMaskIntoConstraints = false
        csl.textColor = .white
        csl.textAlignment = .center
        csl.font = UIFont.monospacedDigitSystemFont(ofSize: 38, weight: 400)
        csl.layer.borderWidth = Border.standardWidth
        csl.layer.borderColor = UIColor.white.cgColor
        return csl
    }()
    
    
    let nextButton: UIButton = {
        let ab = UIButton(type: UIButtonType.system)
        ab.backgroundColor = UIColor.buttonBackgroundColor()
        ab.setTitleColor(UIColor.buttonTextColor(), for: .normal)
        ab.setTitle("Ga verder", for: .normal)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        ab.addTarget(self, action: #selector(handleNextVideoTapped), for: ([.touchUpInside,.touchUpOutside]))
        ab.layer.cornerRadius = 3
        return ab
    }()
    
    let smileView: SmileView = {
        let sm = SmileView()
        sm.translatesAutoresizingMaskIntoConstraints = false
        return sm
    }()
    
    
    
    func handleNextVideoTapped() {
        LaunchManager.sharedInstance.getNextScene()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        smileView.mouthCurvature = Double(-1 + scoreSlider.value/5)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSlider() {
        
        self.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        
        self.addSubview(scoreSlider)
        scoreSlider.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -80).isActive = true
        scoreSlider.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        scoreSlider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        scoreSlider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        scoreSlider.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let thumbImageNormal = #imageLiteral(resourceName: "sliderButton")
        let size = CGSize(width: 30, height: 50)
        UIGraphicsBeginImageContext(size)
        thumbImageNormal.draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        scoreSlider.setThumbImage(resizeImage, for: .normal)
        
        let sliderMax = #imageLiteral(resourceName: "sliderMax")
        let maxSize = CGSize(width: 200, height: 30)
        UIGraphicsBeginImageContext(maxSize)
        sliderMax.draw(in: CGRect(x:0, y:0, width:maxSize.width, height:maxSize.height))
        let maxResizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        scoreSlider.setMaximumTrackImage(maxResizeImage, for: .normal)
        
        let sliderMinImg = #imageLiteral(resourceName: "sliderMin")
        let minSize = CGSize(width: 200, height: 30)
        UIGraphicsBeginImageContext(minSize)
        sliderMinImg.draw(in: CGRect(x:0, y:0, width:minSize.width, height:minSize.height))
        let minResizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        scoreSlider.setMinimumTrackImage(minResizeImage, for: .normal)
        
        self.addSubview(currentScoreLabel)
        currentScoreLabel.bottomAnchor.constraint(equalTo: scoreSlider.topAnchor, constant: -60).isActive = true
        currentScoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 60).isActive = true
        currentScoreLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        currentScoreLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        currentScoreLabel.text = "\(scoreSlider.value)"
        
        self.addSubview(currentScoreTitle)
        currentScoreTitle.bottomAnchor.constraint(equalTo: currentScoreLabel.topAnchor, constant: -10).isActive = true
        currentScoreTitle.centerXAnchor.constraint(equalTo: currentScoreLabel.centerXAnchor).isActive = true
        currentScoreTitle.widthAnchor.constraint(equalTo: currentScoreLabel.widthAnchor).isActive = true
        currentScoreTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(previousScoreLabel)
        previousScoreLabel.bottomAnchor.constraint(equalTo: scoreSlider.topAnchor, constant: -60).isActive = true
        previousScoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -60).isActive = true
        previousScoreLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        previousScoreLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        previousScoreLabel.text = "0.0"
        
        self.addSubview(previousScoreTitle)
        previousScoreTitle.bottomAnchor.constraint(equalTo: previousScoreLabel.topAnchor, constant: -10).isActive = true
        previousScoreTitle.centerXAnchor.constraint(equalTo: previousScoreLabel.centerXAnchor).isActive = true
        previousScoreTitle.widthAnchor.constraint(equalTo: previousScoreLabel.widthAnchor).isActive = true
        previousScoreTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        placeSmileView()
        
        
    }
    
    func placeSmileView() {
        self.addSubview(smileView)
        smileView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        smileView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        smileView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        smileView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
    }
    
    func scoreChanged() {
        currentScoreLabel.text = "\((round(10*scoreSlider.value)/10))"
        
        
        
    }
    
    func didEndScoreChange() {
        let mouthAndEyebrowTilt = Double(-1 + scoreSlider.value/5)
        print(mouthAndEyebrowTilt)
        smileView.removeEyebouwAndMouthPaths()
        smileView.mouthCurvature = mouthAndEyebrowTilt
        smileView.eyeBrowTilt = mouthAndEyebrowTilt
        
    }
    
}

