//
//  SetupAccountVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

protocol SetupAccountSubview {
    func canContinue() -> Bool
    var parent: SetupAccountVC? { get set }
}

class SetupAccountVC: UIViewController {

    // MARK: - UI Components
    private lazy var backButton = UIBarButtonItem(
        image: UIImage(systemName: "chevron.left"),
        style: .plain,
        target: self,
        action: #selector(backBtnTapped)
    )
    
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
    private let views: [UIView & SetupAccountSubview] = [
        MultiChoiceView(title: "Select up to 4 career goals", options: OptionsData.careerGoalOptions, limit: 4),
        MultiChoiceView(title: "Select up to 3 interests", options: OptionsData.interestsOptions, limit: 3),
        StatsView(),
        SelectPhotoView()
    ]
    
    /// NOTE: Step is index 1, not index 0. Must be converted when accessing views.
    private var currentStep = 1
    private let totalSteps = 4
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSubviews()
        refreshProgressBar()
        // TODO: Katherine, make a branch of this repository and test installing: https://github.com/hackiftekhar/IQKeyboardManager to see if it works. 
    }
    
    override func viewDidLayoutSubviews() {
        Utils.addGradient(to: continueButton)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backButton.tintColor = .palette.offBlack
        navigationItem.leftBarButtonItem = backButton
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
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
    /// Setups all the subviews that will be shown here, and then hides them.
    private func setupSubviews() {
        for index in 0...(views.count - 1) {
            var view = views[index]
            view.parent = self
            
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
                view.bottomAnchor.constraint(equalTo: self.continueButton.topAnchor, constant: -20),
                view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ])
            
            view.isHidden = index == 0 ? false : true
        }
    }
    
    private func refreshProgressBar() {
        self.progressBar.setProgress(Float(Float(self.currentStep) / Float(self.totalSteps)), animated: true)
    }
    
    // MARK: - Selectors
    @objc func continueButtonTapped() {
        if !views[currentStep - 1].canContinue() { return }
        
        if currentStep != totalSteps {
            views[currentStep - 1].isHidden = true
            currentStep += 1
            views[currentStep - 1].isHidden = false
            
        } else {
            if let statsView = views[currentStep - 1] as? StatsView {
                print(statsView.fetchData())
            }
            
            // TODO: Finish setting up account
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.resetRootViewController()
            }

        }
        
        refreshProgressBar()
    }
    
    @objc func backBtnTapped() {
        if currentStep != 1 {
            views[currentStep - 1].isHidden = true
            currentStep -= 1
            views[currentStep - 1].isHidden = false
            
        } else {
            // TODO: Cancel account setup
            self.navigationController?.popViewController(animated: true)
        }
        
        refreshProgressBar()
    }
}
