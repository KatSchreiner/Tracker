//
//  UITabBarController+extension.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 22.06.2024.
//

import UIKit

extension UITabBarController {
    func addTopBorderTabBar(color: UIColor, heigth: CGFloat) {
        let topBorderTabBar = CALayer()
        topBorderTabBar.backgroundColor = color.cgColor
        topBorderTabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: heigth)
        tabBar.layer.addSublayer(topBorderTabBar)
    }
}
