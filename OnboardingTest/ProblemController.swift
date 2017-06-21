//
//  ProblemController.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 21-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit

class ProblemController: UIViewController {
    
    
    let messageLabel: UILabel = {
        let ml = UILabel()
        ml.backgroundColor = .clear
        ml.textColor = UIColor.normalTextColor()
        ml.font = UIFont.boldSystemFont(ofSize: 20)
        ml.translatesAutoresizingMaskIntoConstraints = false
        ml.numberOfLines = 0
        ml.textAlignment = .center
        return ml
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showProblemView(withMessage: String) {
        
       
            
            let problemView = ProblemView(frame: view.frame)
            view.addSubview(problemView)
            problemView.setUpViews()
            problemView.isHidden = true
            
            let messageView = UIView(frame: view.frame)
            view.addSubview(messageView)
            messageView.backgroundColor = .black
            messageView.alpha = 0.0
            
            messageView.addSubview(messageLabel)
            messageLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor, constant: 0).isActive = true
            messageLabel.centerYAnchor.constraint(equalTo: messageView.centerYAnchor, constant: 0).isActive = true
            messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            messageLabel.text = withMessage
            
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                messageView.alpha = 1.0
                
            }, completion: { (completed) in
                problemView.isHidden = false
                UIView.animate(withDuration: 1.0, delay: 2.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    messageView.alpha = 0.0
                    
                    
                }, completion: { (completed) in
                    
                    messageView.removeFromSuperview()
                    
                    
                })
            })
        
    }

}
