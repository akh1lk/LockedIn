//
//  ProfileInfoView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit
import SDWebImage

class ProfileInfoView: UIView {
    
    // MARK: - UI Components
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Regular", size: 32)
        
        let fullText = "Lorem Ipsum"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Decrease letter spacing (kern)
        attributedString.addAttribute(.kern, value: -1.5, range: NSRange(location: 0, length: fullText.count))
        
        label.attributedText = attributedString
        label.numberOfLines = 2
        return label
    }()
    
    private let crackedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = .palette.offBlack.withAlphaComponent(0.69)
        label.layer.cornerRadius = 50
        label.clipsToBounds = true
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "diddy")
        return iv
    }()
    
    private let gradientImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "gradient-black")
        return iv
    }()
    
    let universityIconText: SimpleIconTextView
    let yearIconText: SimpleIconTextView
    let degreeIconText: SimpleIconTextView
    
    // MARK: - Data
    
    // MARK: - Life Cycle
    init(with data: User) {
        let url = URL(string: data.profilePic ?? Utils.questionMark)
        profileImageView.sd_setImage(with: url)
        
        nameLabel.text = data.name
        
        universityIconText = SimpleIconTextView(icon: UIImage(systemName: "location.circle.fill"), text: data.university)
        // TODO: Add year to database.
        yearIconText = SimpleIconTextView(icon: UIImage(systemName: "clock.fill"), text: "Freshmen")
        degreeIconText = SimpleIconTextView(icon: UIImage(systemName: "graduationcap.fill"), text: data.major)
        
        crackedLabel.attributedText = Utils.createBoldPercentageAttributedString(percentage: data.crackedRating)
        super.init(frame: .zero)
        
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(gradientImageView)
        gradientImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(universityIconText)
        universityIconText.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(yearIconText)
        yearIconText.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(degreeIconText)
        degreeIconText.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(crackedLabel)
        crackedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            gradientImageView.topAnchor.constraint(equalTo: self.topAnchor),
            gradientImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            gradientImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gradientImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            degreeIconText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            degreeIconText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            degreeIconText.heightAnchor.constraint(equalToConstant: 50),
            
            yearIconText.bottomAnchor.constraint(equalTo: degreeIconText.topAnchor, constant: 20),
            yearIconText.leadingAnchor.constraint(equalTo: degreeIconText.leadingAnchor),
            yearIconText.heightAnchor.constraint(equalTo: degreeIconText.heightAnchor),
            
            universityIconText.bottomAnchor.constraint(equalTo: yearIconText.topAnchor, constant: 20),
            universityIconText.leadingAnchor.constraint(equalTo: degreeIconText.leadingAnchor),
            universityIconText.heightAnchor.constraint(equalTo: degreeIconText.heightAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: universityIconText.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: universityIconText.topAnchor, constant: 10),
            
            crackedLabel.heightAnchor.constraint(equalToConstant: 100),
            crackedLabel.widthAnchor.constraint(equalToConstant: 100),
            crackedLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            crackedLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
        ])
        
        Utils.addGradientBorder(to: crackedLabel)
    }
    
    // MARK: - Selectors
    
}
