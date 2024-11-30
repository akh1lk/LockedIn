//
//  SetupAccountVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

class SetupAccountVC: UIViewController {

    // MARK: - UI Components
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brown
        button.tintColor = .white
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont(name: "GaretW05-Bold", size: 20)
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.trackTintColor = .palette.purple.withAlphaComponent(0.28)
        progressBar.progressTintColor = .palette.purple
        progressBar.layer.cornerRadius = 8
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 8 // Inner layer baby
        progressBar.subviews[1].clipsToBounds = true
        return progressBar
    }()
    
    
    // MARK: - Data
    private let options = OptionsData.careerGoalOptions
    private var currentStep = 0.0
    private let totalSteps = 5.0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        progressForwards()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        Utils.addGradient(to: continueButton)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        self.view.backgroundColor = .white
        let multiChoiceView = MultiChoiceView(title: "Select up to 4 career goals", options: options, limit: 3)
        
        self.view.addSubview(multiChoiceView)
        multiChoiceView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            multiChoiceView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            multiChoiceView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            multiChoiceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            multiChoiceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            progressBar.heightAnchor.constraint(equalToConstant: 16),
            progressBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            progressBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 68),
            progressBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            continueButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            continueButton.heightAnchor.constraint(equalToConstant: 70),
            continueButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
        ])
    }
    
    // MARK: - Methods
    func progressForwards() {
        currentStep += 1
        self.progressBar.setProgress(Float(self.currentStep / self.totalSteps), animated: true)
    }
    
    // MARK: - Selectors
    @objc func continueButtonTapped() {
        progressForwards()
    }
}
