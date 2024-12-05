//
//  Utils.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

class Utils {
    
    /// Creates a done button
    static func customDoneButton(for navigationItem: UINavigationItem, target: Any, action: Selector) {
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: target,
            action: action
        )
        doneButton.setTitleTextAttributes([
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                .foregroundColor: UIColor.palette.purple
            ], for: .normal)
        
        navigationItem.rightBarButtonItem = doneButton
    }
    
    /// Shows a web view controller
    static func showWebViewController(on vc: UIViewController, with urlString: String) {
        let webView = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: webView)
        vc.present(nav, animated: true, completion: nil)
    }
    
    /// WebView Controller with completion:
    
    /// Creates a custom back button
    static func customBackButton(for navigationItem: UINavigationItem, target: Any, action: Selector) {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: target,
            action: action
        )
        backButton.tintColor = .palette.offBlack
        navigationItem.leftBarButtonItem = backButton
    }
    
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
        label.layoutIfNeeded()
        
        gradientLayer.frame = label.bounds
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 8
        shapeLayer.path = UIBezierPath(roundedRect: label.bounds, cornerRadius: 50).cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shapeLayer
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
    
    
    /// Used to generate a thin view for the compelte swipe screen view.
    static func createThinView() -> UIView {
        let view = UIView()
        view.backgroundColor = .palette.gray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }
    
    /// Create a bold attributed text for the cracked label
    static func createBoldPercentageAttributedString(percentage: Int, crackedText: String = "Cracked") -> NSAttributedString {
        let fullText = "\(percentage)%\n\(crackedText)"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let percentageRange = (fullText as NSString).range(of: "\(percentage)%")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 26, weight: .heavy), range: percentageRange)
        
        let crackedRange = (fullText as NSString).range(of: crackedText)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: crackedRange)
        
        return attributedString
    }
}
