//
//  AudioPLayer.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import AVFoundation

//ADDED
class AudioPlayer {
    
    var player: AVAudioPlayer!
    
    func playBreathingSound(file: String, ext: String) {
        guard let file: URL = Bundle.main.url(forResource: file, withExtension: ext) else {
            print("error")
            return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: file)
            guard let player = player else { return }
            
            player.play()
            
        } catch _ {
            //catch error
            return
        }
        
    }
    
    func stopPlaying() {
        if player != nil {
            player.stop()
            player = nil
        }
    }
    
    
}
