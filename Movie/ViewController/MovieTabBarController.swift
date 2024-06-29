//
//  TabBarController.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import UIKit

class MovieTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = Constant.Color.secondary
        tabBar.tintColor = Constant.Color.theme
        
        let trendVC = UINavigationController(rootViewController: TrendViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let latestVC = UINavigationController(rootViewController: LatestViewController())
        
        let trend = UITabBarItem(title: "TREND", image: Constant.Image.trend, tag: 0)
        let search = UITabBarItem(title: "SEARCH", image: Constant.Image.search, tag: 1)
        let latest = UITabBarItem(title: "NEW&HOT", image: UIImage(systemName: "star"), tag: 2)
        
        trendVC.tabBarItem = trend
        searchVC.tabBarItem = search
        latestVC.tabBarItem = latest

        setViewControllers([trendVC, searchVC, latestVC], animated: true)
    }
}
