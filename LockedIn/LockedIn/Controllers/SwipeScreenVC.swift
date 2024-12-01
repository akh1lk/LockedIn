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
    let profileInfoView = CompleteSwipeView()
    
    // MARK: - Properties
    private let SWIPE_THRESHOLD: CGFloat = 220
    
    private var originalPoint: CGPoint = .zero
    private let ROTATION_STRENGTH: CGFloat = 320.0
    private let ROTATION_MAX: CGFloat = 1.0
    private let SCALE_STRENGTH: CGFloat = 4.0
    private let SCALE_MAX: CGFloat = 0.93
    private var xFromCenter: CGFloat = 0
    private var yFromCenter: CGFloat = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .palette.offWhite
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupUI()
        setupGestureRecognizers()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.addSubview(profileInfoView)
        profileInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileInfoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            profileInfoView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -200),
            profileInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            profileInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: - Gesture Recognizers
    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(beingDragged(_:)))
        profileInfoView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Selectors
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        xFromCenter = translation.x
        yFromCenter = translation.y
        
        switch gestureRecognizer.state {
        case .began:
            originalPoint = profileInfoView.center
        case .changed:
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = .pi / 8 * rotationStrength
            let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
            
            profileInfoView.center = CGPoint(x: originalPoint.x + xFromCenter, y: originalPoint.y + yFromCenter)
            let transform = CGAffineTransform(rotationAngle: rotationAngle).scaledBy(x: scale, y: scale)
            profileInfoView.transform = transform
            
            // Adjust color gradually based on swipe distance
            updateColorForSwipe(distance: xFromCenter)
        case .ended:
            afterSwipeAction()
        default:
            resetProfilePosition()
        }
    }
    
    // MARK: - Helper Methods
    private func updateColorForSwipe(distance: CGFloat) {
        let normalizedDistance = min(abs(distance) / SWIPE_THRESHOLD, 1.0)
        if distance > 0 {
            // Swiping right - green tint
            profileInfoView.backgroundColor = UIColor(red: 1 - normalizedDistance, green: 1, blue: 1 - normalizedDistance, alpha: 1)
        } else {
            // Swiping left - red tint
            profileInfoView.backgroundColor = UIColor(red: 1, green: 1 - normalizedDistance, blue: 1 - normalizedDistance, alpha: 1)
        }
    }
    
    private func resetProfilePosition() {
        UIView.animate(withDuration: 0.2) {
            self.profileInfoView.center = self.originalPoint
            self.profileInfoView.transform = .identity
            self.profileInfoView.backgroundColor = .white
        }
    }
    
    private func afterSwipeAction() {
        if abs(xFromCenter) > SWIPE_THRESHOLD {
            if xFromCenter > 0 {
                print("Swiped right!")
            } else {
                print("Swiped left!")
            }
            // Remove the view after successful swipe and reset it
            self.resetProfilePosition()
        } else {
            resetProfilePosition()
        }
    }
}
