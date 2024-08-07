//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 04.08.2024.
//

import Foundation

final class CategoriesViewModel {
    private let categoryStore = TrackerCategoryStore()
    
    var categories = [String]()
    
    var onCategoriesChanged: (() -> Void)?
    var onCategoryAdded: (() -> Void)?
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    func category(at index: Int) -> String {
        return categories[index]
    }
    
    func loadCategories() {
        let categoriesList = categoryStore.categories.map { $0.title }
        categories = categoriesList.filter { !$0.isEmpty }
        onCategoriesChanged?()
    }
    
    func addCategory(_ category: String) {
        if !categories.contains(category) {
            categories.append(category)
        }
        onCategoryAdded?()
    }
}
