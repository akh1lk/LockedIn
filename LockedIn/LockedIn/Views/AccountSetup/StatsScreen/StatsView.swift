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
    
    private let aboutMeHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "About Me"
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
    
    private let univeristyPicker = PickerView(
        placeholder: "Select your university...",
        options: University.allCases.map { $0.rawValue }.sorted()
    )
    
    private let internshipButton = TextIconBtnView(id: "internship", text: "Add an experience")
    private let internshipFieldView = InternshipFieldView()
    private let aboutMeFieldView = AboutMeFieldView()
    
    // MARK: - Data
    /// Alerts will be displayed on parent
    var parent: SetupAccountVC?
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        internshipButton.delegate = self
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
        
        self.addSubview(aboutMeHeading)
        aboutMeHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(internshipHeading)
        internshipHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(internshipButton)
        internshipButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            educationHeading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            educationHeading.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            
            univeristyPicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            univeristyPicker.heightAnchor.constraint(equalToConstant: 60),
            univeristyPicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            univeristyPicker.topAnchor.constraint(equalTo: educationHeading.bottomAnchor, constant: 10),
            
            aboutMeHeading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            aboutMeHeading.topAnchor.constraint(equalTo: self.univeristyPicker.bottomAnchor, constant: 30),
            
            internshipHeading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            internshipHeading.topAnchor.constraint(equalTo: aboutMeHeading.bottomAnchor, constant: 200),
            
            internshipButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            internshipButton.heightAnchor.constraint(equalToConstant: 60),
            internshipButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            internshipButton.topAnchor.constraint(equalTo: internshipHeading.bottomAnchor, constant: 10),
        ])
    }
    
    func setupSecondaryUI() {
        internshipFieldView.isHidden = true
        internshipCancelButton.isHidden = true
        
        self.addSubview(internshipFieldView)
        internshipFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(internshipCancelButton)
        internshipCancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(aboutMeFieldView)
        aboutMeFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            internshipFieldView.topAnchor.constraint(equalTo: internshipButton.topAnchor, constant: -10),
            internshipFieldView.leadingAnchor.constraint(equalTo: internshipButton.leadingAnchor),
            internshipFieldView.trailingAnchor.constraint(equalTo: internshipButton.trailingAnchor),
            internshipFieldView.heightAnchor.constraint(equalToConstant: 150),
            
            aboutMeFieldView.topAnchor.constraint(equalTo: aboutMeHeading.bottomAnchor, constant: 5),
            aboutMeFieldView.leadingAnchor.constraint(equalTo: internshipButton.leadingAnchor),
            aboutMeFieldView.trailingAnchor.constraint(equalTo: internshipButton.trailingAnchor),
            aboutMeFieldView.bottomAnchor.constraint(equalTo: internshipHeading.topAnchor, constant: -20),
            
            internshipCancelButton.heightAnchor.constraint(equalToConstant: 30),
            internshipCancelButton.widthAnchor.constraint(equalToConstant: 30),
            internshipCancelButton.centerYAnchor.constraint(equalTo: internshipHeading.centerYAnchor),
            internshipCancelButton.trailingAnchor.constraint(equalTo: internshipFieldView.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func internshipCancelTapped() {
        internshipButton.isHidden.toggle()
        internshipFieldView.isHidden.toggle()
        internshipCancelButton.isHidden.toggle()
    }
    
    // MARK: - Methods
    public func fetchData() -> (Internship?, String) {
        
        var internshipData: Internship? = nil
        
        if !internshipFieldView.isHidden {
            internshipData = Internship(
                company: internshipFieldView.companyPickerView.getText() ?? "",
                position: internshipFieldView.positionPickerView.getText() ?? "",
                date: internshipFieldView.datePickerView.getText() ?? ""
            )
        }
        
        return (internshipData, aboutMeFieldView.aboutMeTextView.text ?? "")
    }
}

// MARK: - Setup Account Subview
extension StatsView: SetupAccountSubview {
    func canContinue() -> Bool {
        // Must enter at least internship or project or both, but at least 1
        if internshipFieldView.isHidden && aboutMeFieldView.isHidden {
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
        
        if aboutMeFieldView.aboutMeTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            if let p = parent { AlertManager.showEmptyFieldsAlert(on: p) }
            return false
        }
        
        return true
    }
}

// MARK: - TextIconBtnView Delegate
extension StatsView: TextIconView {
    func didTapButton(_ id: String) {
        if id == "internship" {
            internshipCancelTapped()
        }
    }
}
