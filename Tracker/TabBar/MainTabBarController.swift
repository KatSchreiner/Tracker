//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 20.06.2024.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopBorderTabBar(color: .ypLightGray, heigth: 1.0)
        configureTabs()
    }
    
    private func configureTabs() {
        let trackersViewController = TrackersViewController()
        let statisticViewController = StatisticViewController()
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "ic_tabbar_tracker"),
            tag: 0)
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "ic_tabbar_statistic"),
            tag: 1)
        
//        let navigationController = MainNavigationController(rootViewController: trackerViewController)
        
        self.viewControllers = [trackersViewController, statisticViewController]
    }
}
