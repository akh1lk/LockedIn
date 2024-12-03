//
//  CompleteCardView:.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

/// A complete swipe view that contains three different subviews that can be tapped through for a user card.
class CompleteCardView: UIView {
    
    // MARK: - UI Components
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()
    
    public let checkImage: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .palette.green
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "checkmark.circle.fill")
        iv.layer.opacity = 0
        return iv
    }()
    
    public let xImage: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .palette.red
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "x.circle.fill")
        iv.layer.opacity = 0
        return iv
    }()
    
    // MARK: - Data
    let userData: UserData
    var currentIndex = 0
    let maxIndex = 1 // this is equal to views.count - 1
    
    /// All the views that can be tapped through in this card
    let views: [UIView]
    
    // thin progress views.
    let progressViews: [UIView] = (0..<2).map { i in
        let view = UIView()
        view.backgroundColor = i == 0 ? .white : .palette.gray
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }
    
    // MARK: - Life Cycle
    init(with data: UserData) {
        
        self.userData = data
        
        self.views = [ // set views with data.
            ProfileInfoView(with: userData),
            InfoCardView(with: userData),
        ]
        
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        
        setupSubviews()
        setupProgressViews()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .gray
        
        self.addSubview(checkImage)
        checkImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(xImage)
        xImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            checkImage.heightAnchor.constraint(equalToConstant: 180),
            checkImage.widthAnchor.constraint(equalToConstant: 180),
            checkImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            checkImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            xImage.heightAnchor.constraint(equalToConstant: 180),
            xImage.widthAnchor.constraint(equalToConstant: 180),
            xImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            xImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            rightButton.topAnchor.constraint(equalTo: self.topAnchor),
            rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            
            leftButton.topAnchor.constraint(equalTo: self.topAnchor),
            leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
        ])
    }
    
    private func setupSubviews() {
        for i in 0..<views.count {
            let view = views[i]
            
            view.isHidden = !(i == 0)
            
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
        }
    }
    
    private func setupProgressViews() {
        for i in 0..<progressViews.count {
            self.addSubview(progressViews[i])
            progressViews[i].translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            progressViews[1].leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 5),
            progressViews[1].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.42),
            progressViews[1].heightAnchor.constraint(equalToConstant: 4),
            progressViews[1].topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            
            progressViews[0].trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -5),
            progressViews[0].widthAnchor.constraint(equalTo: progressViews[1].widthAnchor),
            progressViews[0].heightAnchor.constraint(equalTo: progressViews[1].heightAnchor),
            progressViews[0].topAnchor.constraint(equalTo: progressViews[1].topAnchor),
        ])
    }

    // MARK: - Selectors
    @objc func leftButtonTapped() {
        if currentIndex != 0 {
            views[currentIndex].isHidden = true
            progressViews[currentIndex].backgroundColor = .palette.gray
            currentIndex -= 1
            views[currentIndex].isHidden = false
            progressViews[currentIndex].backgroundColor = .white
        }
    }
    
    @objc func rightButtonTapped() {
        if currentIndex != maxIndex {
            views[currentIndex].isHidden = true
            progressViews[currentIndex].backgroundColor = .palette.gray
            currentIndex += 1
            views[currentIndex].isHidden = false
            progressViews[currentIndex].backgroundColor = .white
        }
    }
}
