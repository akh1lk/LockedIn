//
//  Utils.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

class Utils {
    
    /// Adds a gradient to a given UIView.
    /// > Warning: Must be called within the ``override func viewDidLayoutSubviews()`` method to work.
    static func addGradient(to view: UIView){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.palette.blue.cgColor, UIColor.palette.pink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = view.layer.cornerRadius
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// Creates a placeholder NSAttributedString that is more opaque than regular text.
    static func createPlaceholder(for text: String) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.palette.offBlack.withAlphaComponent(0.7),
            ]
        )
    }
    
    /// Used to generate labels for text fields in account setup screen. 
    static func generateFieldLabel(for text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .palette.offBlack
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Regular", size: 18)
        label.text = text
        return label
    }
}
