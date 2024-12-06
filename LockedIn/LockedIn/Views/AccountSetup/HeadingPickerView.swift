//
//  HeadingPickerView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/4/24.
//

import UIKit
import UIKit

class HeadingPickerView: UIView {
    
    // MARK: - UI Components
    private let headingLabel: UILabel = UILabel()
    private let pickerView: PickerView
    private let prefersLargeTitles: Bool
    private let alignLeft: Bool
    
    // MARK: - Initialization
    init(heading: String, placeholder: String, options: [String], prefersLargeTitles: Bool = true, alignLeft: Bool = false) {
        self.prefersLargeTitles = prefersLargeTitles
        self.alignLeft = alignLeft
        self.pickerView = PickerView(placeholder: placeholder, options: options)
        super.init(frame: .zero)
        setupHeadingLabel(heading: heading, prefersLargeTitles: prefersLargeTitles)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupHeadingLabel(heading: String, prefersLargeTitles: Bool) {
        headingLabel.textColor = .label
        headingLabel.textAlignment = alignLeft ? .left : .center
        headingLabel.font = UIFont(name: "GaretW05-Bold", size: prefersLargeTitles ? 32 : 20)
        headingLabel.numberOfLines = 2
        headingLabel.text = heading
    }
    
    private func setupUI() {
        addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alignLeft
                ? headingLabel.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor, constant: 5)
                : headingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headingLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            pickerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            pickerView.heightAnchor.constraint(equalToConstant: 60),
            pickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: prefersLargeTitles ? 10 : 6),
            pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func getSelectedValue() -> String {
        pickerView.getText()
    }
}
