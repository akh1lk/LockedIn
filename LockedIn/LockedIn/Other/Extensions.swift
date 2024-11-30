//
//  Extensions.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

extension UIColor {
    
    static let palette = Palette()
    
    struct Palette {
        // Primary Colors:
        let blue = UIColor(red: 0.00, green: 0.29, blue: 0.68, alpha: 1.00)
        let pink = UIColor(red: 0.74, green: 0.41, blue: 0.88, alpha: 1.00)
        let purple = UIColor(red: 0.37, green: 0.09, blue: 0.92, alpha: 1.00)
        let offBlack = UIColor(red: 0.14, green: 0.12, blue: 0.13, alpha: 1.00)
        let offWhite = UIColor(red: 0.94, green: 0.93, blue: 0.97, alpha: 1.00)
        
        // Secondary Colors
        let lightblue = UIColor(red: 0.38, green: 0.59, blue: 0.84, alpha: 1.00)
        let green = UIColor(red: 0.53, green: 0.78, blue: 0.69, alpha: 1.00)
        let red = UIColor(red: 0.38, green: 0.59, blue: 0.84, alpha: 1.00)
        let lightPurple = UIColor(red: 0.47, green: 0.37, blue: 0.81, alpha: 1.00)
        let gray = UIColor(red: 0.73, green: 0.73, blue: 0.81, alpha: 1.00)
        
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
