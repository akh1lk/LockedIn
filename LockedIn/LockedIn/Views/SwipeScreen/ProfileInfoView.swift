//
//  ProfileInfoView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class ProfileInfoView: UIView {

    // MARK: - UI Components
    
    // MARK: - Data
    
    // MARK: - Life Cycle
    init(color: UIColor) {
        super.init(frame: .zero)
        
        self.backgroundColor = color
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
    }
    
    // MARK: - Selectors

}
