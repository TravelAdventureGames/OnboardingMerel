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

// Notes Martijn:
// Ik heb delegate-functies gemaakt voor nextbuttonclicks in de ScoreController en in de ProblemController
// Op een click wordt altijd dezelfde hoofd-functie gecalled: getNextScene()
// In getNextScene() wordt geswitched op currentProces. Een volgende scene hangt immers af van het proces waarin de gebruiker zich bevindt
// Voor ieder proces (onboardingProces, TappingWithMerel) heb ik een separate functie gecreeerd die switched op currentScene. Iedere scene binnen een proces definieert immers de volgende scene!
// Binnen iedere case (een scene) wordt een functie gecalled om de betreffende VC vanuit de navigationcontroller te pushen. Iedere VC (VideoController, ScoreController en Problemcontroller) heeft een eigen functie (presentScoreController, presentVideoController, etc).

import UIKit

class LaunchManager: NSObject {
    
    let videoPlayer = VideoController()
    
    // NO need for it to be a singleton anymore, we will create a single reference on launch and then destory the object when the onboarding is finished
    static let sharedInstance = LaunchManager()
    let sceneLauncher = SceneLauncher()
    
    var currentScene: Scene = .none //temp terugzetten naar .none
    var currentProces: CurrentProces = .onboardingProces
    
    fileprivate var navigationController = UINavigationController()
    
    init(rootVC: UINavigationController = UINavigationController()) {
        self.navigationController = rootVC
        super.init()
    }
    
    func getNextSceneOnboarding() {
        switch currentScene {
        case .none:
            currentScene = .onboarding1
            presentVideoController(currentScene: currentScene)
        case .onboarding1:
            currentScene = .onboarding2
            presentVideoController(currentScene: currentScene)
        case .onboarding2:
            currentScene = .onboarding3
            presentVideoController(currentScene: currentScene)
        case .onboarding3:
            currentScene = .probleemIntroductie
            presentVideoController(currentScene: currentScene)
        case .probleemIntroductie:
            sceneLauncher.removeAllViews()
            currentScene = .probleemInvullen
            presentProblemController(scene: currentScene)
        case .probleemInvullen:
            currentScene = .scoresysteemUitleg
            sceneLauncher.removeAllViews()
            presentVideoController(currentScene: currentScene)
        case .scoresysteemUitleg:
            currentScene = .scoreInvullen
            sceneLauncher.removeAllViews()
            presentScoreController(scene: currentScene)
        case .scoreInvullen:
            sceneLauncher.removeAllViews()
            currentScene = .opstartzin
            presentVideoController(currentScene: currentScene)
        case .opstartzin:
            sceneLauncher.removeAllViews()
            currentScene = .eersteTapsessie
            presentVideoController(currentScene: currentScene)
        case .eersteTapsessie:
            sceneLauncher.removeAllViews()
            currentScene = .tweedeKeerScoreInvullen
            presentScoreController(scene: currentScene)
            //etc
        default: break
            
        }
    }
    
    func getNextSceneTappingWithMerel() {
        switch currentScene {
        case .none:
            sceneLauncher.removeAllViews()
            currentScene = .probleemInvullen
            presentVideoController(currentScene: currentScene)
        case .probleemInvullen:
            sceneLauncher.removeAllViews()
            currentScene = .scoreInvullen
            presentScoreController(scene: currentScene)
        case .scoreInvullen:
            sceneLauncher.removeAllViews()
            currentScene = .opstartzin
            presentVideoController(currentScene: currentScene)
            // etc etc
        default:
            break
            
        }
        
    }
    
    func getNextScene() {
        switch currentProces {
        case .onboardingProces:
            getNextSceneOnboarding()
        case .tappingWithMerelProces:
            getNextSceneTappingWithMerel()
        }
        

    }
    
    func playAgain() {
        sceneLauncher.ShowVideoPlayer(withPath: currentScene.rawValue, withMessage: currentScene.videoDescription, withTextBeginTimes: [], withTextEndTimes: [])
    }
    
    // Called from the app delegate to show the first view controller
    func start() {
        currentScene = .onboarding1
        let videoViewController = BreathController()
        //videoViewController.delegate = self
        navigationController.setViewControllers([videoViewController], animated: true)
        navigationController.delegate = self
        navigationController.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    func presentVideoController(currentScene: Scene) {
        let videoViewController = VideoController(video: currentScene)
        videoViewController.delegate = self
        navigationController.pushViewController(videoViewController, animated: true)
    }
    //scene not used because vc is always the same?
    func presentScoreController(scene: Scene) {
        let scoreController = ScoreController()
        scoreController.delegate = self
        navigationController.pushViewController(scoreController, animated: true)
    }
    //scene not used because vc is always the same?
    func presentProblemController(scene: Scene) {
        let problemController = ProblemController()
        problemController.delegate = self
        navigationController.pushViewController(problemController, animated: true)
        
        
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
        getNextScene()
//        switch currentScene {
//        case .onboarding1:
//            currentScene = .onboarding2
//            let videoViewController = VideoController(video: currentScene)
//            videoViewController.delegate = self
//            // TODO: - How to present this view controller have a look at
//            // .....s
//            navigationController.pushViewController(videoViewController, animated: true)
//        default:
//            return
//            
//        }
    }
}

// MARK: - ScoreControllerDelegate

extension LaunchManager: ScoreControllerDelegate {
    func scoreControllerNextButtonClick(_ controller: ScoreController) {
        getNextScene()
    }
}

// MARK: - ProblemControllerDelegate

extension LaunchManager: ProblemControllerDelegate {
    func problemControllerNextButtonClick(_ view: ProblemController) {
        getNextScene()
    }
}

// TODO: - Implement routing on events from ProblemViewControllerDelegate
// TODO: - Implement routing from tapping modules etc etc.
