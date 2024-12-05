//
//  SettingsVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/4/24.
//

import UIKit

/// Settings view controller. 
class SettingsVC: UIViewController {
    
    // MARK: - Variables
    var settingsOption : [IconTextOption] = [
        IconTextOption(icon: UIImage(systemName: "person.circle"), title: "Personal Information"),
        IconTextOption(icon: UIImage(systemName: "brain"), title: "About me & Internships"),
        IconTextOption(icon: UIImage(systemName: "briefcase"), title: "Career Goals"),
        IconTextOption(icon: UIImage(systemName: "heart"), title: "Interests"),
        IconTextOption(icon: UIImage(systemName: "questionmark.circle"), title: "Support"),
    ]
    
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .palette.offWhite
        return view
    }()
    
    private let settingsTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelection = true
        tableView.isScrollEnabled = false
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.identifier)
        return tableView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.palette.offBlack, for: .normal)
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "GaretW05-Bold", size: 18)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return button
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        
        let attributedText = NSMutableAttributedString(
            string: "Made with ❤️ by Gabriel, Paul, Akhil, Katherine and Ivan.\nⓒ 2024 LockedIn",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: UIColor.palette.offBlack.withAlphaComponent(0.5)
            ]
        )
        
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
    
    override func viewDidLayoutSubviews() {
        Utils.addGradient(to: logoutButton)
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationController?.navigationBar.backgroundColor = .palette.offWhite
        self.navigationItem.title = "Settings"
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        settingsTable.separatorColor = .palette.gray
        
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(settingsTable)
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(aboutLabel)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: settingsTable.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            settingsTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            settingsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -20),
            settingsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            settingsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -350),
            
            aboutLabel.topAnchor.constraint(equalTo: self.settingsTable.bottomAnchor),
            aboutLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            aboutLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 70),
            aboutLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -70),
            
            logoutButton.topAnchor.constraint(equalTo: self.aboutLabel.bottomAnchor, constant: 85),
            logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 180),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
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
            viewController = PersonalInfoController(with: UIImage(named: "ye"))
        case "About me & Internships":
            viewController = AboutMeInternshipVC()
        case "Interests":
            viewController = InterestsVC()
        case "Career Goals":
            viewController = CareerGoalsVC()
        case "Support":
            viewController = SupportVC()
        default:
            viewController = SettingsVC() // default
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
