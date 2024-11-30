//
//  TextField.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

/// Custom `UITextField` class that has methods that set padding.
class TextField: UITextField {
    
    // MARK: - Data
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    // MARK: - Methods
    /// Set the padding on all sides equal to `amount`
    public func setPadding(amount: CGFloat) {
        self.padding = UIEdgeInsets(top: amount, left: amount, bottom: amount, right: amount)
    }
    
    public func setHorizontalPadding(amount: CGFloat) {
        self.padding = UIEdgeInsets(top: 0, left: amount, bottom: 0, right: amount)
    }
    
    public func setVerticalPadding(amount: CGFloat) {
        self.padding = UIEdgeInsets(top: amount, left: 0, bottom: amount, right: 0)
    }
    
    // MARK: - Custom Padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
