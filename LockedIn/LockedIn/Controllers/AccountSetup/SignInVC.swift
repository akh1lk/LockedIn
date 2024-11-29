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
    let options: [IconTextOption] = [
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "noobmaste"),
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "no"),
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "asdfsadfs"),
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "asdfdf"),
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "bbbbb"),
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "googogog"),
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "giglgediglgle"),
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "bob"),
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "bob"),
        IconTextOption(icon: UIImage(systemName: "house.fill"), text: "bob"),
    
    ]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
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
