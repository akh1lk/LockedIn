//
//  Utils.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

class Utils {
    static func addGradient(to view: UIView){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.palette.blue.cgColor, UIColor.palette.pink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = view.layer.cornerRadius
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
