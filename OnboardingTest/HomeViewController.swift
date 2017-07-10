//
//  HomeViewController.swift
//  OnboardingTest
//
//  Created by Martijn van Gogh on 06-07-17.
//  Copyright © 2017 Martijn van Gogh. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate: class {
    func didClickTappingWithMerel(_ controller: HomeViewController)
    func didClickTappingZelf(_ controller: HomeViewController)
    func didClickMySessions(_ controller: HomeViewController)
    func didClickOnboardingUitleg(_ controller: HomeViewController)
    func didClickBreathingSession(_ controller: HomeViewController)
    func didClickSpecialSlapeloosheid(_ controller: HomeViewController)
    func didClickSpecialStressReduction(_ controller: HomeViewController)
    func didClickSpecialMeerZelfvertrouwen(_ controller: HomeViewController)
}

class HomeViewController: UIViewController {
    
    let firstSeparationView: UIView = {
        let fsv = UIView()
        fsv.backgroundColor = .black
        fsv.layer.borderWidth = 0
        fsv.translatesAutoresizingMaskIntoConstraints = false
        return fsv
    }()
    
    let secondSeparationView: UIView = {
        let fsv = UIView()
        fsv.backgroundColor = .black
        fsv.layer.borderWidth = 0
        fsv.translatesAutoresizingMaskIntoConstraints = false
        return fsv
    }()
    
    let thirdSeparationView: UIView = {
        let fsv = UIView()
        fsv.backgroundColor = .black
        fsv.layer.borderWidth = 0
        fsv.translatesAutoresizingMaskIntoConstraints = false
        return fsv
    }()
    
    let dashboardSeparationView: UIView = {
        let fsv = UIView()
        fsv.backgroundColor = .white
        fsv.layer.borderWidth = 0
        fsv.translatesAutoresizingMaskIntoConstraints = false
        return fsv
    }()
    
    let logoImageView: UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.layer.cornerRadius = 15
        imv.clipsToBounds = true
        imv.backgroundColor = .white
        imv.image = #imageLiteral(resourceName: "logoImage")
        return imv
        
    }()
    
    
    
    @IBOutlet var titleHeader: UILabel!
    @IBOutlet var NavigationStackView: UIStackView!
    @IBOutlet var dashBoardLabel: UILabel!
    @IBOutlet var dashBoardStackView: UIStackView!
    @IBOutlet var specialTapSessionsLabel: UILabel!
    @IBOutlet var specialTapSessionsStachView: UIStackView!
    
    @IBOutlet var tapSessieButton: UIButton!
    @IBOutlet var mijnTapSessiesButton: UIButton!
    @IBOutlet var ademhalingsSessieButton: UIButton!
    @IBOutlet var uitlegButton: UIButton!
    
    @IBOutlet var dashBoardViewLeft: UIView!
    @IBOutlet var dashBoardViewRight: UIView!
    
    @IBOutlet var specialLinksButton: UIButton!
    @IBOutlet var specialMiddenButton: UIButton!
    
    
    weak var delegate: HomeViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }
    
    func setUpViews() {
        
        let borderWidth: CGFloat = 0.3
        let seperationheight: CGFloat = 24
        let separationWidth: CGFloat = 0.3
        
        specialTapSessionsStachView.layoutMargins = UIEdgeInsetsMake(3, 3, 3, 3)
        specialTapSessionsStachView.isLayoutMarginsRelativeArrangement = true
        
        view.backgroundColor = .black
        titleHeader.text = "Tap-App"
        titleHeader.layer.borderColor = UIColor.clear.cgColor
        
        
        dashBoardLabel.text = "Dashboard"
        dashBoardLabel.layer.borderColor = UIColor.clear.cgColor
        
        dashBoardViewLeft.layer.borderColor = UIColor.clear.cgColor
        dashBoardViewLeft.layer.borderWidth = borderWidth
        
        dashBoardViewRight.layer.borderColor = UIColor.clear.cgColor
        dashBoardViewRight.layer.borderWidth = borderWidth
        
        specialTapSessionsLabel.text = "Tap specials"
        specialTapSessionsLabel.layer.borderColor = UIColor.clear.cgColor
        specialTapSessionsLabel.layer.borderWidth = borderWidth
        
        tapSessieButton.setTitle("TAP", for: .normal)
        mijnTapSessiesButton.setTitle("SHITLIST", for: .normal)
        ademhalingsSessieButton.setTitle("ADEM", for: .normal)
        uitlegButton.setTitle("LEER", for: .normal)
        
        tapSessieButton.layer.borderColor = UIColor.clear.cgColor
        tapSessieButton.layer.borderWidth = borderWidth
        mijnTapSessiesButton.layer.borderColor = UIColor.clear.cgColor
        mijnTapSessiesButton.layer.borderWidth = borderWidth
        ademhalingsSessieButton.layer.borderColor = UIColor.clear.cgColor
        ademhalingsSessieButton.layer.borderWidth = borderWidth
        uitlegButton.layer.borderColor = UIColor.clear.cgColor
        uitlegButton.layer.borderWidth = borderWidth
        
        specialLinksButton.setTitle("SLAAP ZACHT", for: .normal)
        specialMiddenButton.setTitle("STRESS VRIJ", for: .normal)

        
        specialLinksButton.layer.borderColor = UIColor.clear.cgColor
        specialLinksButton.layer.borderWidth = borderWidth
        specialLinksButton.layer.cornerRadius = 7
        specialLinksButton.clipsToBounds = true
        
        specialMiddenButton.layer.borderColor = UIColor.clear.cgColor
        specialMiddenButton.layer.borderWidth = borderWidth
        specialMiddenButton.layer.cornerRadius = 7
        specialMiddenButton.clipsToBounds = true
        
        view.addSubview(firstSeparationView)
        firstSeparationView.centerYAnchor.constraint(equalTo: tapSessieButton.centerYAnchor).isActive = true
        firstSeparationView.heightAnchor.constraint(equalToConstant: seperationheight).isActive = true
        firstSeparationView.widthAnchor.constraint(equalToConstant: separationWidth).isActive = true
        firstSeparationView.leftAnchor.constraint(equalTo: tapSessieButton.rightAnchor, constant: -separationWidth).isActive = true
        
        view.addSubview(secondSeparationView)
        secondSeparationView.centerYAnchor.constraint(equalTo: tapSessieButton.centerYAnchor).isActive = true
        secondSeparationView.heightAnchor.constraint(equalToConstant: seperationheight).isActive = true
        secondSeparationView.widthAnchor.constraint(equalToConstant: separationWidth).isActive = true
        secondSeparationView.leftAnchor.constraint(equalTo: mijnTapSessiesButton.rightAnchor, constant: -separationWidth).isActive = true
        
        view.addSubview(thirdSeparationView)
        thirdSeparationView.centerYAnchor.constraint(equalTo: tapSessieButton.centerYAnchor).isActive = true
        thirdSeparationView.heightAnchor.constraint(equalToConstant: seperationheight).isActive = true
        thirdSeparationView.widthAnchor.constraint(equalToConstant: separationWidth).isActive = true
        thirdSeparationView.leftAnchor.constraint(equalTo: ademhalingsSessieButton.rightAnchor, constant: -separationWidth).isActive = true
        
        view.addSubview(dashboardSeparationView)
        dashboardSeparationView.widthAnchor.constraint(equalToConstant: separationWidth).isActive = true
        dashboardSeparationView.leftAnchor.constraint(equalTo: dashBoardViewLeft.rightAnchor, constant: -separationWidth).isActive = true
        dashboardSeparationView.topAnchor.constraint(equalTo: dashBoardStackView.topAnchor, constant: 15).isActive = true
        dashboardSeparationView.bottomAnchor.constraint(equalTo: dashBoardStackView.bottomAnchor, constant: -15).isActive = true
        
        titleHeader.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: titleHeader.centerXAnchor, constant: -100).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: titleHeader.centerYAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Doe een tapsessie", message: "Wil je zelf een tapsessie doen, of wil je samen met Merel tappen?", preferredStyle: .alert)
        let zelfAction = UIAlertAction(title: "Zelf", style: .default) { (zelTappen) in
            self.delegate?.didClickTappingZelf(self)
        }
        
        let merelAction = UIAlertAction(title: "Met Merel", style: .default) { (merelTappen) in
            self.delegate?.didClickTappingWithMerel(self)
        }
        alert.addAction(zelfAction)
        alert.addAction(merelAction)
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func didClickTapSessionButton(_ sender: Any) {
        presentAlert()
    }
    
    @IBAction func didClickMySessionsButton(_ sender: Any) {
        delegate?.didClickMySessions(self)
    }
    
    @IBAction func didClickBreathingSessionButton(_ sender: Any) {
        delegate?.didClickBreathingSession(self)
    }

    @IBAction func didClickOnBoardingUitlegButton(_ sender: Any) {
        delegate?.didClickOnboardingUitleg(self)
    }
    
    @IBAction func didClickSpecialSlapelossheidButton(_ sender: Any) {
        delegate?.didClickSpecialSlapeloosheid(self)
    }
    
    @IBAction func didClickStressReductionButton(_ sender: Any) {
        delegate?.didClickSpecialStressReduction(self)
    }
    @IBAction func didClickMeerZelfvertrouwenButton(_ sender: Any) {
        delegate?.didClickSpecialMeerZelfvertrouwen(self)
    }
    
    
    
    
}
