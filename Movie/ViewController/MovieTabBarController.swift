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
        tabBar.tintColor = Constant.Color.black
        
        let trendVC = UINavigationController(rootViewController: TrendViewController())
        let latestVC = UINavigationController(rootViewController: LatestViewController())
        
        let trend = UITabBarItem(
            title: "TREND",
            image: Constant.Image.trend,
            tag: 0
        )
        
        let latest = UITabBarItem(
            title: "NEW&HOT",
            image: Constant.Image.latest,
            tag: 2
        )
        
        trendVC.tabBarItem = trend
        latestVC.tabBarItem = latest

        setViewControllers([trendVC, latestVC], animated: true)
    }
}
