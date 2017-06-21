//
//  Helpers.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

//helpers om makkelijk te kunnen wijzigen in de stijl van buttons, etc. die door de hele app worden gebruikt.

extension UIColor {
    
    class func buttonBackgroundColor() -> UIColor {
        return .orange
    }
    
    class func buttonTextColor() -> UIColor {
        return .white
    }
    
    class func normalTextColor() -> UIColor {
        return .white
    }
}

extension UIFont {
    class func buttonFont() -> UIFont {
        return UIFont.boldSystemFont(ofSize: 13)
    }
}

extension CGFloat {
    static func buttonCornerRadius() -> CGFloat {
        return 3.0
    }
}

struct Border {
    static let standardWidth: CGFloat = 1
    static let standardColor: UIColor = .white
    
}
