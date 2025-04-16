//
//  MainTabBarVC.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: SearchVC())
        let vc3 = UINavigationController(rootViewController: SavedVC())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "bookmark")
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Saved"
        
        tabBar.tintColor = .label
        tabBar.isTranslucent = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()

        
        setViewControllers([vc1, vc2, vc3], animated: true)
        
    }

}
