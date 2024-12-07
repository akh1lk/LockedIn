//
//  SceneDelegate.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        Task {
            await self.checkAuthentication()
        }
    }
    
    private func setupWindow(with scene: UIScene) {
        // SceneDelgate setup window.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        windowScene.windows.first?.backgroundColor = .white
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    // MARK: - Auth & Animation Functions
       public func checkAuthentication() async {
           // Check if the user is logged in, removes all views from hierarchy.
           self.window?.rootViewController = nil
           self.window?.subviews.forEach { $0.removeFromSuperview() }
           
           let signInVC = LoginController() // TODO: change this to SignInVC
           let navigationController = UINavigationController(rootViewController: signInVC)
           self.window?.rootViewController = navigationController
           
           if let currentUser = Auth.auth().currentUser {
               NetworkManager.shared.checkUser(firebaseId: currentUser.uid) { exists in
                   if exists {
                       print("user exists!")
                       self.resetRootViewController()
                   } else {
                       print("user does not exist")
                       signInVC.navigationController?.pushViewController(SetupAccountVC(), animated: false)
                   }
               }
           }
       }
    
    /// Resets the root view controller to the TabController()
    func resetRootViewController(animated: Bool = true) {
        guard let window = self.window else { return }
        
        if animated {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.5
            window.layer.add(transition, forKey: kCATransition)
        }
        
        window.rootViewController = TabController()
    }
}

