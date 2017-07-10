//
//  BreathAnimation.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 27-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
 
    func rotate() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.toValue = CGFloat(M_PI * 1.0)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = 0.5
        self.layer.add(animation, forKey: "transform.rotation.y")
    }
    
}
