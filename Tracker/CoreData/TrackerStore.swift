import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func trackerStoreDidChange(_ store: TrackerStore)
}

final class TrackerStore: NSObject {
    
    // MARK: - Public Properties
    weak var delegate: TrackerStoreDelegate?
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private let weekDayTransformer = WeekDayTransformer()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)]
        
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Ошибка при выполнении fetch: \(error.localizedDescription)")
        }
        
        return fetchedResultController
    }()
    
    // MARK: - Initializers
    convenience override init() {
        self.init(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public Methods
    func saveTrackerToCoreData(tracker: Tracker, category: String) throws {
        do {
            let categoryData = try fetchCategoryByTitle(title: category)
            let trackerCoreData = createTrackerCoreData(from: tracker, category: categoryData)
            
            try context.save()
            print("Tracker saved: \(tracker)")
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }
        
    
    func deleteTrackerFromCoreData(id: UUID) throws {
        let trackerCoreData = try fetchTrackerById(id: id)
        
        context.delete(trackerCoreData)
        do {
            try context.save()
            print("Трекер с id: \(id) успешно удален из Core Data.")
        } catch {
            context.rollback()
            print("Не удалось сохранить изменения. Ошибка: \(error.localizedDescription)")
        }
    }
    
    func updateTracker(_ tracker: Tracker, _ category: String) throws {
        let existingTracker = try fetchTrackerById(id: tracker.id)
        
        existingTracker.name = tracker.name
        existingTracker.emoji = tracker.emoji
        existingTracker.color = UIColorMarshalling.hexString(from: tracker.color)
        existingTracker.schedule = weekDayTransformer.transformedValue(tracker.schedule) as? NSObject
        
        let existingCategory = try fetchCategoryByTitle(title: category)
        existingTracker.category = existingCategory
        
        do {
            try context.save()
            print("Трекер с id: \(tracker.id) успешно обновлен в Core Data.")
        } catch {
            context.rollback()
            throw TrackerStoreError.fetchTrackerByIdError(description: "Не удалось обновить трекер. Ошибка: \(error.localizedDescription)")
        }
    }
    
    func fetchTrackerById(id: UUID) throws -> TrackerCoreData {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let trackers = try context.fetch(request)
        
        guard let tracker = trackers.first else {
            throw TrackerStoreError.fetchTrackerByIdError(description: "Трекер с данным идентификатором не найден")
        }
        
        return tracker
    }
    
    func fetchTrackerFromTrackersArray(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
              let name = trackerCoreData.name,
              let emoji = trackerCoreData.emoji,
              let color = trackerCoreData.color else {
            throw TrackerStoreError.fetchTracker(description: "Трекер не имеет необходимых данных.")
        }
        
        let colorConverted = UIColorMarshalling.color(from: color)
        let schedule = weekDayTransformer.reverseTransformedValue(trackerCoreData.schedule) as! [WeekDay]
        
        return Tracker(
            id: id,
            name: name,
            color: colorConverted,
            emoji: emoji,
            schedule: schedule,
            typeTracker: .habit, 
            isPinned: false
        )
    }
    
    // MARK: - Private Methods
    private func fetchCategoryByTitle(title: String) throws -> TrackerCategoryCoreData {
        let categoryStore = TrackerCategoryStore(context: context)
        return try categoryStore.fetchCategoryByTitle(title: title)
    }
    
    private func createTrackerCoreData(from tracker: Tracker, category: TrackerCategoryCoreData) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = UIColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = weekDayTransformer.transformedValue(tracker.schedule) as? NSObject
        trackerCoreData.category = category 
        
        return trackerCoreData
    }
    
    func pinTracker(id: UUID) throws {
        let trackerCoreData = try fetchTrackerById(id: id)
        trackerCoreData.isPinned = true
        try context.save()
    }
    
    func unpinTracker(id: UUID) throws {
        let trackerCoreData = try fetchTrackerById(id: id)
        trackerCoreData.isPinned = false
        try context.save()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerStoreDidChange(self)
    }
}

enum TrackerStoreError: Error {
    case fetchTrackerByIdError(description: String)
    case fetchTracker(description: String)
}
