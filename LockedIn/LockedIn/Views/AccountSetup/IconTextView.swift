//
//  IconTextView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

protocol IconTextViewDelegate {
    func didTap(_: IconTextView)
}

/// Custom view that behaves as a button that has an icon and text.
class IconTextView: UIView {
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.palette.purple.cgColor
        view.layer.borderWidth = 2.5
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Regular", size: 18)
        label.text = "Lorem Ipsum"
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .palette.offBlack
        iv.image = UIImage(systemName: "questionmark")
        return iv
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.tintColor = .clear
        button.layer.cornerRadius = 20
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    public var delegate: IconTextViewDelegate?
    public let data: IconTextOption
    
    // MARK: - Life Cycle
    init(with option: IconTextOption) {
        data = option
        
        super.init(frame: .zero)
        
        iconImageView.image = option.icon
        textLabel.text = option.text
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .clear
        
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 0),
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 15),
            backgroundView.heightAnchor.constraint(equalToConstant: 40),
            
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    var totalWidth: CGFloat {
        let textLabelWidth = textLabel.intrinsicContentSize.width
        let totalWidth = 50 + textLabelWidth // don't ask why.
        return totalWidth
    }
    
    
    // MARK: - Selectors
    @objc private func buttonTapped() {
        print("noob")
        delegate?.didTap(self)
    }
}
