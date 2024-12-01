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
    let completeCardView = CompleteCardView()
    
    private let cardDepthImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "card-depth")
        return iv
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "check-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .clear
        button.tintColor = .palette.green
        button.layer.borderColor = UIColor.palette.green.cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 50
        button.adjustsImageWhenHighlighted = false  // Prevent tint color change
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleCheckButtonPressDown), for: .touchDown)
        button.addTarget(self, action: #selector(resetButtonColors), for: .touchUpInside)
        button.addTarget(self, action: #selector(resetButtonColors), for: .touchCancel)
        button.addTarget(self, action: #selector(resetButtonColors), for: .touchDragExit)
        return button
    }()

    private lazy var xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "x-icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .clear
        button.tintColor = .palette.red
        button.layer.borderColor = UIColor.palette.red.cgColor
        button.layer.borderWidth = 4
        button.layer.cornerRadius = 50
        button.adjustsImageWhenHighlighted = false  // Prevent tint color change
        button.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleXButtonPressDown), for: .touchDown)
        button.addTarget(self, action: #selector(resetButtonColors), for: .touchUpInside)
        button.addTarget(self, action: #selector(resetButtonColors), for: .touchCancel)
        button.addTarget(self, action: #selector(resetButtonColors), for: .touchDragExit)
        return button
    }()

    
    // MARK: - Properties
    private let SWIPE_THRESHOLD: CGFloat = 200
    
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
        self.view.addSubview(cardDepthImage)
        cardDepthImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(completeCardView)
        completeCardView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(xButton)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completeCardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            completeCardView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -200),
            completeCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            completeCardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            
            cardDepthImage.topAnchor.constraint(equalTo: completeCardView.bottomAnchor, constant: -88),
            cardDepthImage.heightAnchor.constraint(equalToConstant: 120),
            cardDepthImage.leadingAnchor.constraint(equalTo: completeCardView.leadingAnchor, constant: 5),
            cardDepthImage.trailingAnchor.constraint(equalTo: completeCardView.trailingAnchor, constant: -5),
            
            checkButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10),
            checkButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120),
            checkButton.heightAnchor.constraint(equalToConstant: 100),
            checkButton.widthAnchor.constraint(equalToConstant: 100),
            
            xButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            xButton.bottomAnchor.constraint(equalTo: checkButton.bottomAnchor),
            xButton.heightAnchor.constraint(equalTo: checkButton.heightAnchor),
            xButton.widthAnchor.constraint(equalTo: checkButton.widthAnchor),
            
        ])
    }
    
    // MARK: - Gesture Recognizers
    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(beingDragged(_:)))
        completeCardView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Gesture Selector
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        xFromCenter = translation.x
        yFromCenter = translation.y
        
        switch gestureRecognizer.state {
        case .began:
            originalPoint = completeCardView.center
        case .changed:
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = .pi / 8 * rotationStrength
            let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
            
            completeCardView.center = CGPoint(x: originalPoint.x + xFromCenter, y: originalPoint.y + yFromCenter)
            let transform = CGAffineTransform(rotationAngle: rotationAngle).scaledBy(x: scale, y: scale)
            completeCardView.transform = transform
            
            // Adjust opacity of images based on swipe distance
            updateUIOnSwipe(distance: xFromCenter)
        case .ended:
            afterSwipeAction()
        default:
            resetProfilePosition()
        }
    }
    
    // MARK: - Button Selectors
    @objc func checkButtonTapped() {
        print("check baby!")
    }
    
    @objc func xButtonTapped() {
        print("cross baby!")
    }
    
    @objc private func handleCheckButtonPressDown() {
        UIView.animate(withDuration: 0.1) {
            self.checkButton.backgroundColor = .palette.green
            self.checkButton.tintColor = .white
        }
    }

    @objc private func handleXButtonPressDown() {
        UIView.animate(withDuration: 0.1) {
            self.xButton.backgroundColor = .palette.red
            self.xButton.tintColor = .white
        }
    }

    @objc private func resetButtonColors() {
        UIView.animate(withDuration: 0.1) {
            self.checkButton.backgroundColor = .clear
            self.checkButton.tintColor = .palette.green
            self.xButton.backgroundColor = .clear
            self.xButton.tintColor = .palette.red
        }
    }

    
    // MARK: - Helper Methods
    private func updateUIOnSwipe(distance: CGFloat) {
        let normalizedDistance = min(abs(distance) / SWIPE_THRESHOLD, 1.0)
        
        if distance > 0 {
            // Swiping right - increase opacity of checkImage and update button color
            completeCardView.checkImage.layer.opacity = Float(normalizedDistance * 1.2)
            completeCardView.xImage.layer.opacity = 0
            
            UIView.animate(withDuration: 0.2) {
                self.checkButton.backgroundColor = UIColor.palette.green.withAlphaComponent(normalizedDistance * 1.2)
                self.checkButton.tintColor = .white
            }
        } else {
            // Swiping left - increase opacity of xImage and update button color
            completeCardView.xImage.layer.opacity = Float(normalizedDistance * 1.2)
            completeCardView.checkImage.layer.opacity = 0
            
            UIView.animate(withDuration: 0.2) {
                self.xButton.backgroundColor = UIColor.palette.red.withAlphaComponent(normalizedDistance * 1.2)
                self.xButton.tintColor = .white
            }
        }
    }

    private func resetProfilePosition() {
        UIView.animate(withDuration: 0.2) {
            self.completeCardView.center = self.originalPoint
            self.completeCardView.transform = .identity
            self.completeCardView.checkImage.layer.opacity = 0
            self.completeCardView.xImage.layer.opacity = 0
            
            // Reset button colors
            self.checkButton.backgroundColor = .clear
            self.checkButton.tintColor = .palette.green
            self.xButton.backgroundColor = .clear
            self.xButton.tintColor = .palette.red
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
