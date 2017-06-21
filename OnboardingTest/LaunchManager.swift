//
//  LaunchManager.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation

//This class determines the flow of all app-scenes. Based on the currentscene (and maybe some other variables such as score) it determines the next scene to be presented. There are numourous scenes such as ShowVideoPlayer, ShowProblemView, ShowScoreEditView, etc. It aslo uses currentProcess to determine which proces is going on at a specific moment (f.e. the onboarding-proces or tappingWithMerel). We discussed it would be better to make separate launchmanagers for the different processes to be handled.
//I use the SceneLauncher-class to handle the presentation of them with animation, but in the new form I made new separate viewControllers for video, score and problem. This launchmanager still has to be adapted to handle the scenes from their viewController (I didn't made that change yet, it now still uses the SceneLauncher-class).
//Launchmanager uses the Scene-enum to get to the properties belonging to  the currentscene such as the videoPath, the videoDescription (which is used as text in the messageView in the SceneLauncher) and videoTextBeginTimes and videoTextEndTimes to determine the exact timeframes of the texts regarding the problem which is tapped on, to be be shown in the VideoPLayer.

class LaunchManager {

    let videoPlayer = VideoController()
    
    static let sharedInstance = LaunchManager()
    let sceneLauncher = SceneLauncher()
    
    var currentScene: Scene = .none //temp terugzetten naar .none
    var currentProces: CurrentProces = .onboardingProces
    
    func getNextScene() {
        switch (currentScene, currentProces) {
            
        //All scenes onboardingProces
        case (.none, .onboardingProces):
            currentScene = .onboarding1
            sceneLauncher.ShowVideoPlayer(withPath: self.currentScene.rawValue, withMessage: self.currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.onboarding1, .onboardingProces):
            currentScene = .onboarding2
            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.onboarding2, .onboardingProces):
            currentScene = .onboarding3
            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.onboarding3, .onboardingProces):
            currentScene = .probleemIntroductie
            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.probleemIntroductie, .onboardingProces):
            sceneLauncher.removeAllViews()
            currentScene = .probleemInvullen
            sceneLauncher.showProblemView(withMessage: currentScene.videoDescription)
        case (.probleemInvullen, .onboardingProces):
            currentScene = .scoresysteemUitleg
            sceneLauncher.removeAllViews()
            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.scoresysteemUitleg, .onboardingProces):
            currentScene = .scoreInvullen
            sceneLauncher.removeAllViews()
            sceneLauncher.showScoreEditView(withMessage: currentScene.videoDescription)
        case (.scoreInvullen, .onboardingProces):
            sceneLauncher.removeAllViews()
            currentScene = .opstartzin
            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: currentScene.videoTextBeginTimes, withTextEndTimes: currentScene.videoTextEndTimes)
        case (.opstartzin, .onboardingProces):
            sceneLauncher.removeAllViews()
            currentScene = .eersteTapsessie
            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: currentScene.videoTextBeginTimes, withTextEndTimes: currentScene.videoTextEndTimes)
        case (.eersteTapsessie, .onboardingProces):
            sceneLauncher.removeAllViews()
            currentScene = .tweedeKeerScoreInvullen
            sceneLauncher.showScoreEditView(withMessage: currentScene.videoDescription)
            //etc
            
        //All scenes tappingWithMerelProces
        case (.none, .tappingWithMerelProces):
            sceneLauncher.removeAllViews()
            currentScene = .probleemInvullen
            sceneLauncher.showProblemView(withMessage: currentScene.videoDescription)
        case (.probleemInvullen, .tappingWithMerelProces):
            sceneLauncher.removeAllViews()
            currentScene = .scoreInvullen
            sceneLauncher.showScoreEditView(withMessage: currentScene.videoDescription)
        case (.scoreInvullen, .tappingWithMerelProces):
            sceneLauncher.removeAllViews()
            currentScene = .opstartzin
            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: currentScene.videoTextBeginTimes, withTextEndTimes: currentScene.videoTextEndTimes)
        //etc
        default:
            currentScene = .alsHetNietWerkt
        }
    }
    
    func playAgain() {
        sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
    }
}

