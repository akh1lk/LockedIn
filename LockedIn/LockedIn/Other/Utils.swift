//
//  Utils.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit
import Firebase
import MessageKit

class Utils {
    
    // MARK: - Default User
    /// Returns a default `User` object with pre-filled values.
    static func defaultUser() -> User {
        return User(
            id: "0", // Default id value, assuming it's an Int.
            firebaseId: "noob",
            linkedinUrl: "https://www.linkedin.com/in/default", // Default LinkedIn URL
            name: "Default User", // Default name
            goals: "", // Default value for goals (empty string if not available)
            interests: "", // Default value for interests (empty string if not available)
            university: "Default University", // Default university
            major: "Undecided", // Default major
            company: "Unknown", // Default company
            jobTitle: "Unknown", // Default job title
            experience: "", // Default experience (empty string if not available)
            location: "Unknown", // Default location
            crackedRating: "0" // Default Cracked Rating
        )
    }
    
    // MARK: - UI Elements
    /// Creates a purple heading label with a specified text.
    static func createPurpleHeading(with text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .palette.purple
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Bold", size: 20)
        label.text = text
        return label
    }
    
    /// Creates a thin border view.
    static func createThinBorder() -> UIView {
        let view = UIView()
        view.backgroundColor = .palette.purple
        return view
    }
    
    /// Creates a thin view for the complete swipe screen view.
    static func createThinView() -> UIView {
        let view = UIView()
        view.backgroundColor = .palette.gray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }
    
    /// Generates a label for text fields in account setup screen.
    static func generateFieldLabel(for text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .palette.offBlack
        label.textAlignment = .left
        label.font = UIFont(name: "GaretW05-Regular", size: 18)
        label.text = text
        return label
    }
    
    // MARK: - Custom Buttons
    /// Creates a custom "Done" button for the navigation bar.
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
    
    /// Creates a custom back button for the navigation bar.
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
    
    // MARK: - Web View
    
    /// Shows a web view controller with a given URL string.
    static func showWebViewController(on vc: UIViewController, with urlString: String) {
        let webView = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: webView)
        vc.present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Gradient Utilities
    
    /// Adds a gradient to a given UIView.
    /// - Warning: Must be called within the `viewDidLayoutSubviews` method to work.
    static func addGradient(to view: UIView) {
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
    
    // MARK: - Attributed Strings
    
    /// Creates a placeholder `NSAttributedString` that is more opaque than regular text.
    static func createPlaceholder(for text: String) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.palette.offBlack.withAlphaComponent(0.7),
            ]
        )
    }
    
    /// Creates a bold attributed string for the cracked label with percentage.
    static func createBoldPercentageAttributedString(percentage: String, crackedText: String = "Cracked") -> NSAttributedString {
        let fullText = "\(percentage)%\n\(crackedText)"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let percentageRange = (fullText as NSString).range(of: "\(percentage)%")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 26, weight: .heavy), range: percentageRange)
        
        let crackedRange = (fullText as NSString).range(of: crackedText)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: crackedRange)
        
        return attributedString
    }
}

// MARK: - Networking
extension Utils {
    /// Returns a URL for a question mark image, or a default URL if the input is nil.
    static func questionUrl(_ url: String?) -> URL? {
        return URL(string: url ?? Utils.questionMark)
    }

    static let questionMark = "https://upload.wikimedia.org/wikipedia/commons/5/5a/Black_question_mark.png"
    
    /// Creates a `Message` object from a dictionary of data.
    static func createMessage(from data: [String: Any]) -> Message? {
        guard let content = data["content"] as? String,
              let senderId = data["senderId"] as? String,
              let timeStamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
                  print("Failed to get required fields from Firebase database.")
                  return nil
              }

        let finalKind: MessageKind = .text(content)
        let sender = Sender(senderId: senderId, displayName: "")
        return Message(sender: sender, messageId: UUID().uuidString, sentDate: timeStamp, kind: finalKind)
    }
}
