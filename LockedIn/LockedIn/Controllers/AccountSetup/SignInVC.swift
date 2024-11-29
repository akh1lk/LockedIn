//
//  SignInVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

/// The Sign In screen. The first screen the user is presented with.
class SignInVC: UIViewController {
    
    // MARK: - UI Components
    
    // MARK: - Data
    let options = OptionsData.careerGoalOptions
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        self.view.backgroundColor = .white
        
        let multiChoiceView = MultiChoiceView(options: options, limit: 3, screenWidth: self.view.frame.width)
        
        self.view.addSubview(multiChoiceView)
        multiChoiceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            multiChoiceView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            multiChoiceView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            multiChoiceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            multiChoiceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
}
