//
//  ProblemView.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 19-06-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

protocol ProblemViewDelegate: class {
    func didClickProblemViewNext(_ view: ProblemView)
}

class ProblemView: UIView, UITextViewDelegate {
    
    var counter = 0
    
    let upperLabel: UILabel = {
        let ul = UILabel()
        ul.textColor = UIColor.normalTextColor()
        ul.font = UIFont.boldSystemFont(ofSize: 22)
        ul.backgroundColor = UIColor.buttonBackgroundColor()
        ul.text = "VUL JE PROBLEEM IN"
        ul.textAlignment = .center
        ul.translatesAutoresizingMaskIntoConstraints = false
        return ul
    }()
    
    
    let ikLabel: UILabel = {
        let iv = UILabel()
        iv.backgroundColor = .black
        iv.textColor = UIColor.normalTextColor()
        iv.font = UIFont.boldSystemFont(ofSize: 20)
        iv.text = "Ik"
        iv.textAlignment = .right
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let verbLabel: UILabel = {
        let vb = UILabel()
        vb.numberOfLines = 0
        vb.backgroundColor = .clear
        vb.layer.borderColor = UIColor.clear.cgColor
        vb.textColor = UIColor.normalTextColor()
        vb.font = UIFont.italicSystemFont(ofSize: 11)
        vb.textAlignment = .center
        vb.translatesAutoresizingMaskIntoConstraints = false
        vb.text = "Vul hier een werkwoord in, bijvoorbeeld 'voel me', 'ben', 'heb', etc."
        return vb
    }()
    
    let verbInputView: UITextField = {
        let vv = UITextField()
        vv.textColor = UIColor.normalTextColor()
        vv.font = UIFont.boldSystemFont(ofSize: 20)
        vv.textAlignment = .left
        vv.translatesAutoresizingMaskIntoConstraints = false
        vv.tintColor = UIColor.normalTextColor()
        vv.attributedPlaceholder = NSAttributedString(string: ". . . . . . . . . . . . . . .",
                                                      attributes: [NSForegroundColorAttributeName: UIColor.white])
        vv.autocapitalizationType = .none
        return vv
    }()
    
    let problemLabel: UILabel = {
        let vb = UILabel()
        vb.backgroundColor = .clear
        vb.layer.borderColor = UIColor.clear.cgColor
        vb.textColor = UIColor.normalTextColor()
        vb.font = UIFont.italicSystemFont(ofSize: 11)
        vb.textAlignment = .center
        vb.translatesAutoresizingMaskIntoConstraints = false
        vb.numberOfLines = 0
        vb.text = "Vul hier je probleem in, bijvoorbeeld 'pijn in mijn rug', 'bang voor drukke plaatsen', etc."
        return vb
    }()
    
    let problemInputView: UITextView = {
        let tv = UITextView()
        tv.textColor = UIColor.normalTextColor()
        tv.font = UIFont.boldSystemFont(ofSize: 20)
        tv.backgroundColor = .black
        tv.layer.borderColor = UIColor.clear.cgColor
        tv.isEditable = true
        tv.isScrollEnabled = false
        tv.textAlignment = .left
        tv.tintColor = UIColor.normalTextColor()
        tv.text = ". . . . . . . . . ."
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.autocapitalizationType = .none
        return tv
    }()
    
    let nextButton: UIButton = {
        let ab = UIButton(type: UIButtonType.system)
        ab.backgroundColor = UIColor.buttonBackgroundColor()
        ab.setTitleColor(UIColor.buttonTextColor(), for: .normal)
        ab.setTitle("Ga verder", for: .normal)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        ab.addTarget(self, action: #selector(handleNextVideoTapped), for: .touchUpInside)
        ab.layer.cornerRadius = 3
        return ab
    }()
    
    let exampleButton: UIButton = {
        let ab = UIButton(type: UIButtonType.system)
        ab.backgroundColor = UIColor.buttonBackgroundColor()
        ab.setTitleColor(UIColor.buttonTextColor(), for: .normal)
        ab.setTitle("Geef voorbeeld", for: .normal)
        ab.translatesAutoresizingMaskIntoConstraints = false
        ab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        ab.addTarget(self, action: #selector(handleExampleTapped), for: .touchUpInside)
        ab.layer.cornerRadius = 3
        return ab
    }()
    
    func handleNextVideoTapped() {
        LaunchManager.sharedInstance.getNextScene()
    }
    
    func handleExampleTapped() {
        
        verbInputView.text = ProblemExamples.verbs[counter]
        problemInputView.text = ProblemExamples.problems[counter]
        if counter < ProblemExamples.problems.count - 1 {
            counter += 1
        } else {
            counter = 0
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (problemInputView.text == ". . . . . . . . . .")
        {
            problemInputView.text = ""
        }
        problemInputView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (problemInputView.text == "")
        {
            problemInputView.text = ". . . . . . . . . ."
        }
        problemInputView.resignFirstResponder()
    }
    func setUpViews() {
        
        self.addSubview(upperLabel)
        upperLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        upperLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        upperLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        upperLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.addSubview(verbLabel)
        verbLabel.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 50).isActive = true
        verbLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        verbLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        verbLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(ikLabel)
        ikLabel.topAnchor.constraint(equalTo: verbLabel.bottomAnchor, constant: 10).isActive = true
        ikLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        ikLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        ikLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        self.addSubview(verbInputView)
        verbInputView.topAnchor.constraint(equalTo: ikLabel.topAnchor, constant: 0).isActive = true
        verbInputView.leftAnchor.constraint(equalTo: ikLabel.rightAnchor, constant: 10).isActive = true
        verbInputView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        verbInputView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(problemLabel)
        problemLabel.topAnchor.constraint(equalTo: verbInputView.bottomAnchor, constant: 45).isActive = true
        problemLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        problemLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        problemLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(problemInputView)
        problemInputView.topAnchor.constraint(equalTo: problemLabel.bottomAnchor, constant: 15).isActive = true
        problemInputView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        problemInputView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        problemInputView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        
        self.addSubview(exampleButton)
        exampleButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        exampleButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        exampleButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exampleButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        
        
        self.addSubview(nextButton)
        nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        verbInputView.becomeFirstResponder()
        problemInputView.delegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

