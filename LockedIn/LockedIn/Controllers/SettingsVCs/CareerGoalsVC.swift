//
//  CareerGoalsVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/5/24.
//

import UIKit

/// Update career goals view controller for settings. 
class CareerGoalsVC: UIViewController {
    
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .palette.offWhite
        return view
    }()
    
    let multiChoiceView = MultiChoiceView(
        title: "Select 4 Career Goals",
        options: OptionsData.careerGoalOptions, limit: 4,
        prefersLargeTitles: false
    )
    
    // MARK: - Data
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        Utils.customDoneButton(for: self.navigationItem, target: self, action: #selector(doneBtnTapped))
        Utils.customBackButton(for: self.navigationItem, target: self, action: #selector(backBtnTapped))
        setupNavBar()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Interests"
    }
    
    private func setupUI() {
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(multiChoiceView)
        multiChoiceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 110),
            
            multiChoiceView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            multiChoiceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            multiChoiceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            multiChoiceView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneBtnTapped() {
        backBtnTapped()
    }
}
