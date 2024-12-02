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
    private let cardDepthImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "card-depth")
        return iv
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "logo-heading")
        return iv
    }()
    
    private let checkButton = InteractiveButton(imageName: "check-icon", color: .palette.green, action: #selector(checkButtonTapped))
    
    private let xButton = InteractiveButton(imageName: "x-icon", color: .palette.red, action: #selector(xButtonTapped))
    
    private let undoButton = InteractiveButton(imageName: "undo-icon", color: .palette.lightBlue, action: #selector(undoButtonTapped), cornerRadius: 25, borderWidth: 3)
    
    private let moreInfoButton = InteractiveButton(imageName: "arrow-icon", color: .palette.lightPurple, action: #selector(undoButtonTapped), cornerRadius: 25, borderWidth: 3)
    
    // MARK: - Properties
    private let SWIPE_THRESHOLD: CGFloat = 200
    
    private var originalPoint: CGPoint = .zero
    private let ROTATION_STRENGTH: CGFloat = 320.0
    private let ROTATION_MAX: CGFloat = 1.0
    private let SCALE_STRENGTH: CGFloat = 4.0
    private let SCALE_MAX: CGFloat = 0.93
    private var xFromCenter: CGFloat = 0
    private var yFromCenter: CGFloat = 0
    
    // MARK: - Data
    /// Stores the card views currently present. where the last one is the one on top.
    let cardViews: [CompleteCardView]
    var activeCardView: CompleteCardView?
    
    // MARK: - Life Cycle
    init() {
        cardViews = [
            CompleteCardView(with: UserCardData(
                image: UIImage(named: "john-pork"),
                name: "John Pork",
                university: .brown,
                year: .junior,
                degree: .finance,
                crackedRating: 69,
                internship: nil,
                project: nil
            )),
            
            CompleteCardView(with: UserCardData(
                image: UIImage(named: "andy"),
                name: "Andrew Myers",
                university: .harvard,
                year: .sophomore,
                degree: .computerScience,
                crackedRating: 999,
                internship: nil,
                project: nil
            )),
            
            CompleteCardView(with: UserCardData(
                image: UIImage(named: "daddy-noel"),
                name: "Daddy Noel",
                university: .mit,
                year: .freshmen,
                degree: .business,
                crackedRating: 100,
                internship: nil,
                project: nil
            )),
            
            CompleteCardView(with: UserCardData(
                image: UIImage(named: "ye"),
                name: "Ye",
                university: .harvard,
                year: .senior,
                degree: .business,
                crackedRating: 99,
                internship: nil,
                project: nil
            )),
            
            CompleteCardView(with: UserCardData(
                image: UIImage(named: "diddy"),
                name: "Sean J. Combs",
                university: .cornell,
                year: .sophomore,
                degree: .softwareEngineering,
                crackedRating: 95,
                internship: nil,
                project: nil
            )),
        ]
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .palette.offPurple
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // TODO: Read from the database
        activeCardView = cardViews.last
        
        setupCardViews()
        
        setupUI()
        setupGestureRecognizers()
    }
    
    // MARK: - UI Setup
    func setupCardViews() {
        // Logo & Depth View need to be placed before cards.
        self.view.addSubview(cardDepthImage)
        cardDepthImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<cardViews.count {
            let view = cardViews[i]
            
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 20),
                view.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -175),
                view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            ])
        }
        
        NSLayoutConstraint.activate([
            cardDepthImage.topAnchor.constraint(equalTo: cardViews[0].bottomAnchor, constant: -88),
            cardDepthImage.heightAnchor.constraint(equalToConstant: 120),
            cardDepthImage.leadingAnchor.constraint(equalTo:  cardViews[0].leadingAnchor, constant: 5),
            cardDepthImage.trailingAnchor.constraint(equalTo:  cardViews[0].trailingAnchor, constant: -5),
            
            logoImageView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: -30),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    private func setupUI() {
        self.view.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(xButton)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(undoButton)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(moreInfoButton)
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10),
            checkButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120),
            checkButton.heightAnchor.constraint(equalToConstant: 90),
            checkButton.widthAnchor.constraint(equalToConstant: 90),
            
            xButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            xButton.bottomAnchor.constraint(equalTo: checkButton.bottomAnchor),
            xButton.heightAnchor.constraint(equalTo: checkButton.heightAnchor),
            xButton.widthAnchor.constraint(equalTo: checkButton.widthAnchor),
            
            undoButton.trailingAnchor.constraint(equalTo: xButton.leadingAnchor, constant: -15),
            undoButton.centerYAnchor.constraint(equalTo: xButton.centerYAnchor),
            undoButton.heightAnchor.constraint(equalToConstant: 50),
            undoButton.widthAnchor.constraint(equalToConstant: 50),
            
            
            moreInfoButton.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 15),
            moreInfoButton.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor),
            moreInfoButton.heightAnchor.constraint(equalToConstant: 50),
            moreInfoButton.widthAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    // MARK: - Gesture Recognizers
    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(beingDragged(_:)))
        activeCardView?.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Gesture Selector
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
    
        if let cardView = activeCardView {
            
            let translation = gestureRecognizer.translation(in: view)
            xFromCenter = translation.x
            yFromCenter = translation.y
            
            switch gestureRecognizer.state {
            case .began:
                originalPoint = cardView.center
            case .changed:
                let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
                let rotationAngle = .pi / 8 * rotationStrength
                let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
                
                cardView.center = CGPoint(x: originalPoint.x + xFromCenter, y: originalPoint.y + yFromCenter)
                let transform = CGAffineTransform(rotationAngle: rotationAngle).scaledBy(x: scale, y: scale)
                cardView.transform = transform
                
                // Adjust opacity of images based on swipe distance
                updateUIOnSwipe(distance: xFromCenter)
            case .ended:
                afterSwipeAction()
            default:
                resetProfilePosition()
            }
        }
    }
    
    // MARK: - Button Selectors
    @objc func checkButtonTapped() {
        print("check baby!")
    }
    
    @objc func xButtonTapped() {
        print("cross baby!")
    }
    
    @objc func undoButtonTapped() {
        print("undo baby!")
    }
    
    
    
    // MARK: - Helper Methods
    private func updateUIOnSwipe(distance: CGFloat) {
        if let cardView = activeCardView {
            
            let normalizedDistance = min(abs(distance) / SWIPE_THRESHOLD, 1.0)
            
            if distance > 0 {
                // Swiping right - increase opacity of checkImage and update button color
                cardView.checkImage.layer.opacity = Float(normalizedDistance * 1.2)
                cardView.xImage.layer.opacity = 0
                
                UIView.animate(withDuration: 0.2) {
                    self.checkButton.backgroundColor = UIColor.palette.green.withAlphaComponent(normalizedDistance * 1.2)
                    self.checkButton.tintColor = .white
                }
            } else {
                // Swiping left - increase opacity of xImage and update button color
                cardView.xImage.layer.opacity = Float(normalizedDistance * 1.2)
                cardView.checkImage.layer.opacity = 0
                
                UIView.animate(withDuration: 0.2) {
                    self.xButton.backgroundColor = UIColor.palette.red.withAlphaComponent(normalizedDistance * 1.2)
                    self.xButton.tintColor = .white
                }
            }
        }
    }
    
    private func resetProfilePosition() {
        UIView.animate(withDuration: 0.2) {
            self.activeCardView?.center = self.originalPoint
            self.activeCardView?.transform = .identity
            self.activeCardView?.checkImage.layer.opacity = 0
            self.activeCardView?.xImage.layer.opacity = 0
            
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
                swipeRight()
            } else {
                swipeLeft()
            }
            resetProfilePosition()
        } else {
            resetProfilePosition()
        }
    }
    
    /// Removes the active card view from the view with a right swipe animation and triggers follow-up actions.
    private func swipeRight() {
        guard let cardView = activeCardView else { return }

        // Prepare the next card first
        if let currentIndex = cardViews.firstIndex(of: cardView), currentIndex > 0 {
            activeCardView = cardViews[currentIndex - 1]
            setupGestureRecognizers()
        } else {
            activeCardView = nil
        }

        // Animate the card off-screen to the right
        UIView.animate(withDuration: 0.3, animations: {
            cardView.center = CGPoint(x: self.view.frame.width + cardView.frame.width, y: cardView.center.y)
            cardView.transform = CGAffineTransform(rotationAngle: .pi / 8)
            cardView.alpha = 0
        }) { _ in
            // Remove the card from the view hierarchy
            cardView.removeFromSuperview()
            print("Swiped right on \(cardView.userData.name) baby!")
            
            //TODO: Add networking logic here.
        }
    }
    
    private func swipeLeft() {
        swipeRight() // temporarily just for testing purposes
    }
}
