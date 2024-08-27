import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureTabs()
    }
    
    private func configureTabs() {
        let trackersViewController = TrackersViewController()
        let statisticViewController = StatisticViewController()
        
        trackersViewController.tabBarItem = UITabBarItem(
            title: "trackers".localized(),
            image: UIImage(named: "ic_tabbar_tracker"),
            tag: 0)
        
        statisticViewController.tabBarItem = UITabBarItem(
            title: "statistics".localized() ,
            image: UIImage(named: "ic_tabbar_statistic"),
            tag: 1)
        
        let navigationTrackersViewController = UINavigationController(rootViewController: trackersViewController)
        let navigationStatisticViewController = UINavigationController(rootViewController: statisticViewController)
        
        self.viewControllers = [navigationTrackersViewController, navigationStatisticViewController]
    }
    
    private func setupView() {
        tabBar.backgroundColor = .clear
        tabBar.unselectedItemTintColor = .yGray
        
        let topBorderTabBar = CALayer()
        topBorderTabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 1.0)
        topBorderTabBar.backgroundColor = UIColor.black.withAlphaComponent(0.3).cgColor
        tabBar.layer.addSublayer(topBorderTabBar)
    }
}
