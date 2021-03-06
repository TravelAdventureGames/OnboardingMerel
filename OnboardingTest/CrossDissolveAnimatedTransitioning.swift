//
//  CrossDissolveAnimatedTransitioning.swift
//  OnboardingTest
//
//  Created by Kaira Diagne on 21-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit

class CrossDissolveAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) {
            
            var fromView: UIView
            var toView: UIView
            
            if let from = transitionContext.view(forKey: .from), let to = transitionContext.view(forKey: .to) {
                fromView = from
                toView = to
            } else {
                fromView = fromVC.view
                toView = toVC.view
            }
            
            let containerView = transitionContext.containerView
            
            fromView.frame = transitionContext.initialFrame(for: fromVC)
            toView.frame = transitionContext.finalFrame(for: toVC)
            
            containerView.addSubview(toView)
            
            toView.alpha = 0
            fromView.alpha = 1
            
            let transitionDuration = self.transitionDuration(using: transitionContext)
            
            // Animate
            UIView.animate(withDuration: transitionDuration, delay: 0, options: [], animations: {
                toView.alpha = 1
                fromView.alpha = 0
            }, completion: { completed in
                let transitionWasCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!transitionWasCancelled)
                fromView.alpha = 1
            })
        }
    }
    
}
