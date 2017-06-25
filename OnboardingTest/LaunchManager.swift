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

// Notes Kaira:
// Ik heb gekeken naar hoe je de drie nieuwe vc's kan aanspreken vanuit de launchmanager:
// Ik heb dit gedaan door de videocontroller als voorbeeld te nemen.
// Hiervoor heb ik dit artikel voor inspiratie gebruikt: http://irace.me/navigation-coordinators
// Wat heb ik precies gedaan: 
// VideoPlayer regelt alles zelf zolang je hem maar een video geeft bij initialisatie
// Wanneer hij klaar is laat hij aan zijn delegate weten hoe hij is geeindigd (bijv. next button click)
// Omdat de launchmanager fungeert als coordinator is hij de delegate en zal hij op dat moment de currentscene veranderen 
// en de volgende view controller presenteren. 
// Voor het presenteren heb ik een container gebruikt in dit geval UINavigationController. 
// Dankzij een custom transitioning heb je nog steeds de fade in fade out i.p.v de standaard slide naar links.
// Hierdoor heb je automatisch ook support voor een terug button omdat navigationcontroller deze vc's in memory houd totdat 
// we de flow eindiggen en we straks de coordinator voor deze flow op dat moment destroyen.
// Op deze manier is het heel simpel launchmanager reageert op elk event vanuit de view controllers, en houd de statemachine bij om te weten
// waar we ons in de onboarding bevinden.
// De parent (launchmanager) vertelt zijn kinderen (viewcontrollers) wat hij moet doen i.p.v. dat de kinderen de parent vertelen wat hij moet doen.
// Sterker nog de kinderen weten niet eens wie hun parent is. Dit zorgt ervoor dat je ze overal kan hergebruiken.

import UIKit

class LaunchManager: NSObject {
    
    let videoPlayer = VideoController()
    
    // NO need for it to be a singleton anymore, we will create a single reference on launch and then destory the object when the onboarding is finished
    static let sharedInstance = LaunchManager()
    let sceneLauncher = SceneLauncher()
    
    var currentScene: Scene = .none //temp terugzetten naar .none
    var currentProces: CurrentProces = .onboardingProces
    
    init(rootVC: UINavigationController = UINavigationController()) {
        self.navigationController = rootVC
        super.init()
    }
    
    fileprivate var navigationController = UINavigationController()
    
    func getNextScene() {
        switch (currentScene, currentProces) {
            
        //All scenes onboardingProces
        case (.none, .onboardingProces):
            currentScene = .onboarding1
//            sceneLauncher.ShowVideoPlayer(withPath: self.currentScene.rawValue, withMessage: self.currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.onboarding1, .onboardingProces):
            currentScene = .onboarding2
//            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.onboarding2, .onboardingProces):
            currentScene = .onboarding3
//            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.onboarding3, .onboardingProces):
            currentScene = .probleemIntroductie
//            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.probleemIntroductie, .onboardingProces):
            sceneLauncher.removeAllViews()
            currentScene = .probleemInvullen
            sceneLauncher.showProblemView(withMessage: currentScene.videoDescription)
        case (.probleemInvullen, .onboardingProces):
            currentScene = .scoresysteemUitleg
            sceneLauncher.removeAllViews()
//            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
        case (.scoresysteemUitleg, .onboardingProces):
            currentScene = .scoreInvullen
            sceneLauncher.removeAllViews()
            sceneLauncher.showScoreEditView(withMessage: currentScene.videoDescription)
        case (.scoreInvullen, .onboardingProces):
            sceneLauncher.removeAllViews()
            currentScene = .opstartzin
//            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: currentScene.videoTextBeginTimes, withTextEndTimes: currentScene.videoTextEndTimes)
        case (.opstartzin, .onboardingProces):
            sceneLauncher.removeAllViews()
            currentScene = .eersteTapsessie
//            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: currentScene.videoTextBeginTimes, withTextEndTimes: currentScene.videoTextEndTimes)
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
//            sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: currentScene.videoTextBeginTimes, withTextEndTimes: currentScene.videoTextEndTimes)
        //etc
        default:
            currentScene = .alsHetNietWerkt
        }
    }
    
    func playAgain() {
//        sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: []) 
    }
    
    // Called from the app delegate to show the first view controller
    func start() {
        currentScene = .onboarding1
        let videoViewController = VideoController(video: .onboarding1)
        videoViewController.delegate = self
        navigationController.setViewControllers([videoViewController], animated: true)
        navigationController.delegate = self
        navigationController.setNavigationBarHidden(true, animated: false)
    }


}

// MARK: - UINavigationControllerDelegate

extension LaunchManager: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveAnimatedTransitioning()
    }
    
}

// MARK: - VideoControllerDelegate

extension LaunchManager: VideoControllerDelegate {
    
    func videoControllerNextButtonClick(_ controller: VideoController) {
        switch currentScene {
        case .onboarding1:
            currentScene = .onboarding2
            let videoViewController = VideoController(video: currentScene)
            videoViewController.delegate = self
            // TODO: - How to present this view controller have a look at
            // .....s
            navigationController.pushViewController(videoViewController, animated: true)
        default:
            return
            
        }
    }
    
}

// TODO: - Implement routing on events from ProblemViewControllerDelegate
// TODO: - Implement routing from tapping modules etc etc.
