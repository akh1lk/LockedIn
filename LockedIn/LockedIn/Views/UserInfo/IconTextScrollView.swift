//
//  IconTextScrollView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/6/24.
//

import UIKit

class IconTextScrollView: UIView {
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Data
    let subViews: [IconTextView]
    
    // MARK: - Life Cycle
    init(with iconTextViews: [IconTextView]) {
        subViews = iconTextViews
        super.init(frame: .zero)
        setupUI()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            // Width or height constraints for contentView
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
    
    private func setupSubviews() {
        var totalWidth: CGFloat = 0
        let paddingColumn: CGFloat = 15
        var trailingAnchor = contentView.leadingAnchor
        
        for view in subViews {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                view.widthAnchor.constraint(equalToConstant: view.totalWidth),
                view.heightAnchor.constraint(equalToConstant: 40),
                view.leadingAnchor.constraint(equalTo: trailingAnchor, constant: paddingColumn),
            ])
            
            trailingAnchor = view.trailingAnchor
            totalWidth += view.totalWidth
        }
        
        contentView.widthAnchor.constraint(equalToConstant: totalWidth + 100).isActive = true
    }
    
    // MARK: - Selectors
}
