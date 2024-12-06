//
//  SignInVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit
import WebKit
import Alamofire

/// The Sign In screen. The first screen the user is presented with.
class SignInVC: UIViewController {
    
    // MARK: - UI Components
    private let logoImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        return iv
    }()
    
    private let heading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Sign In"
        return label
    }()
    
    private let subheading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Regular", size: 16)
        label.text = "In order to use this app you must sign in with LinkedIn"
        label.numberOfLines = 2
        return label
    }()
    
    private let buttonBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let buttonImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "linkedin-logo-small")
        return iv
    }()
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 19)
        label.text = "Sign in with LinkedIn"
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "By using our app you are agreeing to our Terms & Conditions and Privacy Policy.")
        attributedString.addAttribute(.link, value: "terms://t&c", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
        attributedString.addAttribute(.link, value: "privacy://pp", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
        
        let tv = UITextView()
        tv.attributedText = attributedString
        tv.linkTextAttributes = [.foregroundColor: UIColor.palette.purple]
        tv.font = UIFont(name: "Garet-Book", size: 12)
        tv.backgroundColor = .clear
        tv.textColor = .label
        tv.textAlignment = .center
        tv.isSelectable = true
        tv.delaysContentTouches = false
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    // MARK: - Data
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        termsTextView.delegate = self
        setupUI()
    }
    
    // Add gradient layer to button background after subviews are layed out.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Utils.addGradient(to: buttonBackground)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(heading)
        heading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(subheading)
        subheading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonBackground)
        buttonBackground.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonImage)
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonLabel)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(termsTextView)
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height * 0.16),
            logoImage.heightAnchor.constraint(equalToConstant: 120),
            logoImage.widthAnchor.constraint(equalToConstant: 120),
            logoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            heading.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 48),
            heading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            subheading.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 12),
            subheading.widthAnchor.constraint(equalToConstant: 250),
            subheading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            buttonBackground.topAnchor.constraint(equalTo: subheading.bottomAnchor, constant: 24),
            buttonBackground.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            buttonBackground.heightAnchor.constraint(equalToConstant: 88),
            buttonBackground.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            buttonImage.centerYAnchor.constraint(equalTo: buttonBackground.centerYAnchor),
            buttonImage.leadingAnchor.constraint(equalTo: buttonBackground.leadingAnchor, constant: 10),
            buttonImage.topAnchor.constraint(equalTo: buttonBackground.topAnchor, constant: 10),
            buttonImage.bottomAnchor.constraint(equalTo: buttonBackground.bottomAnchor, constant: -10),
            buttonImage.widthAnchor.constraint(equalTo: buttonImage.heightAnchor),
            
            buttonLabel.leadingAnchor.constraint(equalTo: buttonImage.trailingAnchor, constant: 10),
            buttonLabel.trailingAnchor.constraint(equalTo: buttonBackground.trailingAnchor, constant: -10),
            buttonLabel.centerYAnchor.constraint(equalTo: buttonBackground.centerYAnchor),
            
            signInButton.topAnchor.constraint(equalTo: buttonBackground.topAnchor),
            signInButton.bottomAnchor.constraint(equalTo: buttonBackground.bottomAnchor),
            signInButton.leadingAnchor.constraint(equalTo: buttonBackground.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: buttonBackground.trailingAnchor),
            
            termsTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            termsTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7),
        ])
    }
    
    // MARK: - Selectors
    @objc func signInButtonTapped() {
        // TODO: Handle Auth in with LinkedIn
        
        // Update datamanger to let SetupAccountVC access id data from response.
        DataManager.shared.userId = 1

        // If they do not have an account yet  (with us, in the database):
        let viewController = SetupAccountVC()
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
        
        // If they do have an account (with us, in the database):
//        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//            sceneDelegate.resetRootViewController()
//        }
    }
}

extension SignInVC : UITextViewDelegate {
    
    func textView(_ textView: UITextView, primaryActionFor textItem: UITextItem, defaultAction: UIAction) -> UIAction? {
        if case .link(let url) = textItem.content {
            
            if url.scheme == "terms" {
                Utils.showWebViewController(on: self, with: "https://policies.google.com/terms?hl=en-US")
            } else if url.scheme == "privacy" {
                Utils.showWebViewController(on: self, with: "https://policies.google.com/privacy?hl=en-US")
            }
        }

        return nil
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        // Makes sure you don't select anything, but can click links. dont ask me why.
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
