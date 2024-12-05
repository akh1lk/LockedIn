//
//  StatsView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class EducationView: UIView {
    
    // MARK: - UI Components
    private let universityHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Univeristy"
        label.numberOfLines = 2
        return label
    }()
    
    private let degreeHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Degree"
        label.numberOfLines = 2
        return label
    }()
    
    private let yearHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Degree"
        label.numberOfLines = 2
        return label
    }()
    
    private let universityPicker = PickerView(
        placeholder: "Select your university...",
        options: University.allCases.map { $0.rawValue }.sorted()
    )
    
    private let degreePicker = PickerView(
        placeholder: "Select your degree...",
        options: Degree.allCases.map { $0.rawValue }.sorted()
    )
    
    private let yearPicker = PickerView(
        placeholder: "Select your year...",
        options: Year.allCases.map { $0.rawValue }.sorted()
    )
    
    // MARK: - Data
    /// Alerts will be displayed on parent
    var parent: SetupAccountVC?
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(universityHeading)
        universityHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(universityPicker)
        universityPicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(degreeHeading)
        degreeHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(degreePicker)
        degreePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            universityHeading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            universityHeading.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            
            universityPicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            universityPicker.heightAnchor.constraint(equalToConstant: 60),
            universityPicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            universityPicker.topAnchor.constraint(equalTo: universityHeading.bottomAnchor, constant: 10),
            
            degreeHeading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            degreeHeading.topAnchor.constraint(equalTo: self.universityPicker.bottomAnchor, constant: 30),
            
            degreePicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            degreePicker.heightAnchor.constraint(equalToConstant: 60),
            degreePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            degreePicker.topAnchor.constraint(equalTo: degreeHeading.bottomAnchor, constant: 10),
        ])
    }
}

extension EducationView: SetupAccountSubview {
    func canContinue() -> Bool {
        if universityPicker.getText()?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            return false
        }
        return true
    }
}
