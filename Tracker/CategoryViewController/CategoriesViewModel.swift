import Foundation

final class CategoriesViewModel {
    private let categoryStore = TrackerCategoryStore()
    
    var categories = [String]() {
        didSet {
            onCategoriesChanged?()
            updatePlaceholderState()
        }
    }
    
    var onCategoriesChanged: (() -> Void)?
    var onPlaceholderStateChanged: ((Bool) -> Void)?
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    func viewDidLoad() {
        loadCategories()
    }
    
    func category(at index: Int) -> String {
        return categories[index]
    }
    
    func loadCategories() {
        let categoriesList = categoryStore.categories.map { $0.title }
        categories = categoriesList.filter { !$0.isEmpty }
    }
    
    func addCategory(_ category: String) {
        if !categories.contains(category) {
            categories.append(category)
        }
    }
    
    private func updatePlaceholderState() {
        let showPlaceholder = categories.isEmpty
        onPlaceholderStateChanged?(showPlaceholder)
    }
}
