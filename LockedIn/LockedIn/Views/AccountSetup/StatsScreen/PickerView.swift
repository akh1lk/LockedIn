//
//  PickerView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class PickerView: UIView {
    
    // MARK: - UI Components
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.sizeToFit()
        return picker
    }()
    
    private let pickerTextField: TextField = {
        let textField = TextField()
        textField.backgroundColor = .palette.offWhite
        textField.tintColor = .clear // hide caret.
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
    
    // MARK: - Data
    let options: [String]
    
    // MARK: - Life Cycle
    init(
        placeholder: String,
        aligment: NSTextAlignment = .left,
        cornerRadius: CGFloat = 10,
        fontSize: CGFloat = 20,
        padding: CGFloat = 20,
        options: [String]
    ) {
        self.options = options
        
        super.init(frame: .zero)
        
        pickerTextField.setHorizontalPadding(amount: padding)
        
        pickerTextField.font = UIFont(name: "GaretW05-Regular", size: fontSize)
        pickerTextField.layer.cornerRadius = cornerRadius
        pickerTextField.textAlignment = aligment
        pickerTextField.attributedPlaceholder = Utils.createPlaceholder(for: placeholder)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerTextField.inputView = pickerView
        pickerTextField.delegate = self
        setupUI()
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
    
    // MARK: - Selectors & Methods
    @objc func pickerToolbarDonePressed() {
        pickerTextField.resignFirstResponder()
    }
    
    /// Returns the current text stored in the picker view.
    public func getText() -> String? {
        return pickerTextField.text
    }
}

// MARK: - Picker View Delegate
extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = self.options[row]
    }
}


// MARK: - Text Field Delegate
extension PickerView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

