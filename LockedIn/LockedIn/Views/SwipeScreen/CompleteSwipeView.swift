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
        button.layer.cornerRadius = 0
        button.backgroundColor = .palette.pink.withAlphaComponent(0.2)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 0
        button.backgroundColor = .palette.purple.withAlphaComponent(0.2)
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    var currentIndex = 0
    let maxIndex = 2 // this is equal to views.count - 1
    let views = [ProfileInfoView(color: .blue), ProfileInfoView(color: .systemPink), ProfileInfoView(color: .systemBrown)]
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .gray
        
        self.addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
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
