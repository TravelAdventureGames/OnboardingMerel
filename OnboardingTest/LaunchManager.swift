//
//  LaunchManager.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

//ADDED
// Alle schermen worden gepresenteerd en evt. gepopped vanuit de Launchmanager.
// Hoe verloopt dit proces precies?


class LaunchManager: NSObject {
    
    var currentScene: Scene = .none
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
            currentScene = .probleemInvullen
            presentProblemController(scene: currentScene)
        case .probleemInvullen:
            currentScene = .scoresysteemUitleg
            presentVideoController(currentScene: currentScene)
        case .scoresysteemUitleg:
            currentScene = .scoreInvullen
            presentScoreController(scene: currentScene)
        case .scoreInvullen:
            currentScene = .opstartzin
            presentVideoController(currentScene: currentScene)
        case .opstartzin:
            currentScene = .eersteTapsessie
            presentVideoController(currentScene: currentScene)
        case .eersteTapsessie:
            currentScene = .tweedeKeerScoreInvullen
            presentScoreController(scene: currentScene)
        //Nu split afhankelijk van score invullen
        default: break
            
        }
    }
    
    func getNextSceneTappingWithMerel() {
        switch currentScene {
        case .none:
            currentScene = .probleemInvullen
            presentProblemController(scene: currentScene)
        case .probleemInvullen:
            currentScene = .scoreInvullen
            presentScoreController(scene: currentScene)
        case .scoreInvullen:
            currentScene = .opstartzin
            presentVideoController(currentScene: currentScene)
        case .opstartzin:
            currentScene = .eersteTapsessie
            presentVideoController(currentScene: currentScene)
        case .eersteTapsessie:
            currentScene = .tweedeKeerScoreInvullen
            presentScoreController(scene: currentScene)
        //Nu split afhankelijk van score invullen
        default:
            break
            
        }
        
    }
    //ADDED
    func getNextSceneBreathingSession() {
        switch currentScene {
        case .none:
            currentScene = .breathingSession
            presentBreathingController(scene: currentScene)
        default:
            break
        }
    }
        
    func getHomeViewController() {
        switch currentScene {
        case .none:
            currentScene = .homeController
            presentHomeController()
        default:
            break
        }
    }
        
    // ADDED breathingProces
    func getNextScene() {
        switch currentProces {
        case .onboardingProces:
            getNextSceneOnboarding()
        case .tappingWithMerelProces:
            getNextSceneTappingWithMerel()
        case .breathingProces:
            getNextSceneBreathingSession()
        case .homeControllerProces:
            getHomeViewController()
        }
    }
    
    // Called from the app delegate to show the first view controller
    func start() {
        currentScene = .none
        currentProces = .homeControllerProces
        navigationController.delegate = self
        navigationController.setNavigationBarHidden(true, animated: false)
        getNextScene()
        
        // Local notificationtest
        let notificationManager = NoticationManager()
        notificationManager.pushLocalNotification()
        
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
    
    //ADDED
    func presentBreathingController(scene: Scene) {
        let breathController = BreathController()
        breathController.delegate = self
        navigationController.pushViewController(breathController, animated: true)
    }
    
    //ADDED
    func presentHomeController() {
        let homeController = HomeViewController()
        homeController.delegate = self
        navigationController.pushViewController(homeController, animated: true)
        
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
//ADDED
extension LaunchManager: BreathControllerDelegate {
    func didPopBreathController(_ controller: BreathController) {
        navigationController.popViewController(animated: true)
    }
}

//ADDED
extension LaunchManager: HomeViewControllerDelegate {
    func didClickOnboardingUitleg(_ controller: HomeViewController) {
        currentScene = .none
        currentProces = .onboardingProces
        getNextScene()
    }
    
    func didClickTappingWithMerel(_ controller: HomeViewController) {
        currentScene = .none
        currentProces = .tappingWithMerelProces
        getNextScene()
    }
    
    func didClickTappingZelf(_ controller: HomeViewController) {
        print(1)
    }
    
    func didClickMySessions(_ controller: HomeViewController) {
        print(1)
    }
    
    func didClickBreathingSession(_ controller: HomeViewController) {
        currentScene = .none
        currentProces = .breathingProces
        getNextScene()
    }
    
    func didClickSpecialSlapeloosheid(_ controller: HomeViewController) {
        print(1)
    }
    
    func didClickSpecialStressReduction(_ controller: HomeViewController) {
        print(1)
    }
    
    func didClickSpecialMeerZelfvertrouwen(_ controller: HomeViewController) {
        print(1)
    }
}
