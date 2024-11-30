//
//  ProjectFieldView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class ProjectFieldView: UIView {
    
    // MARK: - UI Components
    private static func generateTextField(with placeholder: String) -> TextField {
        let textField = TextField()
        textField.setPadding(amount: 10)
        
        textField.font = UIFont(name: "GaretW05-Regular", size: 18)
        textField.layer.cornerRadius = 7
        textField.textAlignment = .right
        textField.contentVerticalAlignment = .center
        textField.attributedPlaceholder = Utils.createPlaceholder(for: placeholder)
        textField.backgroundColor = .palette.offWhite
        return textField
    }
    
    // MARK: - Data
    let nameLabel = Utils.generateFieldLabel(for: "Name")
    let roleLabel = Utils.generateFieldLabel(for: "Role")
    
    let nameTextField = ProjectFieldView.generateTextField(with: "John Doe")
    let roleTextField = ProjectFieldView.generateTextField(with: "Founder")
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Describe your project..."
        textView.textColor = .palette.offBlack.withAlphaComponent(0.65)
        textView.backgroundColor = .palette.offWhite
        textView.layer.cornerRadius = 10
        textView.font = UIFont(name: "GaretW05-Regular", size: 18)
        textView.setPadding(amount: 10)
        return textView
    }()
    
    // Description tool bar:
    private let descriptionToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = .systemBlue
        return toolbar
    }()
    
    private lazy var descriptionToolbarDone = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: self,
        action: #selector(doneButtonPressed)
    )
    
    private lazy var flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        descriptionTextView.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func setupUI() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(roleLabel)
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(roleTextField)
        roleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.inputAccessoryView = descriptionToolbar
        
        descriptionToolbar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        descriptionToolbar.setItems([flexButton, descriptionToolbarDone], animated: true)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            roleLabel.centerYAnchor.constraint(equalTo: roleTextField.centerYAnchor),
            roleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            nameTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            nameTextField.heightAnchor.constraint(equalToConstant: 35),
            nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            roleTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            roleTextField.heightAnchor.constraint(equalToConstant: 35),
            roleTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            roleTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            
            descriptionTextView.topAnchor.constraint(equalTo: roleTextField.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: roleLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: roleTextField.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func doneButtonPressed() {
        descriptionTextView.resignFirstResponder()
    }
}

extension ProjectFieldView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .palette.offBlack.withAlphaComponent(0.65) {
            textView.text = nil
            textView.textColor = .palette.offBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your project..."
            textView.textColor = .palette.offBlack.withAlphaComponent(0.65)
        }
    }
}

