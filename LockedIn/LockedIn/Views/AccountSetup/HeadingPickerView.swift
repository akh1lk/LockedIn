//
//  HeadingPickerView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/4/24.
//

import UIKit

class HeadingPickerView: UIView {
    
    // MARK: - UI Components
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.numberOfLines = 2
        return label
    }()
    
    private let pickerView: PickerView
    
    // MARK: - Callbacks
    var onValueSelected: ((String?) -> Void)?
    
    // MARK: - Initialization
    init(heading: String, placeholder: String, options: [String]) {
        self.pickerView = PickerView(placeholder: placeholder, options: options)
        super.init(frame: .zero)
        headingLabel.text = heading
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(headingLabel)
        addSubview(pickerView)
        
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headingLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            pickerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            pickerView.heightAnchor.constraint(equalToConstant: 60),
            pickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10),
            pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func getSelectedValue() -> String? {
        pickerView.getText()
    }
}
