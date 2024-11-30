//
//  UniversityPickerView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class UniversityPickerView: UIView {
    
    // MARK: - Variables
    var universities: [String] = [
        "Cornell University",
        "Harvard University",
        "Stanford University"
    ]
    
    
    // MARK: - UI Components
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.sizeToFit()
        return picker
    }()
    
    private let pickerTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .palette.offWhite
        textField.attributedPlaceholder = Utils.createPlaceholder(for: "Select your university...")
        textField.layer.cornerRadius = 10
        textField.font = UIFont(name: "GaretW05-Regular", size: 19)
        textField.textAlignment = .left
        textField.tintColor = .clear // hide caret.
        textField.setLeftPaddingPoints(20)
        return textField
    }()
    
    private let pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = .systemBlue
        return toolbar
    }()
    
    private lazy var pickerToolbarDone = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(pickerToolbarDonePressed)
    )
    
    private lazy var flexButton = UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace,
        target: self,
        action: nil
    )
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        pickerTextField.inputView = pickerView
        pickerTextField.delegate = self
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(pickerTextField)
        pickerTextField.translatesAutoresizingMaskIntoConstraints = false
        pickerTextField.inputAccessoryView = pickerToolbar
        pickerToolbar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        self.pickerToolbar.setItems([flexButton, flexButton, flexButton, pickerToolbarDone], animated: true)
        
        NSLayoutConstraint.activate([
            pickerTextField.topAnchor.constraint(equalTo: self.topAnchor),
            pickerTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pickerTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickerTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func pickerToolbarDonePressed() {
        pickerTextField.resignFirstResponder()
    }
}

// MARK: - Picker View Delegate
extension UniversityPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.universities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.universities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = self.universities[row]
    }
}


// MARK: - Text Field Delegate
extension UniversityPickerView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

