//
//  ChatHeaderView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/5/24.
//

import UIKit

protocol ChatHeaderDelegate {
    func backBtnTapped()
}

class ChatHeaderView: UIView {
    
    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "ye")
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.palette.gray.cgColor
        iv.layer.borderWidth = 2
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 16)
        label.text = "Kanye West"
        return label
    }()
    
    private let crackedTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack.withAlphaComponent(0.8)
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Regular", size: 14)
        label.text = "80% Cracked"
        return label
    }()
    
    private let rightArrow: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .palette.offBlack.withAlphaComponent(0.6)
        return iv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .palette.offBlack.withAlphaComponent(0.6)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    var delegate: ChatHeaderDelegate?
    
    // MARK: - Life Cycle
    init(sender: Sender) {
        super.init(frame: .zero)
        
        self.backgroundColor = .palette.offWhite
        self.profileImageView.image = sender.avatar
        self.nameLabel.text = sender.displayName
        self.crackedTextLabel.text = "\(sender.crackedRating)% Cracked"
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(crackedTextLabel)
        crackedTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(rightArrow)
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(rightArrow)
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -50),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.bottomAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -2),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            
            crackedTextLabel.topAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 2),
            crackedTextLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            crackedTextLabel.widthAnchor.constraint(equalToConstant: 200),
            
            rightArrow.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor, constant: -0.3),
            rightArrow.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
            rightArrow.heightAnchor.constraint(equalToConstant: 15),
            
            backButton.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    // MARK: - Selector
    @objc func backBtnTapped() {
        self.delegate?.backBtnTapped()
    }
}
