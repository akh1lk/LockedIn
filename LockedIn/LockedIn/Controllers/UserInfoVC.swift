//
//  UserInfoVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/5/24.
//

import UIKit

class UserInfoVC: UIViewController {

    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "diddy")
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(named: "arrow-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.transform = button.imageView!.transform.rotated(by: .pi)
        button.layer.cornerRadius = 35
        button.backgroundColor = .white
        button.tintColor = .palette.purple
        button.layer.borderColor = UIColor.palette.purple.cgColor
        button.layer.borderWidth = 5
        button.addTarget(self, action: #selector(exitBtnClicked), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Akhil Charamaya"
        return label
    }()
    
    let universityIconText: SimpleIconTextView
    let yearIconText: SimpleIconTextView
    let degreeIconText: SimpleIconTextView
    
    private let aboutMeTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Noob."
        textView.font = UIFont(name: "GaretW05-Regular", size: 16)
        textView.backgroundColor = .palette.offWhite
        textView.textColor = .palette.offBlack
        textView.layer.cornerRadius = 15
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return textView
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Company Inc."
        return label
    }()
    
    private let jobTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Regular", size: 16)
        label.text = "as a Job Title Here"
        return label
    }()
    
    let borderView = Utils.createThinBorder()
    let thinBorder1 = Utils.createThinBorder()
    let thinBorder2 = Utils.createThinBorder()
    let thinBorder3 = Utils.createThinBorder()
    
    let aboutMeHeading = Utils.createPurpleHeading(with: "About Me")
    let interestsHeading = Utils.createPurpleHeading(with: "Interests")
    let careerGoalsHeading = Utils.createPurpleHeading(with: "Career Goals")
    let internshipHeading = Utils.createPurpleHeading(with: "Interned at")
    
    let interestsScrollView: IconTextScrollView
    let careerGoalsScrollView: IconTextScrollView
    
    private var interests: [IconTextView]
    private var careerGoals: [IconTextView]
    
    // MARK: - Data
    let data: User
    
    // MARK: - Life Cycle
    init(for data: User) {
        self.data = data
        
        self.interests = data.interests.split(separator: ",").map {
            IconTextView(icon: OptionsData.getInterestIcon(for: String($0)), text: String($0))
        }

        self.careerGoals = data.goals.split(separator: ",").map {
            IconTextView(icon: OptionsData.getCareerGoalIcon(for: String($0)), text: String($0))
        }
        
        interestsScrollView = IconTextScrollView(with: interests)
        careerGoalsScrollView = IconTextScrollView(with: careerGoals)
        
        universityIconText = SimpleIconTextView(icon: UIImage(systemName: "location.circle.fill"), text: data.university, color: .palette.offBlack, fontSize: 17 )
        
        yearIconText = SimpleIconTextView(icon: UIImage(systemName: "clock.fill"), text: "Freshmen", color: .palette.offBlack, fontSize: 17)
        
        degreeIconText = SimpleIconTextView(icon: UIImage(systemName: "graduationcap.fill"), text: data.major, color: .palette.offBlack, fontSize: 17)
        
        super.init(nibName: nil, bundle: nil)
        
        profileImage.sd_setImage(with: Utils.questionUrl(data.profilePic?.url))
        nameLabel.text = data.name
        companyNameLabel.text = data.company
        aboutMeTextView.text = data.experience
        jobTitleLabel.text = "as a " + data.jobTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = .palette.offWhite
        self.navigationController?.title = "About"
        setupUI()
        
        if data.company == "" {
            skipInternship()
        } else {
            setupInternship()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Only add to scroll view here!
        self.scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(universityIconText)
        universityIconText.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(yearIconText)
        yearIconText.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(degreeIconText)
        degreeIconText.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(thinBorder1)
        thinBorder1.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(thinBorder2)
        thinBorder2.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(aboutMeHeading)
        aboutMeHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(aboutMeTextView)
        aboutMeTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(interestsHeading)
        interestsHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(interestsScrollView)
        interestsScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(careerGoalsHeading)
        careerGoalsHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(careerGoalsScrollView)
        careerGoalsScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            // Content view.
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: data.company == "" ? 1.3 : 1.5),
            
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 300),
            
            borderView.topAnchor.constraint(equalTo: profileImage.bottomAnchor),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 10),
            
            exitButton.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            exitButton.heightAnchor.constraint(equalToConstant: 70),
            exitButton.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 25),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            universityIconText.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            universityIconText.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 5),
            universityIconText.heightAnchor.constraint(equalToConstant: 30),
            
            yearIconText.topAnchor.constraint(equalTo: universityIconText.bottomAnchor, constant: 0),
            yearIconText.leadingAnchor.constraint(equalTo: universityIconText.leadingAnchor),
            yearIconText.heightAnchor.constraint(equalTo: universityIconText.heightAnchor),
            
            degreeIconText.topAnchor.constraint(equalTo: yearIconText.bottomAnchor, constant: 0),
            degreeIconText.leadingAnchor.constraint(equalTo: universityIconText.leadingAnchor),
            degreeIconText.heightAnchor.constraint(equalTo: universityIconText.heightAnchor),
            
            thinBorder1.topAnchor.constraint(equalTo: degreeIconText.bottomAnchor, constant: 25),
            thinBorder1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thinBorder1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thinBorder1.heightAnchor.constraint(equalToConstant: 1),
            
            aboutMeHeading.topAnchor.constraint(equalTo: thinBorder1.bottomAnchor, constant: 20),
            aboutMeHeading.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            aboutMeTextView.topAnchor.constraint(equalTo: aboutMeHeading.bottomAnchor, constant: 10),
            aboutMeTextView.leadingAnchor.constraint(equalTo: aboutMeHeading.leadingAnchor),
            aboutMeTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            aboutMeTextView.heightAnchor.constraint(equalToConstant: 150),
            
            thinBorder2.topAnchor.constraint(equalTo: aboutMeTextView.bottomAnchor, constant: 25),
            thinBorder2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thinBorder2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thinBorder2.heightAnchor.constraint(equalToConstant: 1),
            
            interestsHeading.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            interestsScrollView.topAnchor.constraint(equalTo: interestsHeading.bottomAnchor),
            interestsScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            interestsScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            interestsScrollView.heightAnchor.constraint(equalToConstant: 45),
            
            careerGoalsHeading.topAnchor.constraint(equalTo: interestsScrollView.bottomAnchor, constant: 30),
            careerGoalsHeading.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            careerGoalsScrollView.topAnchor.constraint(equalTo: careerGoalsHeading.bottomAnchor, constant: 5),
            careerGoalsScrollView.leadingAnchor.constraint(equalTo: interestsScrollView.leadingAnchor),
            careerGoalsScrollView.trailingAnchor.constraint(equalTo: interestsScrollView.trailingAnchor),
            careerGoalsScrollView.heightAnchor.constraint(equalTo: interestsScrollView.heightAnchor),
        ])
    }
    
    private func setupInternship() {
        
        self.view.addSubview(thinBorder3)
        thinBorder3.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(internshipHeading)
        internshipHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(companyNameLabel)
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(jobTitleLabel)
        jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            internshipHeading.topAnchor.constraint(equalTo: thinBorder2.bottomAnchor, constant: 25),
            internshipHeading.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            companyNameLabel.topAnchor.constraint(equalTo: internshipHeading.bottomAnchor, constant: 5),
            companyNameLabel.centerXAnchor.constraint(equalTo: internshipHeading.centerXAnchor),
            
            jobTitleLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: 0),
            jobTitleLabel.centerXAnchor.constraint(equalTo: internshipHeading.centerXAnchor),
            
            thinBorder3.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 25),
            thinBorder3.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thinBorder3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thinBorder3.heightAnchor.constraint(equalToConstant: 1),
            
            interestsHeading.topAnchor.constraint(equalTo: thinBorder3.bottomAnchor, constant: 25),
        ])
        
    }
    
    private func skipInternship() {
        NSLayoutConstraint.activate([
            interestsHeading.topAnchor.constraint(equalTo: thinBorder2.bottomAnchor, constant: 25),
        ])
    }
    
    // MARK: - Selectors
    @objc func exitBtnClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserInfoVC: IconTextViewDelegate {
    func canTap() -> Bool {
        return false
    }
    
    func didTap(_: IconTextView) {
        return
    }
}
