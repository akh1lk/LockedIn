//
//  CompleteSwipeView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

/// A complete swipe view that contains three different subviews that can be gone through.
class CompleteSwipeView: UIView {
    
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
    var currentIndex = 0
    let maxIndex = 2 // this is equal to views.count - 1
    let views = [ProfileInfoView(color: .blue), ProfileInfoView(color: .systemPink), ProfileInfoView(color: .systemBrown)]
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        
        setupSubviews()
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
        for i in 0...(views.count - 1) {
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

    // MARK: - Selectors
    @objc func leftButtonTapped() {
        if currentIndex == 0 {
            print("can't keep on going there buddy")
        } else {
            views[currentIndex].isHidden = true
            currentIndex -= 1
            views[currentIndex].isHidden = false
        }
    }
    
    @objc func rightButtonTapped() {
        if currentIndex == maxIndex {
            print("can't keep on going there buddy")
        } else {
            views[currentIndex].isHidden = true
            currentIndex += 1
            views[currentIndex].isHidden = false
        }
    }
}
