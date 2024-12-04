//
//  PersonalInfoController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class PersonalInfoController: UIViewController {
    
    
    // MARK: - Variables
    private let tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .palette.offWhite
        view.layer.cornerRadius = 5
        return view
    }()
    
    // MARK: - UI Components
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavBar()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Personal Information"
    }
    
    
    private func setupUI() {
        self.view.addSubview(tempView)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tempView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            tempView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tempView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tempView.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    // MARK: - Selectors & Functions
}
