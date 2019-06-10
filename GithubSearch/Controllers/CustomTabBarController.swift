//
//  CustomTabBarViewController.swift
//  GithubSearch
//
//  Created by SIMA on 11/06/2019.
//  Copyright © 2019 TJ. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchVC = SearchViewController()
        let likeVC = LikeViewController()
        
        let searchNavigationController = UINavigationController(rootViewController: searchVC)
        searchNavigationController.title = "Home"
        searchNavigationController.tabBarItem.image = UIImage(named: "BlackHome")
        
        let likeNavigationController = UINavigationController(rootViewController: likeVC)
        likeNavigationController.title = "Like"
        likeNavigationController.tabBarItem.image = UIImage(named: "Like")
        
        viewControllers = [searchNavigationController, likeNavigationController]
    }
    
}
