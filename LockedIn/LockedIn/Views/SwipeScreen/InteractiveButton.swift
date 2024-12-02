//
//  InteractiveButton.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/1/24.
//
import UIKit

class InteractiveButton: UIButton {
    
    // MARK: - Data
    private var action: Selector?
    private let buttonColor: UIColor
    
    
    // MARK: - Init
    init(imageName: String, color: UIColor, action: Selector, cornerRadius: CGFloat = 45, borderWidth: CGFloat = 4) {
        self.buttonColor = color
        super.init(frame: .zero)
        self.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.backgroundColor = .clear
        self.tintColor = color
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.adjustsImageWhenHighlighted = false
        self.action = action
        
        // Add targets for the button actions
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonPressDown), for: .touchDown)
        self.addTarget(self, action: #selector(resetButtonColors), for: .touchUpInside)
        self.addTarget(self, action: #selector(resetButtonColors), for: .touchCancel)
        self.addTarget(self, action: #selector(resetButtonColors), for: .touchDragExit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        // Call the action for the button
        if let action = action {
            UIApplication.shared.sendAction(action, to: nil, from: self, for: nil)
        }
    }
    
    @objc private func buttonPressDown() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = self.tintColor
            self.tintColor = .white
        }
    }
    
    @objc private func resetButtonColors() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = .clear
            self.tintColor = self.buttonColor
        }
    }
}
