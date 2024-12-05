//
//  ChatTableCell.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/4/24.
//

import UIKit

class ChatTableCell: UITableViewCell {

    // MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Loading..."
        return label
    }()
    
    // MARK: - Data
    static let identifier = "ChatTableCell"
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - UI Setup
    public func configureCell(sender: Sender, latestMessage: Message) {
    }
    
    private func setupUI() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
