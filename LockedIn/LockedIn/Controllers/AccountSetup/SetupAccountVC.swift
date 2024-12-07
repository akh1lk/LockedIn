//
//  SetupAccountVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit
import FirebaseAuth

protocol SetupAccountSubview {
    func canContinue() -> Bool
    var parent: SetupAccountVC? { get set }
}

enum SetupAccountErrors {
    case auth
    case creation
}

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
    private let views: [UIView & SetupAccountSubview] = [
        MultiChoiceView(title: "Select 4 career goals", options: OptionsData.careerGoalOptions, limit: 4),
        MultiChoiceView(title: "Select 3 interests", options: OptionsData.interestsOptions, limit: 3),
        EducationView(),
        AboutInternshipView(),
        SelectPhotoView()
    ]
    
    /// NOTE: Step is index 1, not index 0. Must be converted when accessing views.
    private var currentStep = 1
    private let totalSteps = 5
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSubviews()
        refreshProgressBar()
    }
    
    override func viewDidLayoutSubviews() {
        Utils.addGradient(to: continueButton)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        Utils.customBackButton(for: self.navigationItem, target: self, action: #selector(backBtnTapped))
        
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
    
    private func exitWithError(_ type: SetupAccountErrors) {
        if let parentVC = self.navigationController?.viewControllers.last(where: { $0 is SignInVC }) {
            switch type {
            case .auth:
                AlertManager.showAuthErrorAlert(on: parentVC)
            case .creation:
                AlertManager.showCreateUserAlert(on: parentVC)
            }
        }
        
        self.navigationController?.popViewController(animated: true)
        
        return
    }
    
    // MARK: - Selectors
    @objc func continueButtonTapped() {
        if !views[currentStep - 1].canContinue() { return }
        if currentStep != totalSteps {
            views[currentStep - 1].isHidden = true
            currentStep += 1
            views[currentStep - 1].isHidden = false
            
        } else {
            // Networking: Creating a New User.
            guard let userId = DataManager.shared.userId else {
                self.exitWithError(.auth)
                return
            }
            
            guard let careerGoalsView = views[0] as? MultiChoiceView, let interestsView = views[1] as? MultiChoiceView, let educationView = views[2] as? EducationView, let aboutInternshipView = views[3] as? AboutInternshipView
            else {
                fatalError("You need to have Education view at index 2 and AboutInternshipView at index 3.")
            }
            
            guard let userUID = Auth.auth().currentUser?.uid else {
                fatalError("No current user.")
            }
            
            let newUser = User(
                id: String(userId),
                firebaseId: userUID,
                linkedinUrl: "", // Created on backend
                name: "", // Created on backend
                goals: careerGoalsView.fetchSelectedChoices(),
                interests: interestsView.fetchSelectedChoices(),
                university: educationView.fetchUniverisy(),
                major: educationView.fetchDegree(),
                company: aboutInternshipView.fetchCompany(),
                jobTitle: aboutInternshipView.fetchJobTitle(),
                experience: aboutInternshipView.fetchAboutMe(),
                location: "Low Rise 6 & 7",
                crackedRating: "" // Created on backend
            )
            do {
                let jsonData = try JSONEncoder().encode(newUser)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Sending user: \(jsonString)")
                }
            } catch {
                print("didn't work")
            }
            
            // TODO: Remove this:
            //            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            //                sceneDelegate.resetRootViewController()
            //            }
            
            NetworkManager.shared.createOrUpdateUser(id: userId, user: newUser, completion: { result in
                switch result {
                case .success(let createdUser):
                    print("User successfully created: \(createdUser)!")
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.resetRootViewController()
                    }
                    
                case .failure(let error):
                    print("Failed to create user: \(error)")
                    self.exitWithError(.creation)
                }
            }
            )}
        refreshProgressBar()
    }
    
    @objc func backBtnTapped() {
        if currentStep != 1 {
            views[currentStep - 1].isHidden = true
            currentStep -= 1
            views[currentStep - 1].isHidden = false
            
        } else {
            // Cancel account setup
            self.navigationController?.popViewController(animated: true)
        }
        
        refreshProgressBar()
    }
}
