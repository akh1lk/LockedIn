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
    let completeSwipeView = CompleteSwipeView()
    
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
        self.view.addSubview(completeSwipeView)
        completeSwipeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completeSwipeView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            completeSwipeView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -200),
            completeSwipeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            completeSwipeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: - Gesture Recognizers
    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(beingDragged(_:)))
        completeSwipeView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Selectors
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        xFromCenter = translation.x
        yFromCenter = translation.y
        
        switch gestureRecognizer.state {
        case .began:
            originalPoint = completeSwipeView.center
        case .changed:
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = .pi / 8 * rotationStrength
            let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
            
            completeSwipeView.center = CGPoint(x: originalPoint.x + xFromCenter, y: originalPoint.y + yFromCenter)
            let transform = CGAffineTransform(rotationAngle: rotationAngle).scaledBy(x: scale, y: scale)
            completeSwipeView.transform = transform
            
            // Adjust opacity of images based on swipe distance
            updateImageOpacityForSwipe(distance: xFromCenter)
        case .ended:
            afterSwipeAction()
        default:
            resetProfilePosition()
        }
    }
    
    // MARK: - Helper Methods
    private func updateImageOpacityForSwipe(distance: CGFloat) {
        let normalizedDistance = min(abs(distance) / SWIPE_THRESHOLD, 1.0)
        
        if distance > 0 {
            // Swiping right - increase opacity of checkImage
            completeSwipeView.checkImage.layer.opacity = Float(normalizedDistance*1.2)
            completeSwipeView.xImage.layer.opacity = 0
        } else {
            // Swiping left - increase opacity of xImage
            completeSwipeView.xImage.layer.opacity = Float(normalizedDistance*1.2)
            completeSwipeView.checkImage.layer.opacity = 0
        }
    }
    
    private func resetProfilePosition() {
        UIView.animate(withDuration: 0.2) {
            self.completeSwipeView.center = self.originalPoint
            self.completeSwipeView.transform = .identity
            self.completeSwipeView.checkImage.layer.opacity = 0
            self.completeSwipeView.xImage.layer.opacity = 0
        }
    }

    private func afterSwipeAction() {
        if abs(xFromCenter) > SWIPE_THRESHOLD {
            if xFromCenter > 0 {
                print("Swiped right!")
            } else {
                print("Swiped left!")
            }
            resetProfilePosition()
        } else {
            resetProfilePosition()
        }
    }
}
