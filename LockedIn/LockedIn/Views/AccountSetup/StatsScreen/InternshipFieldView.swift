//
//  InternshipFieldView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

/// TextFields: Name, Position, & Date that ask for information regarding an internship. 
class InternshipFieldView: UIView {
    
    // MARK: - UI Components
    let companyPickerView = PickerView(
        placeholder: "Interned at",
        aligment: .right,
        cornerRadius: 7,
        fontSize: 18,
        padding: 10,
        options: InternshipData.companies)
    
    let positionPickerView = PickerView(
        placeholder: "Intered as",
        aligment: .right,
        cornerRadius: 7,
        fontSize: 18,
        padding: 10,
        options: InternshipData.positions)
    
    let datePickerView = PickerView(
        placeholder: "During",
        aligment: .right,
        cornerRadius: 7,
        fontSize: 18,
        padding: 10,
        options: InternshipData.dates)
    
    private func generateLabel(for text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .palette.offBlack
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Regular", size: 18)
        label.text = text
        return label
    }
    
    // MARK: - Data
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let companyLabel = self.generateLabel(for: "Company")
        let positionLabel = self.generateLabel(for: "Position")
        let dateLabel = self.generateLabel(for: "Date")
        
        self.addSubview(companyLabel)
        companyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(positionLabel)
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(companyPickerView)
        companyPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(positionPickerView)
        positionPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(datePickerView)
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            companyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            companyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            positionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            companyPickerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            companyPickerView.heightAnchor.constraint(equalToConstant: 35),
            companyPickerView.centerYAnchor.constraint(equalTo: companyLabel.centerYAnchor),
            companyPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            positionPickerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            positionPickerView.heightAnchor.constraint(equalToConstant: 35),
            positionPickerView.centerYAnchor.constraint(equalTo: positionLabel.centerYAnchor),
            positionPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            datePickerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            datePickerView.heightAnchor.constraint(equalToConstant: 35),
            datePickerView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
}
