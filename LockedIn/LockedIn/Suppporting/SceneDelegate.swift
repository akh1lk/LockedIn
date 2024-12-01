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
        
        let signInVC = SwipeScreenVC() // TODO: change this to SignInVC
        let navigationController = UINavigationController(rootViewController: signInVC)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    /// Change the root view controller
    func changeRootViewController(to viewController: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        
        if animated {
            let transition = CATransition()
            transition.type = .fade
            transition.duration = 0.3
            window.layer.add(transition, forKey: kCATransition)
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
}

