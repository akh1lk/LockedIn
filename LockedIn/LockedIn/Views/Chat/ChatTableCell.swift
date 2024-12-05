//
//  ChatTableCell.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/4/24.
//

import UIKit

class ChatTableCell: UITableViewCell {

    // MARK: - UI Components
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "ye")
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.palette.gray.cgColor
        iv.layer.borderWidth = 2
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 16)
        label.text = "Kanye West"
        return label
    }()
    
    private let recentTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Regular", size: 14)
        label.text = "listen dude I'm tweaking hard. third of december, and you didn't give me a sweater."
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .palette.offBlack.withAlphaComponent(0.8)
        label.textAlignment = .right
        label.font = UIFont(name: "GaretW05-Bold", size: 14)
        label.text = "8:45"
        return label
    }()
    
    private let rightArrow: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .palette.offBlack.withAlphaComponent(0.6)
        return iv
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
        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(recentTextLabel)
        recentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(rightArrow)
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.bottomAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -2),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            
            recentTextLabel.topAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 2),
            recentTextLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            recentTextLabel.widthAnchor.constraint(equalToConstant: 200),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            timeLabel.widthAnchor.constraint(equalToConstant: 100),
            
            rightArrow.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor, constant: -0.3),
            rightArrow.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 5),
            rightArrow.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
}
