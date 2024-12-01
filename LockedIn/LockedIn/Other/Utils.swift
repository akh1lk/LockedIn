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
    
    
    /// Adds a gradient border to a given UILabel.
    /// The border is created using the same colors as the `addGradient` function.
    static func addGradientBorder(to label: UILabel) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.palette.blue.cgColor, UIColor.palette.pink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Ensure layout is calculated before applying the gradient
        label.layoutIfNeeded()
        
        // Apply the gradient border to the label
        gradientLayer.frame = label.bounds
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 8  // Adjust border width
        shapeLayer.path = UIBezierPath(roundedRect: label.bounds, cornerRadius: 50).cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor  // Border color
        shapeLayer.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shapeLayer
        
        // Set gradient layer's opacity to 1 to ensure it is fully opaque
        gradientLayer.opacity = 1.0
        
        label.layer.addSublayer(gradientLayer)
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
