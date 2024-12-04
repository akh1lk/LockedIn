//
//  LocationAccessVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class LocationAccessVC: UIViewController {
    // MARK: - UI Components
    private let heading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Where you at?"
        return label
    }()
    
    private let locationIconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "location-icon-big")
        iv.backgroundColor = .clear
        return iv
    }()
    
    private let subheading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Regular", size: 18)
        label.text = "We need your location to find people near you!"
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setTitle("Allow Location Access", for: .normal)
        button.titleLabel?.font = UIFont(name: "GaretW05-Bold", size: 20)
        button.layer.cornerRadius = 30
        button.backgroundColor = .palette.lightPurple
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .blue
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        self.view.addSubview(heading)
        heading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(locationIconView)
        locationIconView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(subheading)
        subheading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heading.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            heading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            locationIconView.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 20),
            locationIconView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            locationIconView.heightAnchor.constraint(equalTo: locationIconView.widthAnchor, multiplier: 0.6),
            locationIconView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            subheading.topAnchor.constraint(equalTo: locationIconView.bottomAnchor, constant: 30),
            subheading.widthAnchor.constraint(equalToConstant: 250),
            subheading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            locationButton.topAnchor.constraint(equalTo: subheading.bottomAnchor, constant: 50),
            locationButton.heightAnchor.constraint(equalToConstant: 60),
            locationButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            locationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            
        ])
    }
    
    // MARK: - Selectors
    @objc func locationButtonTapped() {
        // TODO: Setup request location functionality. 
        self.dismiss(animated: true)
        print("noob")
    }
}
