//
//  CategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 17.07.2024.
//

import Foundation

protocol CategoryViewControllerDelegate: AnyObject {
    func sendSelectedCategory(selectedCategory: String)
}
