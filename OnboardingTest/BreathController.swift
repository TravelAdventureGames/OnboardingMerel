//
//  BreathController.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit
import AVFoundation

// A vc to handle the breathing excersize. It doesnt do anything except form displaying. It has a slider to be able to change the length of the breaths. It's going to produce an animation accompanied by the sound of Merel's voice and her breathing. I allready made a separate AudioPLayer-class for that purpose in the Helper-group.

class BreathController: UIViewController {
    
    let exitButton: UIButton = {
        let eb = UIButton(type: UIButtonType.system)
        let img = #imageLiteral(resourceName: "cancelImage").withRenderingMode(.alwaysTemplate)
        eb.setImage(img, for: .normal)
        eb.tintColor = .black
        eb.translatesAutoresizingMaskIntoConstraints = false
        eb.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return eb
    }()
    
    let balloonView: UIImageView = {
        let bv = UIImageView()
        bv.contentMode = .scaleAspectFill
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    let amountOfBreathSlider: UISlider = {
        let aob = UISlider()
        aob.translatesAutoresizingMaskIntoConstraints = false
        aob.minimumValue = 0
        aob.maximumValue = 10
        aob.value = 1.0
        aob.minimumTrackTintColor = UIColor.buttonBackgroundColor()
        aob.maximumTrackTintColor = .black
        return aob
    }()
    
    let startSessionButton: UIButton = {
        let sb = UIButton(type: UIButtonType.system)
        sb.backgroundColor = UIColor.buttonBackgroundColor()
        sb.setTitleColor(UIColor.buttonTextColor(), for: .normal)
        sb.addTarget(self, action: #selector(startSession), for: .touchUpInside)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.setTitle("Start sessie", for: .normal)
        sb.titleLabel?.font = UIFont.buttonFont()
        sb.layer.cornerRadius = CGFloat.buttonCornerRadius()
        return sb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func startSession() {
        //animateballon and startaudioplayer
    }
    
    
    func setUpViews() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        #imageLiteral(resourceName: "backgroundBreath").draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        view.addSubview(startSessionButton)
        startSessionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        startSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startSessionButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        startSessionButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(amountOfBreathSlider)
        amountOfBreathSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountOfBreathSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        amountOfBreathSlider.widthAnchor.constraint(equalToConstant: 250).isActive = true
        amountOfBreathSlider.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(balloonView)
        balloonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        balloonView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        balloonView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        balloonView.bottomAnchor.constraint(equalTo: startSessionButton.bottomAnchor, constant: -90).isActive = true
        balloonView.image = #imageLiteral(resourceName: "balloon")
    }

}
