//
//  NotificationSettingsController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class InterestsVC: UIViewController {
    
    // MARK: - Variables
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .palette.offWhite
        return view
    }()
    
    // MARK: - UI Components
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        Utils.customBackButton(for: self.navigationItem, target: self, action: #selector(backBtnTapped))
        setupNavBar()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Interests"
    }
    
    
    private func setupUI() {
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    // MARK: - Selectors
    @objc func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
}