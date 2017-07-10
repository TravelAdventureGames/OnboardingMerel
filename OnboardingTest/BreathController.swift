//
//  BreathController.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit
import AVFoundation

// A vc to handle the breathing excersize. It has a slider to be able to change the length of the breath-out. Breathing in always takes 3 seconds. The length of the animation is adapted to the length of the breath-out. The vc gives a night background and moon between 18-09 hrs, and a blue sky with sun during daytime. Sentences to show and audio to play must be set in setSoundsAndTextOnBreath().

protocol BreathControllerDelegate: class {
    func didPopBreathController(_ controller: BreathController)
}

class BreathController: UIViewController {
    
    let player = AudioPlayer()
    
    var audioToPlay: [String] = []
    
    var sentencesToShow: [String] = []
    
    var soundOn: Bool = true
    
    let totalNumberOfBreaths = 7
    
    weak var delegate: BreathControllerDelegate?
    
    var breathNumber: Int = 0 {
        didSet {
            print(breathNumber)
            if breathNumber < totalNumberOfBreaths {
                setSoundsAndTextOnBreath()
                animateOnBreath()
            } else {
                self.startSessionButton.isHidden = false
                startSessionButton.setTitle("Nieuwe sessie?", for: .normal)
                fadeInSliderAndLabels()
                UIView.animate(withDuration: 1.0, animations: {
                    self.startSessionButton.alpha = 1.0
                }) { (ready) in
                    
                }
            }
        }
    }
    
    let shadeView: UIView = {
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return sv
    }()

    let exitButton: UIButton = {
        let eb = UIButton(type: UIButtonType.system)
        let img = #imageLiteral(resourceName: "cancelImage").withRenderingMode(.alwaysTemplate)
        eb.setImage(img, for: .normal)
        eb.tintColor = .white
        eb.translatesAutoresizingMaskIntoConstraints = false
        eb.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return eb
    }()
    
    let sunMoonView: UIImageView = {
        let bv = UIImageView()
        bv.contentMode = .scaleAspectFit
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    let amountOfBreathSlider: UISlider = {
        let aob = UISlider()
        aob.translatesAutoresizingMaskIntoConstraints = false
        aob.minimumValue = 5
        aob.maximumValue = 8
        aob.value = 5.0
        aob.minimumTrackTintColor = UIColor.buttonBackgroundColor()
        aob.maximumTrackTintColor = .white
        aob.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
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
    
    let soundOrTextButton: UIButton = {
        let sb = UIButton(type: UIButtonType.system)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.backgroundColor = .clear
        sb.setImage(#imageLiteral(resourceName: "soundon").withRenderingMode(.alwaysTemplate), for: .normal)
        sb.addTarget(self, action: #selector(switchSoundState), for: .touchUpInside)
        sb.contentMode = .scaleAspectFill
        sb.tintColor = .white
        return sb
    }()
    
    let textLabel: UILabel = {
        let tl = UILabel()
        tl.backgroundColor = .clear
        tl.textAlignment = .center
        tl.textColor = .white
        tl.font = UIFont.boldSystemFont(ofSize: 24)
        tl.numberOfLines = 0
        tl.translatesAutoresizingMaskIntoConstraints = false
        return tl
    }()
    
    let secondsLabel: UILabel = {
        let tl = UILabel()
        tl.backgroundColor = .clear
        tl.textAlignment = .center
        tl.textColor = .white
        tl.numberOfLines = 0
        tl.translatesAutoresizingMaskIntoConstraints = false
        return tl
    }()
    
    let sliderLabel: UILabel = {
        let tl = UILabel()
        tl.backgroundColor = .clear
        tl.textAlignment = .center
        tl.textColor = .white
        tl.font = UIFont.italicSystemFont(ofSize: 13)
        tl.numberOfLines = 0
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.text = "Bepaal de lengte van je uitademing"
        return tl
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
    }
    
    func itIsDayTime() -> Bool {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let daytime = 19 >= hour && hour > 08
        return daytime
    }
    
    func sliderValueChanged() {
        secondsLabel.text = "\((round(10*amountOfBreathSlider.value)/10)) sec"
    }
    // If text or audio-filenames are set here, they are displayed / played during the excersize on the specified breathnumber
    func setSoundsAndTextOnBreath() {
        switch breathNumber {
        case 1:
            audioToPlay = ["ademin", "ademuit"]
            sentencesToShow = ["Adem in", "En adem uit"]
        case 3:
            audioToPlay = ["ademDoorNeus", "ademUitDoorMond"]
            sentencesToShow = ["Adem in door je neus", "En adem uit door je mond"]
        case 5:
            audioToPlay = ["zuigJeLongen"]
            sentencesToShow = ["Zuig je longen vol lucht.."]
        case 6:
            audioToPlay = ["ontspanJeSpieren"]
            sentencesToShow = ["Ontspan je spieren bij iedere uitademing"]
        default:
            audioToPlay.removeAll()
            sentencesToShow.removeAll()
        }
    }
    
    func fadeOutSliderAndLabels() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.secondsLabel.alpha = 0.0
            self.amountOfBreathSlider.alpha = 0.0
            self.sliderLabel.alpha = 0.0
        }, completion: nil)
    }
    
    func fadeInSliderAndLabels() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.secondsLabel.alpha = 1.0
            self.amountOfBreathSlider.alpha = 1.0
            self.sliderLabel.alpha = 1.0
        }, completion: nil)
    }
    
    func breathInTextLabel() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.textLabel.alpha = 1.0
        }) { (fadedIn) in
            UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseInOut, animations: {
                self.textLabel.alpha = 0.0
            }, completion: nil)
        }
    }
    
    func breathOutTextLabel() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.textLabel.alpha = 1.0
        }) { (fadedIn) in
            UIView.animate(withDuration: 0.5, delay: CFTimeInterval(self.amountOfBreathSlider.value - 1), options: .curveEaseInOut, animations: {
                self.textLabel.alpha = 0.0
            }, completion: nil)
        }
    }
    
    func animateOnBreath() {
        textLabel.text = nil
        breathInTextLabel()
        setSoundsAndTextOnBreath()
        fadeOutSliderAndLabels()
        
        UIView.animate(withDuration: 3, delay: 1.0, options: .curveEaseInOut, animations: {
            let grow = CGAffineTransform(scaleX: 5.5, y: 5.5)
            let move = CGAffineTransform(translationX: 20, y: -70)
            self.shadeView.backgroundColor = UIColor(white: 0, alpha: 0)
            self.sunMoonView.transform = grow.concatenating(move)
            if self.sentencesToShow.indices.contains(0) {
                self.textLabel.text = self.sentencesToShow[0]
            }
            if self.audioToPlay.indices.contains(0) && self.soundOn {
                self.player.playBreathingSound(file: self.audioToPlay[0], ext: "mp3")
                
            }
            
        }) { (breathInEnded) in
            
            self.breathOutTextLabel()
            self.textLabel.text = nil
            
            UIView.animate(withDuration: TimeInterval(self.amountOfBreathSlider.value), delay: 1.0, options: .curveEaseInOut, animations: {
                let shrink = CGAffineTransform(scaleX: 1, y: 1)
                let moveBack = CGAffineTransform(translationX: 0, y: 0)
                self.sunMoonView.transform = shrink.concatenating(moveBack)
                self.shadeView.backgroundColor = UIColor(white: 0, alpha: 0.2)
                if self.sentencesToShow.indices.contains(1) {
                    self.textLabel.text = self.sentencesToShow[1]
                }
                if self.audioToPlay.indices.contains(1) && self.soundOn {
                    self.player.playBreathingSound(file: self.audioToPlay[1], ext: "mp3")
                    
                }
            }, completion: { (breathOutEnded) in
                self.breathNumber += 1
            })
        }
    }

    func dismissView() {
        player.stopPlaying()
        delegate?.didPopBreathController(self)
        
    }
    
    func startSession() {
        breathNumber = 1
        UIView.animate(withDuration: 1.0, animations: {
            self.startSessionButton.alpha = 0.0
        }) { (ready) in
            self.startSessionButton.isHidden = true
        }
    }
    
    func switchSoundState() {
        if soundOn {
            soundOrTextButton.setImage(#imageLiteral(resourceName: "soundoff").withRenderingMode(.alwaysTemplate), for: .normal)
            soundOn = false
        } else {
            soundOrTextButton.setImage(#imageLiteral(resourceName: "soundon").withRenderingMode(.alwaysTemplate), for: .normal)
            soundOn = true
        }
        
    }
    
    func setUpViews() {
        //set images based on evening/night time or daytime
        var backGroundImage = #imageLiteral(resourceName: "sunBackground1")
        var sunMoonImage = #imageLiteral(resourceName: "croppedSun1")
        
        if itIsDayTime() {
            backGroundImage = #imageLiteral(resourceName: "sunBackground1")
            sunMoonImage = #imageLiteral(resourceName: "sun2")
        } else {
            //#imageLiteral(resourceName: "moonBG2") is ook mooi
            backGroundImage = #imageLiteral(resourceName: "moonBG2-1")
            sunMoonImage = #imageLiteral(resourceName: "moon4")
        }
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        backGroundImage.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        view.addSubview(shadeView)
        shadeView.frame = view.frame
        
        view.addSubview(startSessionButton)
        startSessionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        startSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startSessionButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        startSessionButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        view.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(soundOrTextButton)
        soundOrTextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        soundOrTextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        soundOrTextButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        soundOrTextButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(amountOfBreathSlider)
        amountOfBreathSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountOfBreathSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        amountOfBreathSlider.widthAnchor.constraint(equalToConstant: 250).isActive = true
        amountOfBreathSlider.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let thumbImageNormal = #imageLiteral(resourceName: "sliderButton")
        let size = CGSize(width: 10, height: 30)
        UIGraphicsBeginImageContext(size)
        thumbImageNormal.draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        amountOfBreathSlider.setThumbImage(resizeImage, for: .normal)
        
        view.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: amountOfBreathSlider.bottomAnchor, constant: 35).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(sliderLabel)
        sliderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sliderLabel.bottomAnchor.constraint(equalTo: amountOfBreathSlider.topAnchor, constant: -10).isActive = true
        sliderLabel.widthAnchor.constraint(equalTo: amountOfBreathSlider.widthAnchor).isActive = true
        
        view.addSubview(secondsLabel)
        secondsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        secondsLabel.topAnchor.constraint(equalTo: amountOfBreathSlider.bottomAnchor, constant: 15).isActive = true
        secondsLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        secondsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        secondsLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: 100)
        secondsLabel.text = "\((round(10*amountOfBreathSlider.value)/10)) sec"
        
        view.addSubview(sunMoonView)
        sunMoonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sunMoonView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sunMoonView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sunMoonView.bottomAnchor.constraint(equalTo: startSessionButton.topAnchor, constant: -70).isActive = true
        sunMoonView.image = sunMoonImage
        
        
    }

}
