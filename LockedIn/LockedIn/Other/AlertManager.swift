//
//  AlertManager.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

class AlertManager {
    private static func showAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}


// MARK: - Setup Account Alerts
extension AlertManager {
    public static func showMissingProjectInternshipAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Missing Project or Internship", message: "Please enter at least one project or internship. ")
    }
    
    public static func showEmptyFieldsAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Fill in All Fields", message: "Please fill in the 'About Me' field or the 'Internship' fields (if applicable).")
    }
    
    public static func showAuthErrorAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Authentication Error", message: "LinkedIn authentication failed. Please try again.")
    }
    
    public static func showCreateUserAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Failure to Create User", message: "Failed to create a new user. Please try again.")
    }
}


