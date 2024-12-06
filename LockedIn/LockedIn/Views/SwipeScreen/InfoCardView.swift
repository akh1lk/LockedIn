//
//  InfoCardView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/1/24.
//

import UIKit
import SDWebImage

class InfoCardView: UIView {

    // MARK: - UI Components
    private let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "ye")
        return iv
    }()
    
    private let gradientBackgroundView: UIView = {
        let view = UIView()
        view.layer.opacity = 0.9
        return view
    }()
    
    private let smallHeadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .italicSystemFont(ofSize: 18)
        label.text = "Internship/Studies at"
        return label
    }()
    
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 36)
        label.text = "Company/Uni"
        return label
    }()
    
    private let subheadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Regular", size: 24)
        label.text = "Job/Degree"
        return label
    }()
    
    private let aboutMeHeading: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 24)
        label.text = "About Me"
        return label
    }()
    
    private let aboutMeText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Regular", size: 16)
        label.text = "Lorem Ipsum."
        label.numberOfLines = 9
        return label
    }()
    
    // MARK: - Data
    
    // MARK: - Life Cycle
    init(with data: User) {
        super.init(frame: .zero)
        
        let url = URL(string: data.profilePic ?? Utils.questionMark)
        backgroundImage.sd_setImage(with: url)
        
        if data.company == "" {
            setupInternship(company: data.company, jobTitle: data.jobTitle)
        } else {
            setupUniversity(for: data.university, studying: data.major)
        }
        
        self.aboutMeText.text = data.experience
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Utils.addGradient(to: gradientBackgroundView)
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(gradientBackgroundView)
        gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(smallHeadingLabel)
        smallHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(subheadingLabel)
        subheadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(aboutMeHeading)
        aboutMeHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(aboutMeText)
        aboutMeText.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            gradientBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            gradientBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            gradientBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gradientBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            smallHeadingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            smallHeadingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            headingLabel.topAnchor.constraint(equalTo: smallHeadingLabel.bottomAnchor, constant: -1),
            headingLabel.leadingAnchor.constraint(equalTo: smallHeadingLabel.leadingAnchor),
            
            subheadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: -3),
            subheadingLabel.leadingAnchor.constraint(equalTo: smallHeadingLabel.leadingAnchor),
            
            aboutMeHeading.topAnchor.constraint(equalTo: subheadingLabel.bottomAnchor, constant: 50),
            aboutMeHeading.leadingAnchor.constraint(equalTo: smallHeadingLabel.leadingAnchor),
            
            aboutMeText.topAnchor.constraint(equalTo: aboutMeHeading.bottomAnchor, constant: 5),
            aboutMeText.leadingAnchor.constraint(equalTo: smallHeadingLabel.leadingAnchor),
            aboutMeText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
        ])
    }
    
    // MARK: - Methods
    private func setupUniversity(for university: String, studying degree: String) {
        smallHeadingLabel.text = "Currently at"
        headingLabel.text = university
        subheadingLabel.text = degree
    }
    
    private func setupInternship(company: String, jobTitle: String) {
        smallHeadingLabel.text = "Internship"
        headingLabel.text = company
        subheadingLabel.text = jobTitle
    }
    
    // MARK: - Selectors
}
