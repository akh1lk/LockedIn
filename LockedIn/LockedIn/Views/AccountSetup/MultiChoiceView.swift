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
    private let heading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Data
    private var allOptions: [IconTextOption] = []
    private var limit: Int
    public var selectedOptions: [IconTextOption] = []
    private let prefersLargeTitles: Bool
    
    var parent: SetupAccountVC? // Protocol requires it!
    
    // MARK: - Life Cycle
    /// Creates a MultiChoiceView for a given array of `IconTextOption` with a heading of `title`
    ///
    /// - Parameters:
    ///     - title: the heading text.
    ///     - options: the list of IconTextOption objects that you'd like to be shown.
    ///     - limit: The maximum number of options that can be selected.
    ///     - prefersLargeTitles: a boolean indicating whether the title should use a large font size (default: true).
    ///
    init(title: String, options: [IconTextOption], limit: Int, prefersLargeTitles: Bool = true) {
        self.allOptions = options
        self.limit = limit
        self.prefersLargeTitles = prefersLargeTitles
        super.init(frame: .zero)
        
        self.heading.text = title
        self.heading.textColor = prefersLargeTitles ? .palette.offBlack : .palette.purple
        self.heading.font = UIFont(name: "GaretW05-Bold", size: prefersLargeTitles ? 32 : 24)
        self.heading.numberOfLines = prefersLargeTitles ? 2 : 1
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    func setupUI() {
        self.addSubview(heading)
        heading.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heading.heightAnchor.constraint(equalToConstant: self.prefersLargeTitles ? 120 : 60),
            heading.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            heading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            heading.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        // Semi-randomly formats options.
        var currentTopAnchor = heading.bottomAnchor
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
    
    // MARK: - Functions
    public func fetchSelectedChoices() -> String { return selectedOptions.map { $0.title }.joined(separator: ",") }
}

// MARK: - IconTextViewDelegate
extension MultiChoiceView: IconTextViewDelegate {
    func canTap() -> Bool {
        return selectedOptions.count < limit
    }
    
    func didTap(_ iconTextView: IconTextView) {
        if iconTextView.isSelected {
            selectedOptions.removeAll { $0.title == iconTextView.data.title}
        } else {
            selectedOptions.append(iconTextView.data)
        }
    }
}

// MARK: - SetupAccountSubview
extension MultiChoiceView: SetupAccountSubview {
    func canContinue() -> Bool {
        return !canTap()
    }
}
