//
//  SettingsVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/4/24.
//

import UIKit

class SettingsVC: UIViewController {
    // Settings controller.
    
    // MARK: - Variables
    var settingsOption : [IconTextOption] = [
        IconTextOption(icon: UIImage(systemName: "person"), title: "Personal Information"),
        IconTextOption(icon: UIImage(systemName: "bell"), title: "Notifications"),
        IconTextOption(icon: UIImage(systemName: "person.text.rectangle"), title: "Payment"),
        IconTextOption(icon: UIImage(systemName: "questionmark.circle"), title: "Support"),
    ]
    
    // MARK: - UI Components
    private let settingsTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifier)
        return tableView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.palette.offBlack, for: .normal)
        button.layer.borderColor = UIColor.palette.offBlack.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .regular)
        button.layer.cornerRadius = 15
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return button
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        
        // Create paragraph style with custom line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6 // Adjust line spacing here
        paragraphStyle.alignment = .center
        
        // Create attributed string with the paragraph style
        let attributedText = NSMutableAttributedString(
            string: "Made with ❤️ by Gabriel Castillo, Paul Iabacucci and Akhil Kagithapu.\nⓒ 2024 Locked In",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 14, weight: .regular), // Ensure the font is applied
                .foregroundColor: UIColor.palette.offBlack.withAlphaComponent(0.5) // Ensure the color is applied
            ]
        )
        
        // Set the attributed text to the label
        label.attributedText = attributedText
        
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavBar()
        setupUI()
        
        settingsTable.delegate = self
        settingsTable.dataSource = self
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        self.title = "Settings"
    }
    
    private func setupUI() {
        self.view.addSubview(settingsTable)
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(aboutLabel)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            settingsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            settingsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            settingsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300),
            
            logoutButton.topAnchor.constraint(equalTo: self.settingsTable.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 100),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            
            aboutLabel.topAnchor.constraint(equalTo: self.logoutButton.bottomAnchor, constant: 40),
            aboutLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            aboutLabel.widthAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    // MARK: - Selectors & Functions
    @objc private func didTapLogout() {
        print("logout boi")
    }
    
    func presentSettingsController(with settingOption: String ) {
        var viewController: UIViewController
        
        switch settingOption {
        case "Personal Information":
            viewController = PersonalInfoController()
        case "Notifications":
            viewController = NotificationSettingsController()
        case "Payment":
            viewController = PaymentSettingsController()
        case "Support":
            viewController = SupportController()
        default:
            viewController = SettingsVC() // Default option
        }
        
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: -  Settings Table Delegate
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection selection: Int) -> Int {
        return settingsOption.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableCell.identifier, for: indexPath) as? SettingsTableCell else {
            fatalError("The SearchTableView could not dequeue a ProfileTableCell in ProfileController.") }

        cell.configureCell(with: settingsOption[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentSettingsController(with: settingsOption[indexPath.row].title)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
