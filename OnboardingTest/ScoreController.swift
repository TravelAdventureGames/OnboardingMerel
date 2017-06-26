//
//  ScoreController.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 21-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit

// Will communicate to any outside class "Hey I'm done and the user wants to see the next video"
protocol ScoreControllerDelegate: class {
    func scoreControllerNextButtonClick(_ controller: ScoreController)
}

class ScoreController: UIViewController {
    
    private let messageView = MessageView()
    
    private let scoreView = ScoreView()
    
    weak var delegate: ScoreControllerDelegate?
    
    private let scene: Scene
    
    var previousScore = "\(5)" //Set this from coreData
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(messageView)
        view.addSubview(scoreView)
        
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        scoreView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scoreView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        messageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        messageView.alpha = 0
        scoreView.alpha = 0
        
        scoreView.delegate = self
        messageView.set(message: scene.videoDescription)
        
        scoreView.scoreSlider.value = 5

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(scene: scene)
    }
    
    
    init(scene: Scene = .none) {
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func showScoreEditView(withMessage: String) {
//        
//            let scoreView = ScoreView(frame: view.frame)
//            view.addSubview(scoreView)
//            scoreView.setupSlider()
//            scoreView.isHidden = true
//            
//            let messageView = UIView(frame: view.frame)
//            view.addSubview(messageView)
//            messageView.backgroundColor = .black
//            messageView.alpha = 0.0
//            
////            messageView.addSubview(messageLabel)
////            messageLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor, constant: 0).isActive = true
////            messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor, constant: 0).isActive = true
////            messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
////            messageLabel.text = withMessage
//            
//            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                messageView.alpha = 1.0
//                
//            }, completion: { (completed) in
//                scoreView.isHidden = false
//                UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                    messageView.alpha = 0.0
//                    
//                    
//                }, completion: { (completed) in
//                    
//                    messageView.removeFromSuperview()
//                    
//                    
//                })
//            })
//        
//    }
    
    private func present(scene: Scene) {
        scoreView.previousScoreLabel.text = previousScore
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.messageView.alpha = 1.0
        }, completion: { completed in
            UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.scoreView.alpha = 1.0
                self.messageView.alpha = 0.0
            }, completion: { completed in
                
            })
        })
    }

}

extension ScoreController: ScoreViewDelegate {
    func scoreViewDidClickNextButton(_ view: ScoreView) {
        delegate?.scoreControllerNextButtonClick(self)
        //set coredata with new score
    }
    
}
