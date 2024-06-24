//
//  TabBarController.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = Constant.Color.secondary
        tabBar.tintColor = Constant.Color.theme
        
        let trendVC = UINavigationController(rootViewController: TrendViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        
        let trend = UITabBarItem(title: "TREND", image: Constant.Image.trend, tag: 0)
        let search = UITabBarItem(title: "SEARCH", image: Constant.Image.search, tag: 1)
        
        trendVC.tabBarItem = trend
        searchVC.tabBarItem = search
        
        setViewControllers([trendVC, searchVC], animated: true)
    }
}
