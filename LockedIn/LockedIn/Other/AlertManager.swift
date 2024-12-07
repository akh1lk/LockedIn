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
    
    public static func showEmptyAboutMeInternshipFieldAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Fill in All Fields", message: "Please fill in the 'About Me' field or the 'Internship' fields (if applicable).")
    }
    
    public static func showFillInFieldsAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Fill in All Fields", message: "Please fill in all the available fields.")
    }
    
    public static func showAuthErrorAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Authentication Error", message: "LinkedIn authentication failed. Please try again.")
    }
    
    public static func showCreateUserAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Failure to Create User", message: "Failed to create a new user. Please try again.")
    }
}

// MARK: - Show Validation Errors
extension AlertManager {
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Invalid Email", message: "Please enter a valid email.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Invalid Password", message: "Please enter a valid password\n(6-64 characters, at least 1 number, 1 symbol, and 1 capital letter)  ")
    }
    
    public static func showInvalidFirstNameAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Invalid First Name", message: "Please enter a valid name (only letters).")
    }
    
    public static func showInvalidLastNameAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Invalid Last Name", message: "Please enter a valid name (only letters).")
    }
}

// MARK: - Show Registration Errors and Alerts
extension AlertManager {
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Unkown Registration Error", message: nil)
    }

    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        showAlert(on: vc, title: "Registration Error", message: "\(error.localizedDescription)")
    }
    
    public static func showPasswordsDontMatchAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Password Error", message: "The passwords you entered don't match.")
    }
    
    public static func showVerifyLinkSent(on vc: UIViewController, with email: String) {
        showAlert(on: vc, title: "Email Verification Sent", message: "To confirm your email address tap the link sent to: \n\(email)")
    }
}

// MARK: - Show SignIn Errors
extension AlertManager {
    public static func showSignInErrorAlert(on vc: UIViewController) {
        showAlert(on: vc, title: "Unkown Error Signing in", message: nil)
    }

    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        showAlert(on: vc, title: "Error Signing In", message: "\(error.localizedDescription)")
    }
}

// MARK: - Show LogOut Errors
extension AlertManager {
    public static func showLogOutErrorAlert(on vc: UIViewController, with error: Error) {
        showAlert(on: vc, title: "Log Out Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Show Forgot Password Errors
extension AlertManager {
    public static func showPasswordResetSent(on vc: UIViewController) {
        showAlert(on: vc, title: "Password Reset Sent", message: nil)
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error) {
        showAlert(on: vc, title: "Error Sending Password Reset", message: "\(error.localizedDescription)")
    }
}

