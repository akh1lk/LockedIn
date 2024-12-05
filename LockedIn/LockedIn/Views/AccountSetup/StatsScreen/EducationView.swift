//
//  StatsView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class EducationView: UIView {
    
    // MARK: - UI Components
    private let universityPickerView: HeadingPickerView
    private let degreePickerView: HeadingPickerView
    private let yearPickerView: HeadingPickerView
    
    // MARK: - Data
    var parent: SetupAccountVC?
    var prefersLargeTitles: Bool
    var alignLeft: Bool
    
    // MARK: - Initialization
    init(prefersLargeTitles: Bool = true, alignLeft: Bool = false) {
        self.prefersLargeTitles = prefersLargeTitles
        self.alignLeft = alignLeft
        
        self.universityPickerView = HeadingPickerView(
            heading: "University",
            placeholder: "Select your university",
            options: University.allCases.map { $0.rawValue }.sorted(),
            prefersLargeTitles: prefersLargeTitles,
            alignLeft: alignLeft
        )
        
        self.degreePickerView = HeadingPickerView(
            heading: "Degree",
            placeholder: "Select your degree",
            options: Degree.allCases.map { $0.rawValue }.sorted(),
            prefersLargeTitles: prefersLargeTitles,
            alignLeft: alignLeft
        )
        
        self.yearPickerView = HeadingPickerView(
            heading: "Year",
            placeholder: "Select your year",
            options: Year.allCases.map { $0.rawValue },
            prefersLargeTitles: prefersLargeTitles,
            alignLeft: alignLeft
        )
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(universityPickerView)
        universityPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(degreePickerView)
        degreePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(yearPickerView)
        yearPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            universityPickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            universityPickerView.topAnchor.constraint(equalTo: self.topAnchor, constant: prefersLargeTitles ? 25 : 20),
            universityPickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            universityPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            degreePickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            degreePickerView.topAnchor.constraint(equalTo: universityPickerView.bottomAnchor, constant: prefersLargeTitles ? 25 : 20),
            degreePickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            degreePickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            yearPickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            yearPickerView.topAnchor.constraint(equalTo: degreePickerView.bottomAnchor, constant: prefersLargeTitles ? 25 : 20),
            yearPickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            yearPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

extension EducationView: SetupAccountSubview {
    func canContinue() -> Bool {
        let fields = [
            universityPickerView.getSelectedValue(),
            degreePickerView.getSelectedValue(),
            yearPickerView.getSelectedValue()
        ]
        
        let emptyField = fields.first(where: { $0?.trimmingCharacters(in: .whitespaces).isEmpty ?? true })
        
        if let _ = emptyField, let papi = parent {
            AlertManager.showEmptyFieldsAlert(on: papi) // TODO: change messages on alert manager.
            return false
        }
        return true
    }
}
