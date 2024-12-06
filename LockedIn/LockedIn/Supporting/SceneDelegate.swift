//
//  SceneDelegate.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let user = User(id: 24, linkedinUrl: "noob", name: "Diddy", goals: "Sports,Child,Network,Like", interests: "Tennis,Volley,Coding", university: "Cornell", major: "Computer Science", company: "Amazon", jobTitle: "Worker", experience: "I like smell.", location: "Noob", crackedRating: "35")
        
        let signInVC = UserInfoVC(for: user) // TODO: change this to SignInVC
        let navigationController = UINavigationController(rootViewController: signInVC)
        
        let window = UIWindow(windowScene: windowScene)
        
        
        window.rootViewController = navigationController //  // TODO: Change this to navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    /// Resets the root view controller to the TabController()
    func resetRootViewController(animated: Bool = true) {
        guard let window = self.window else { return }
        
        if animated {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            window.layer.add(transition, forKey: kCATransition)
        }
        
        window.rootViewController = TabController()
    }
}

