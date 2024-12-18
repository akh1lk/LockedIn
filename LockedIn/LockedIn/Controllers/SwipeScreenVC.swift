//
//  SwipeScreenVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//
import UIKit
import FirebaseAuth
import Alamofire

private enum SwipeDirection {
    case right
    case left
}

/// The screen where users swipe on people they want to network with.
class SwipeScreenVC: UIViewController {
    
    // MARK: - UI Components
    private let antiOCDPadding: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
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
    
    private let moreInfoButton = InteractiveButton(imageName: "arrow-icon", color: .palette.lightPurple, action: #selector(moreInfoButtonTapped), cornerRadius: 25, borderWidth: 3)
    
    // MARK: - Properties
    private let SWIPE_THRESHOLD: CGFloat = 180
    
    private var originalPoint: CGPoint = .zero
    private let ROTATION_STRENGTH: CGFloat = 320.0
    private let ROTATION_MAX: CGFloat = 1.0
    private let SCALE_STRENGTH: CGFloat = 4.0
    private let SCALE_MAX: CGFloat = 0.93
    private var xFromCenter: CGFloat = 0
    private var yFromCenter: CGFloat = 0
    
    // MARK: - Data
    /// Stores the card views currently present. where the last one is the one on top.
    var cardViews: [CompleteCardView] = [
        CompleteCardView(with: User(id: <#T##Int#>, firebaseId: <#T##String#>, linkedinUrl: <#T##String#>, name: <#T##String#>, goals: <#T##String#>, interests: <#T##String#>, university: <#T##String#>, major: <#T##String#>, company: <#T##String#>, jobTitle: <#T##String#>, experience: <#T##String#>, location: <#T##String#>, crackedRating: <#T##Float#>)),
        CompleteCardView(with: User(id: <#T##Int#>, firebaseId: <#T##String#>, linkedinUrl: <#T##String#>, name: <#T##String#>, goals: <#T##String#>, interests: <#T##String#>, university: <#T##String#>, major: <#T##String#>, company: <#T##String#>, jobTitle: <#T##String#>, experience: <#T##String#>, location: <#T##String#>, crackedRating: <#T##Float#>)),
        CompleteCardView(with: User(id: <#T##Int#>, firebaseId: <#T##String#>, linkedinUrl: <#T##String#>, name: <#T##String#>, goals: <#T##String#>, interests: <#T##String#>, university: <#T##String#>, major: <#T##String#>, company: <#T##String#>, jobTitle: <#T##String#>, experience: <#T##String#>, location: <#T##String#>, crackedRating: <#T##Float#>)),
        CompleteCardView(with: User(id: <#T##Int#>, firebaseId: <#T##String#>, linkedinUrl: <#T##String#>, name: <#T##String#>, goals: <#T##String#>, interests: <#T##String#>, university: <#T##String#>, major: <#T##String#>, company: <#T##String#>, jobTitle: <#T##String#>, experience: <#T##String#>, location: <#T##String#>, crackedRating: <#T##Float#>))
    ]
    var activeCardView: CompleteCardView? {
        didSet {
            setupGestureRecognizers()
        }
    }
    private var isAnimating: Bool = false
    private var recommendedUsers: [User] = [] // To hold recommended users
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .palette.offWhite
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // TODO: Read from the database
        activeCardView = cardViews.last
        
        setupCardViews()
        
        guard let userId = DataManager.shared.userId else {
            fatalError("mom")
        }
        
//        fetchRecommendations(for: userId)
        setupUI()
    }
    
    
    // MARK: - Fetch Recommendations
    private func fetchRecommendations(for userId: Int) {
        NetworkManager.shared.getUserRecommendations(userId: userId, maxResults: 5) { [weak self] result in
            switch result {
            case .success(let users):
                // Store the recommended users
                self?.recommendedUsers = users
                
                // Create card views for the recommended users
                self?.createCardViews(for: users)
                self?.activeCardView = self?.cardViews.last
                
            case .failure(let error):
                print("Failed to fetch recommendations: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Create Card Views
    private func createCardViews(for users: [User]) {
        var newCardViews: [CompleteCardView] = []
        
        for user in users {
            let cardView = CompleteCardView(with: user)
            newCardViews.append(cardView)
        }
        
        // Add the new card views to the view
        self.cardViews = newCardViews
        setupCardViews() // Re-setup card views with the new data
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
            view.delegate = self
            
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
            cardDepthImage.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -263),
            cardDepthImage.heightAnchor.constraint(equalToConstant: 120),
            cardDepthImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            cardDepthImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            
            logoImageView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    private func setupUI() {
        self.view.addSubview(antiOCDPadding)
        antiOCDPadding.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(xButton)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(undoButton)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(moreInfoButton)
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            antiOCDPadding.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            antiOCDPadding.heightAnchor.constraint(equalToConstant: 90),
            antiOCDPadding.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            antiOCDPadding.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
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
        guard !isAnimating else { return } // no spam clicking please!
        
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
        guard !isAnimating else { return }
        swipe(.right, longDuration: true)
    }

    @objc func xButtonTapped() {
        guard !isAnimating else { return }
        swipe(.left, longDuration: true)
    }

    @objc func undoButtonTapped() {
        print("undo baby!")
    }
    
    @objc func moreInfoButtonTapped() {
        if let activeUser = activeCardView?.userData {
            let popupController = UserInfoVC(for: activeUser)
            popupController.modalPresentationStyle = .overFullScreen
            self.present(popupController, animated: true, completion: nil)
        } else {
            print("error loading user")
        }
    }
    
    // MARK: - Helper Methods
    private func updateUIOnSwipe(distance: CGFloat) {
        if let cardView = activeCardView {
            
            let normalizedDistance = min(abs(distance) / SWIPE_THRESHOLD, 1.0)
            
            if distance > 0 {
                // increase opacity of checkImage and update button color when swiping right
                cardView.checkImage.layer.opacity = Float(normalizedDistance * 1.2)
                cardView.xImage.layer.opacity = 0
                
                UIView.animate(withDuration: 0.2) {
                    self.checkButton.backgroundColor = UIColor.palette.green.withAlphaComponent(normalizedDistance * 1.2)
                    self.checkButton.tintColor = .white
                }
            } else {
                // increase opacity of xImage and update button color when swiping left
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
                swipe(.right)
            } else {
                swipe(.left)
            }
            resetProfilePosition()
        } else {
            resetProfilePosition()
        }
    }

    /// Removes the active card view from the view with a swipe animation in the specified direction and triggers follow-up actions.
    private func swipe(_ direction: SwipeDirection, longDuration: Bool = false) {
        guard let cardView = activeCardView, !isAnimating else { return }

        isAnimating = true // Lock animation

        // Prepare the next card
        if let currentIndex = cardViews.firstIndex(of: cardView), currentIndex > 0 {
            activeCardView = cardViews[currentIndex - 1]
            setupGestureRecognizers()
        } else {
            activeCardView = nil
        }

        let offScreenX = direction == .right ? self.view.frame.width + cardView.frame.width : -cardView.frame.width
        let rotationAngle: CGFloat = direction == .right ? .pi / 8 : -.pi / 8

        let targetImageView = direction == .right ? cardView.checkImage : cardView.xImage
        let checkImageOpacity: Float = 1

        let animateCardOffScreen = {
            UIView.animate(withDuration: 0.3, animations: {
                cardView.center = CGPoint(x: offScreenX, y: cardView.center.y)
                cardView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            }) { _ in
                cardView.removeFromSuperview()
                let directionText = direction == .right ? "right" : "left"
                
                guard let userId = DataManager.shared.userId, let id = self.activeCardView?.userData.id else {
                    return
                }
                
                if direction == .right {
                    
                    NetworkManager.shared.createSwipe(swiperId: userId, swipedId: id) { error in
                        return
                    }
                }

                self.isAnimating = false

                // TODO: Add networking logic
            }
        }

        if longDuration {
            UIView.animate(withDuration: 0.3, animations: {
                targetImageView.layer.opacity = checkImageOpacity
            }, completion: { _ in
                animateCardOffScreen()
            })
        } else {
            animateCardOffScreen()
        }
    }
}

extension SwipeScreenVC: CardViewDelegate {
    func showLinkedinProfile(with url: String) {
        Utils.showWebViewController(on: self, with: url)
    }
}
