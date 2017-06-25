//
//  MessageView.swift
//  OnboardingTest
//
//  Created by Kaira Diagne on 21-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit

class MessageView: UIView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        backgroundColor = .black
    }
    
    func set(message: String) {
        messageLabel.text = message
    }
    
}
