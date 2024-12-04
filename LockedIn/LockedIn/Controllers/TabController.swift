//
//  TabController.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

/// Root view controller that controls the tab bar.
class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.tintColor = UIColor.palette.purple
        self.tabBar.unselectedItemTintColor = UIColor.palette.gray
        
        setupTabs()
    }
    
    // MARK: - Setup Tabs
    private func createNav(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        return nav
    }
    
    private func setupTabs() {
        let swipeScreen = self.createNav(title: "Home", image: UIImage(systemName: "n.square"), vc: SwipeScreenVC())

        let chatScreen = self.createNav(title: "Chat", image: UIImage(systemName: "ellipsis.message.fill"), vc: ChatVC(with: Sender(senderId: "ye", displayName: "ye")))
        let settings = self.createNav(title: "Profile", image: UIImage(systemName: "person.fill"), vc: SettingsVC())
        
        self.setViewControllers([swipeScreen, chatScreen, settings], animated: true)
    }
}

