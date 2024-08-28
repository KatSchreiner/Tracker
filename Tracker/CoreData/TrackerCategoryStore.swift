import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    // MARK: - Public Properties
    var categories: [TrackerCategory] { return fetchAllCategories() }
    var trackers: [Tracker] = []
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var trackerStore = TrackerStore()
    private let weekDayTransformer = WeekDayTransformer()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]
        
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Ошибка при выполнении fetch: \(error.localizedDescription)")
        }
        
        return fetchedResultController
    }()
    
    // MARK: - Initializers
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Невозможно привести UIApplication.shared.delegate к AppDelegate") }
                
        self.init(context: appDelegate.persistentContainer.viewContext)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public Methods
    func saveCategoryToCoreData(title: String) throws {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        let categories = try context.fetch(fetchRequest)
        
        if let existingCategory = categories.first {
            print("[TrackerCategoryStore: saveCategoryToCoreData] - Категория уже существует")
            return
        }
        
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = title
        categoryCoreData.tracker = NSSet()
        
        try context.save()
    }
    
    func deleteCategoryFromCoreData(title: String, tracker: Tracker) throws {
        let coreData = try fetchCategoryByTitle(title: title)
        
        var existingTrackers: [TrackerCoreData] = []
        
        if let allObjects = coreData.tracker?.allObjects as? [TrackerCoreData] {
                    existingTrackers = allObjects
                } else {
                    print("Не удалось получить трекеры для категории '\(title)'.")
                    return
                }
        
        if let index = existingTrackers.firstIndex(where: { $0.id == tracker.id }) {
            existingTrackers.remove(at: index)
            print("Трекер с id: \(tracker.id) успешно удален из категории '\(title)'.")
        } else {
            print("Трекер с id: \(tracker.id) не найден в категории '\(title)'.")
        }
        
        coreData.tracker = NSSet(array: existingTrackers)
        
        try context.save()
        print("Остальные трекеры сохранены. Количество трекеров в категории '\(title)': \(existingTrackers.count)")
        
        if existingTrackers.isEmpty {
            context.delete(coreData)
            do {
                try context.save()
                print("Категория '\(title)' успешно удалена, так как в ней не осталось трекеров.")
            } catch {
                context.rollback()
                print("Не удалось сохранить изменения. Ошибка: \(error.localizedDescription)")
            }
        } else {
            print("Категория '\(title)' не пуста и не может быть удалена.")
        }
    }
    
    func fetchCategoryByTitle(title: String) throws -> TrackerCategoryCoreData {
        return try fetchCategory(where: "title == %@", title)
    }
    
    private func fetchCategory(where predicateFormat: String, _ args: CVarArg...) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: predicateFormat, argumentArray: args)
        
        let categories = try context.fetch(request)
        
        guard let category = categories.first else {
            throw TrackerCategoryStoreError.fetchCategoryByTitleError(description: "Категория с таким названием не найдена")
        }
        return category
    }
    
    func fetchCategoryForTracker(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard
            let title = trackerCategoryCoreData.title,
            let trackerCoreDataSet = trackerCategoryCoreData.tracker as? Set<TrackerCoreData>
        else {
            throw TrackerCategoryStoreError.fetchCategoryForTrackerError(description: "Категория с данным идентификатором не найдена.")
        }
        
        trackers = try trackerCoreDataSet.map { try trackerStore.fetchTrackerFromTrackersArray(from: $0) }
        
        return TrackerCategory(title: title, trackers: trackers)
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        guard let objects = self.fetchedResultsController.fetchedObjects else { return [] }
        
        return objects.compactMap { try? self.fetchCategoryForTracker(from: $0) }
    }
}

enum TrackerCategoryStoreError: Error {
    case fetchCategoryByTitleError(description: String)
    case fetchCategoryForTrackerError(description: String)
}
