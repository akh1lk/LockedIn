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
        
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.tintColor = UIColor.palette.purple
        self.tabBar.unselectedItemTintColor = UIColor.palette.gray
        
        setupTabs()
    }
    
    // MARK: - Setup Tabs
    private func createNav(with image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = image
//        nav.tabBarItem.title = title
        return nav
    }
    
    private func setupTabs() {
        let swipeScreen = self.createNav(with: UIImage(systemName: "n.square"), vc: SwipeScreenVC())
        let likeScreen = self.createNav(with: UIImage(systemName: "star.fill"), vc: LocationAccessVC())
        let chatScreen = self.createNav(with: UIImage(systemName: "ellipsis.message.fill"), vc: LocationAccessVC())
        let settings = self.createNav(with: UIImage(systemName: "person.fill"), vc: SettingsVC())
        
        self.setViewControllers([swipeScreen, likeScreen, chatScreen, settings], animated: true)
    }
}

