//
//  SimpleIconTextView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/1/24.
//

import UIKit

/// View that solely shows an icon followed by text.
class SimpleIconTextView: UIView {
    
    // MARK: - UI Components
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Initializer
    
    init(icon: UIImage?, text: String) {
        super.init(frame: .zero)
        iconImageView.image = icon
        textLabel.text = text
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(iconImageView)
        addSubview(textLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
