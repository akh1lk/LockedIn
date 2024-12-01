//
//  SwipeScreenVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

/// The screen where users swipe on people they want to network with.
class SwipeScreenVC: UIViewController {

    // MARK: - UI Components
    
    // MARK: - Data
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // TODO: Add location checking functionality here!
        let vc = LocationAccessVC()
        vc.isModalInPresentation = true
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
        
    }
    
    // MARK: - UI Setup
    
    // MARK: - Selectors
}

