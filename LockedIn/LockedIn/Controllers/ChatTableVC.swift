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
    private var chats: [(sender: Sender, latestMessage: Message)] = [
        (Sender(avatar: UIImage(named: "ye"), senderId: "1", displayName: "Alice", crackedRating: 69),
         Message(sender: Sender(avatar: nil, senderId: "1", displayName: "Alice", crackedRating: 69),
                 messageId: "1",
                 sentDate: Date(),
                 kind: .text("Hey, how are you?"))),
        
        (Sender(avatar: UIImage(systemName: "person.circle"), senderId: "3", displayName: "Charlie", crackedRating: 69),
         Message(sender: Sender(avatar: nil, senderId: "3", displayName: "Charlie", crackedRating: 69),
                 messageId: "3",
                 sentDate: Date(),
                 kind: .emoji("👋")))
    ]
    
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
        cell.configureCell(sender: chat.sender, latestMessage: chat.latestMessage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ChatVC(with: chats[indexPath.row].sender)
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
