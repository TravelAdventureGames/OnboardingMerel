//
//  ViewController.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

//This is the vc which is connected to the only storyboard in this app.The onboardingproces will be launched in production from appDelegate, but for the time being this vc is handy for testing

class ViewController: UIViewController {
    
    let verb: String = "spring"
    let problem: String = " nooit echt helemaal voor mezelf in de bres"
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //The beginstate is set by defining the currentproces and the current startingscene. This has to be moved to appDelagate at some time in the future.
//        LaunchManager.sharedInstance.currentScene = .none
//        LaunchManager.sharedInstance.currentProces = .onboardingProces
//        LaunchManager.sharedInstance.getNextScene()
    }
    //I allready made a function to transform the verb and problem which are filled in by the user (or coming from storage in coredata) to the sentence which is used by Merel. It is not used yet, but works fine.
    func produceTapsentence1() -> String {
        let verbArray = verb.components(separatedBy: " ")
        
        //Er is een me-woord
        if verbArray.count > 1 {
            let meWerkwoord = verbArray[1]
            return "Ondanks dat ik \(meWerkwoord) \(problem) \(verbArray[0]), toch accepteer ik mezelf en waardeer ik mezelf precies zoals ik ben.)"
        } else {
            return "Ondanks dat ik \(problem) \(verbArray[0]), toch accepteer ik mezelf en waardeer ik mezelf precies zoals ik ben)"
        }
        
    }
    
    //Ondanks dat ik bang om in het openbaar te spreken ben
    //Ondanks dat ik me niet lekker voel
    //Ondanks dat ik pijn in mijn rug heb
    //Ondanks dat ik erg onzeker ben
    //Ondanks dat ik een intense haat tegen mijn vader koester
    //ondanks dat ik mezelf een enorme loser vind
    //ondanks dat ik
    
    
}
