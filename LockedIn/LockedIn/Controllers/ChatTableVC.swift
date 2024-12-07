//
//  ChatTableVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/4/24.
//

import UIKit
import MessageKit

class ChatTableVC: UIViewController {
    
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .palette.offWhite
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatTableCell.self, forCellReuseIdentifier: ChatTableCell.identifier)
        return tableView
    }()
    
    // MARK: - Data
    private var chats: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavBar()
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Chats"
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -20),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ChatTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableCell.identifier, for: indexPath) as? ChatTableCell else {
            return UITableViewCell()
        }
        let chat = chats[indexPath.row]
        cell.configureCell(with: chat)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sender = chats[indexPath.row].sender as? Sender {
            let viewController = ChatVC(with: sender, connectionId: 34)
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Error: Wrong sender type.")
        }
    }
}
