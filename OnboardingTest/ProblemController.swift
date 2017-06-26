//
//  ProblemController.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 21-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit

protocol ProblemControllerDelegate: class {
    func problemControllerNextButtonClick(_ view: ProblemController)
}

class ProblemController: UIViewController {
    
    private let problemView = ProblemView()
    
    private let messageView = MessageView()
    
    private let scene: Scene
    
    weak var delegate: ProblemControllerDelegate?
    
    
    init(scene: Scene = .none) {
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(messageView)
        view.addSubview(problemView)
        
        problemView.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        problemView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        problemView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        problemView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        problemView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        messageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        messageView.alpha = 0
        problemView.alpha = 0
        
        problemView.delegate = self
        
        messageView.set(message: scene.videoDescription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(scene: scene)
    }
    
//    func showProblemView(withMessage: String) {
//        
//       
//            
//            let problemView = ProblemView(frame: view.frame)
//            view.addSubview(problemView)
//            problemView.setUpViews()
//            problemView.isHidden = true
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
//                problemView.isHidden = false
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
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.messageView.alpha = 1.0
        }, completion: { completed in
            UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.problemView.alpha = 1.0
                self.messageView.alpha = 0.0
            }, completion: { completed in
                
            })
        })
    }

}

extension ProblemController: ProblemViewDelegate {
    func problemViewDidClickNextButton(_ view: ProblemView) {
        delegate?.problemControllerNextButtonClick(self)
    }
}
