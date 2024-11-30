//
//  TextIconBtnView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

protocol TextIconView {
    func didTapButton(_: String)
}

/// A view that acts as a button that holds text on the left side and an icon on the right side. Not to be confused with `IconTextView`
class TextIconBtnView: UIView {
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .palette.offWhite
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Regular", size: 19)
        label.text = "Lorem Ipsum"
        return label
    }()
    
    private let plusImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "plus")
        iv.tintColor = .palette.offBlack.withAlphaComponent(0.7)
        return iv
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    var delegate: TextIconView?
    let id: String
    
    // MARK: - Life Cycle
    init(id: String, text: String) {
        self.id = id
        super.init(frame: .zero)
        
        textLabel.text = text
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(plusImage)
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            textLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            
            plusImage.heightAnchor.constraint(equalToConstant: 30),
            plusImage.heightAnchor.constraint(equalToConstant: 30),
            plusImage.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            plusImage.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func buttonTapped() {
        delegate?.didTapButton(self.id)
    }
}
