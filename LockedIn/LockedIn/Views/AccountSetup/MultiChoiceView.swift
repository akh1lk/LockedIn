//
//  MultiChoiceView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

/// A view presenting multiple options in a semi random order.
class MultiChoiceView: UIView {
    // MARK: - UI Components
    
    
    // MARK: - Data
    private var allOptions: [IconTextOption] = []
    private var limit: Int
    private var screenWidth: CGFloat
    public var selectedOptions: [IconTextOption] = []
    
    // MARK: - Life Cycle
    /// Creates a MultiChoiceView
    ///
    ///
    /// - Parameters:
    ///     - options: the list of IconTextOption objects that you'd like to be shown
    ///     - limit: the maximum number of options that can be selected.
    ///     - screenWidth: the width of the screen.
    ///
    init(options: [IconTextOption], limit: Int, screenWidth: CGFloat) {
        self.allOptions = options
        self.limit = limit
        self.screenWidth = screenWidth
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    
    func setupUI() {
        // Semi-randomly formats options.
        var currentTopAnchor = self.topAnchor
        let paddingColumn: CGFloat = 7
        let paddingRow: CGFloat = 15
        var viewsWidth: CGFloat = 0
        var numViews = 3
        
        var index = 0
        
        while index < allOptions.count {
            numViews = numViews == 3 ? 2 : 3
            
            let containerView = UIView()
            self.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            var trailingAnchor = containerView.leadingAnchor
            
            for _ in 1...numViews {
                let view = IconTextView(with: allOptions[index], delegate: self)
                containerView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    view.widthAnchor.constraint(equalToConstant: view.totalWidth),
                    view.heightAnchor.constraint(equalToConstant: 40),
                    view.leadingAnchor.constraint(equalTo: trailingAnchor, constant: paddingColumn),
                ])
                  
                trailingAnchor = view.trailingAnchor
                viewsWidth += view.totalWidth
                index += 1
            }
            
            NSLayoutConstraint.activate([
                containerView.heightAnchor.constraint(equalToConstant: 40),
                containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -5),
                containerView.topAnchor.constraint(equalTo: currentTopAnchor, constant: paddingRow),
            ])
            currentTopAnchor = containerView.bottomAnchor
        }
    }
}

// MARK: - IconTextViewDelegate
extension MultiChoiceView: IconTextViewDelegate {
    func canTap() -> Bool {
        return selectedOptions.count < limit
    }
    
    func didTap(_ iconTextView: IconTextView) {
        if iconTextView.isSelected {
            selectedOptions.removeAll { $0.text == iconTextView.data.text}
        } else {
            selectedOptions.append(iconTextView.data)
        }
    }
}
