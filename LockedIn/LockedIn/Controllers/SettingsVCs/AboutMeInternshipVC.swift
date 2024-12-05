//
//  PaymentSettingsController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class AboutMeInternshipVC: UIViewController {
    
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .palette.offWhite
        return view
    }()
    
    private let internshipHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 20)
        label.text = "Internship"
        label.numberOfLines = 2
        return label
    }()
    
    private let internshipExplanationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.palette.offBlack.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Regular", size: 13)
        label.text = "*Add one optional internship, otherwise your college will be shown on your card."
        label.numberOfLines = 2
        return label
    }()
    
    private let aboutMeHeading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Bold", size: 20)
        label.text = "About Me"
        label.numberOfLines = 2
        return label
    }()
    
    private let internshipFieldView = InternshipFieldView()
    private let aboutMeFieldView = AboutMeFieldView()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        Utils.customDoneButton(for: self.navigationItem, target: self, action: #selector(doneBtnTapped))
        Utils.customBackButton(for: self.navigationItem, target: self, action: #selector(backBtnTapped))
        setupNavBar()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "About & Internships"
    }
    
    private func setupUI() {
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(internshipHeading)
        internshipHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(internshipFieldView)
        internshipFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(internshipExplanationLabel)
        internshipExplanationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(aboutMeHeading)
        aboutMeHeading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(aboutMeFieldView)
        aboutMeFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 110),
            
            internshipHeading.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            internshipHeading.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            internshipHeading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            internshipFieldView.topAnchor.constraint(equalTo: internshipHeading.bottomAnchor, constant: 5),
            internshipFieldView.centerXAnchor.constraint(equalTo: internshipHeading.centerXAnchor),
            internshipFieldView.widthAnchor.constraint(equalTo: internshipHeading.widthAnchor),
            internshipFieldView.heightAnchor.constraint(equalToConstant: 150),
            
            internshipExplanationLabel.topAnchor.constraint(equalTo: internshipFieldView.bottomAnchor, constant: 15),
            internshipExplanationLabel.centerXAnchor.constraint(equalTo: internshipHeading.centerXAnchor),
            internshipExplanationLabel.widthAnchor.constraint(equalTo: internshipHeading.widthAnchor),
            
            aboutMeHeading.topAnchor.constraint(equalTo: internshipExplanationLabel.bottomAnchor, constant: 35),
            aboutMeHeading.widthAnchor.constraint(equalTo: internshipHeading.widthAnchor),
            aboutMeHeading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            aboutMeFieldView.topAnchor.constraint(equalTo: aboutMeHeading.bottomAnchor, constant: 5),
            aboutMeFieldView.centerXAnchor.constraint(equalTo: aboutMeHeading.centerXAnchor),
            aboutMeFieldView.widthAnchor.constraint(equalTo: aboutMeHeading.widthAnchor),
            aboutMeFieldView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -140)
        ])
    }
    
    // MARK: - Selectors & Functions
    @objc func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneBtnTapped() {
        // TODO: Networking update user
       backBtnTapped()
    }
}
