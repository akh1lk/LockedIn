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
    
    private lazy var internshipCancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .palette.offBlack.withAlphaComponent(0.5)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(internshipCancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var projectCancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .palette.offBlack.withAlphaComponent(0.5)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(projectCancelTapped), for: .touchUpInside)
        return button
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
    private let projectFieldView = ProjectFieldView()
    
    // MARK: - Data
    /// Alerts will be displayed on parent
    var parent: SetupAccountVC?
    
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
        internshipFieldView.isHidden = true
        internshipCancelButton.isHidden = true
        
        projectFieldView.isHidden = true
        projectCancelButton.isHidden = true
        
        self.addSubview(internshipFieldView)
        internshipFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(internshipCancelButton)
        internshipCancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(projectFieldView)
        projectFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(projectCancelButton)
        projectCancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            internshipFieldView.topAnchor.constraint(equalTo: internshipButton.topAnchor, constant: -10),
            internshipFieldView.leadingAnchor.constraint(equalTo: internshipButton.leadingAnchor),
            internshipFieldView.trailingAnchor.constraint(equalTo: internshipButton.trailingAnchor),
            internshipFieldView.heightAnchor.constraint(equalToConstant: 150),
            
            internshipCancelButton.heightAnchor.constraint(equalToConstant: 30),
            internshipCancelButton.widthAnchor.constraint(equalToConstant: 30),
            internshipCancelButton.centerYAnchor.constraint(equalTo: internshipHeading.centerYAnchor),
            internshipCancelButton.trailingAnchor.constraint(equalTo: internshipFieldView.trailingAnchor),
            
            projectFieldView.topAnchor.constraint(equalTo: projectButton.topAnchor, constant: -10),
            projectFieldView.leadingAnchor.constraint(equalTo: projectButton.leadingAnchor),
            projectFieldView.trailingAnchor.constraint(equalTo: projectButton.trailingAnchor),
            projectFieldView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            projectCancelButton.heightAnchor.constraint(equalToConstant: 30),
            projectCancelButton.widthAnchor.constraint(equalToConstant: 30),
            projectCancelButton.centerYAnchor.constraint(equalTo: projectHeading.centerYAnchor),
            projectCancelButton.trailingAnchor.constraint(equalTo: projectFieldView.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func internshipCancelTapped() {
        internshipButton.isHidden.toggle()
        internshipFieldView.isHidden.toggle()
        internshipCancelButton.isHidden.toggle()
    }
    
    @objc func projectCancelTapped() {
        projectButton.isHidden.toggle()
        projectFieldView.isHidden.toggle()
        projectCancelButton.isHidden.toggle()
    }
    
    // MARK: - Methods
    public func fetchData() -> (Internship?, Project?) {
        var internshipData: Internship? = nil
        var projectData: Project? = nil
        
        if !internshipFieldView.isHidden {
            internshipData = Internship(
                company: internshipFieldView.companyPickerView.getText() ?? "",
                position: internshipFieldView.positionPickerView.getText() ?? "",
                date: internshipFieldView.datePickerView.getText() ?? ""
            )
        }
        
        if !projectFieldView.isHidden {
            projectData = Project(
                name: projectFieldView.nameTextField.text ?? "",
                role: projectFieldView.roleTextField.text ?? "",
                description: projectFieldView.descriptionTextView.text ?? ""
            )
        }
        
        return (internshipData, projectData)
    }
}

// MARK: - Setup Account Subview
extension StatsView: SetupAccountSubview {
    func canContinue() -> Bool {
        // Must enter at least internship or project or both, but at least 1
        if internshipFieldView.isHidden && projectFieldView.isHidden {
            if let p = parent { AlertManager.showMissingProjectInternshipAlert(on: p) }
            return false
        }
        
        if !internshipFieldView.isHidden { // if internship fields are shown, all must be filled in.
            if internshipFieldView.companyPickerView.getText()?.trimmingCharacters(in: .whitespaces).isEmpty ?? true ||
                internshipFieldView.positionPickerView.getText()?.trimmingCharacters(in: .whitespaces).isEmpty ?? true ||
                internshipFieldView.datePickerView.getText()?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
                if let p = parent { AlertManager.showEmptyFieldsAlert(on: p) }
                return false
            }
        }
        
        if !projectFieldView.isHidden { // if project fields are shown, all must be filled in.
            if projectFieldView.nameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true ||
                projectFieldView.roleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true ||
                projectFieldView.descriptionTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
                if let p = parent { AlertManager.showEmptyFieldsAlert(on: p) }
                return false
            }
        }
        return true
    }
}

// MARK: - TextIconBtnView Delegate
extension StatsView: TextIconView {
    func didTapButton(_ id: String) {
        if id == "internship" {
            internshipCancelTapped()
        } else if id == "project" {
            projectCancelTapped()
        }
    }
}
