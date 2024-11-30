//
//  StatsView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class StatsView: UIView {
    
    // MARK: - UI Components
    private let educationHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Education"
        label.numberOfLines = 2
        return label
    }()
    
    private let internshipHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Internship"
        label.numberOfLines = 2
        return label
    }()
    
    private let projectHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Project"
        label.numberOfLines = 2
        return label
    }()
    
    private let univeristyPicker = PickerView(
        placeholder: "Select your university...",
        options: [
            "Cornell University",
            "Harvard University",
            "Stanford University"
        ])
    
    private let internshipButton = TextIconBtnView(id: "internship", text: "Add an experience")
    private let projectButton = TextIconBtnView(id: "project", text: "Add a project")
    private let internshipFieldView = InternshipFieldView()
    
    // MARK: - Data
    
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        internshipButton.delegate = self
        projectButton.delegate = self
        setupUI()
        setupSecondaryUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func setupUI() {
        self.addSubview(educationHeading)
        educationHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(univeristyPicker)
        univeristyPicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(internshipHeading)
        internshipHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(internshipButton)
        internshipButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(projectHeading)
        projectHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(projectButton)
        projectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            educationHeading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            educationHeading.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            
            univeristyPicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            univeristyPicker.heightAnchor.constraint(equalToConstant: 60),
            univeristyPicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            univeristyPicker.topAnchor.constraint(equalTo: educationHeading.bottomAnchor, constant: 10),
            
            internshipHeading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            internshipHeading.topAnchor.constraint(equalTo: self.univeristyPicker.bottomAnchor, constant: 20),
            
            internshipButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            internshipButton.heightAnchor.constraint(equalToConstant: 60),
            internshipButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            internshipButton.topAnchor.constraint(equalTo: internshipHeading.bottomAnchor, constant: 10),
            
            projectHeading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            projectHeading.topAnchor.constraint(equalTo: internshipHeading.bottomAnchor, constant: 160),
            
            projectButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            projectButton.heightAnchor.constraint(equalToConstant: 60),
            projectButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            projectButton.topAnchor.constraint(equalTo: projectHeading.bottomAnchor, constant: 10),
            
        ])
    }
    
    func setupSecondaryUI() {
        internshipButton.isHidden = true
        
        self.addSubview(internshipFieldView)
        internshipFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            internshipFieldView.topAnchor.constraint(equalTo: internshipButton.topAnchor, constant: -10),
            internshipFieldView.leadingAnchor.constraint(equalTo: internshipButton.leadingAnchor),
            internshipFieldView.trailingAnchor.constraint(equalTo: internshipButton.trailingAnchor),
            internshipFieldView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
}

// MARK: - Setup Account Subview
extension StatsView: SetupAccountSubview {
    func canContinue() -> Bool {
        return true
    }
}

// MARK: - TextIconBtnView Delegate
extension StatsView: TextIconView {
    func didTapButton(_ id: String) {
        if id == "internship" {
            print("you're a noob")
        } else if id == "project" {
            print("supda noob")
        }
    }
}
