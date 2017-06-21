//
//  AudioPLayer.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {
    
    var player: AVAudioPlayer!
    
    func playBreathingSound(file: String, ext: String) {
        guard let file: URL = Bundle.main.url(forResource: file, withExtension: ext) else { return }
        do {
            player = try AVAudioPlayer(contentsOf: file, fileTypeHint: nil)
            player!.numberOfLoops = -1
            player!.prepareToPlay()
            player!.play()
            
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
