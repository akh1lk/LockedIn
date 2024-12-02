//
//  ProjectInfoView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/1/24.
//

import UIKit

class ProjectInfoView: UIView {

    // MARK: - UI Components
    
    // MARK: - Data
    
    // MARK: - Life Cycle
    init(with data: UserCardData) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .palette.lightPurple
        
//        self.addSubview(<#UIView#>)
//        <#UIView#>.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            <#UIView#>.topAnchor.constraint(equalTo: <#T##NSLayoutAnchor<AnchorType>#>),
//            <#UIView#>.bottomAnchor.constraint(equalTo: <#T##NSLayoutAnchor<AnchorType>#>),
//            <#UIView#>.leadingAnchor.constraint(equalTo: <#T##NSLayoutAnchor<AnchorType>#>),
//            <#UIView#>.trailingAnchor.constraint(equalTo: <#T##NSLayoutAnchor<AnchorType>#>),
//            
//            <#UIView#>.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>),
//            <#UIView#>.widthAnchor.constraint(equalToConstant: <#T##CGFloat#>),
//        ])
    }
    
    // MARK: - Selectors

}
