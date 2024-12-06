//
//  SceneDelegate.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/29/24.
//

import UIKit
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let signInVC = SignInVC() // TODO: change this to SignInVC
        let navigationController = UINavigationController(rootViewController: signInVC)
        
        let window = UIWindow(windowScene: windowScene)
        
        
        window.rootViewController = TabController() // navigationController //  // TODO: Change this to navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
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

