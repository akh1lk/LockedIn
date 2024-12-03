//
//  AboutMeFieldView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class AboutMeFieldView: UIView {
    
    // MARK: - UI Components
    let aboutMeTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Talk about yourself, your projects, etc in 50 words!"
        textView.textColor = .palette.offBlack.withAlphaComponent(0.65)
        textView.backgroundColor = .palette.offWhite
        textView.layer.cornerRadius = 10
        textView.font = UIFont(name: "GaretW05-Regular", size: 18)
        textView.setPadding(amount: 10)
        return textView
    }()
    
    // Description tool bar:
    private let aboutmeToolbar: UIToolbar = {
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
        aboutMeTextView.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func setupUI() {
        self.addSubview(aboutMeTextView)
        aboutMeTextView.translatesAutoresizingMaskIntoConstraints = false
        
        aboutMeTextView.inputAccessoryView = aboutmeToolbar
        aboutmeToolbar.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40)
        aboutmeToolbar.setItems([flexButton, descriptionToolbarDone], animated: true)
        
        NSLayoutConstraint.activate([
            aboutMeTextView.topAnchor.constraint(equalTo: self.topAnchor),
            aboutMeTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            aboutMeTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            aboutMeTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func doneButtonPressed() {
        aboutMeTextView.resignFirstResponder()
    }
}

extension AboutMeFieldView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .palette.offBlack.withAlphaComponent(0.65) {
            textView.text = nil
            textView.textColor = .palette.offBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Talk about yourself, your projects, etc in 50 words!"
            textView.textColor = .palette.offBlack.withAlphaComponent(0.65)
        }
    }
}

