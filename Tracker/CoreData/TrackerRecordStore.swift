import CoreData
import UIKit

protocol TrackerRecordStoreDelegate: AnyObject {
    func recordDidChange()
}

final class TrackerRecordStore: NSObject {
    // MARK: - Public Properties
    weak var delegate: TrackerRecordStoreDelegate?
    
    var trackerRecord: [TrackerRecord] { return fetchAllTrackersRecord() }
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]
        
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Невозможно привести UIApplication.shared.delegate к AppDelegate") }
        
        self.init(context: appDelegate.persistentContainer.viewContext)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public Methods
    func addRecordToCompletedTrackers(trackerId: UUID, date: Date) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        
        trackerRecordCoreData.trackerId = trackerId
        trackerRecordCoreData.date = date
        
        let trackerStore = TrackerStore(context: context)
        
        do {
            let trackerRecord = try trackerStore.fetchTrackerById(id: trackerId)
            trackerRecordCoreData.trackerRecord = trackerRecord
            
        } catch {
            throw TrackerRecordStoreError.addRecordToCompletedTrackersError(description: "Ошибка записи трекера")
        }
        
        try context.save()
    }
    
    func removeRecordFromCompletedTrackers(trackerId: UUID, date: Date) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", trackerId as CVarArg, date as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let trackerRecordCoreData = results.first {
                context.delete(trackerRecordCoreData)
                try context.save()
            } else {
                throw TrackerRecordStoreError.removeRecordFromCompletedTrackersError(description: "Не удалось найти запись трекера для удаления")
            }
        } catch {
            throw TrackerRecordStoreError.removeRecordFromCompletedTrackersError(description: "Ошибка при удалении записи трекера: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Methods
    private func fetchTrackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let id = trackerRecordCoreData.trackerId,
            let date = trackerRecordCoreData.date
        else {
            throw TrackerRecordStoreError.fetchTrackerRecordError(description: "Ошибка получения записи трекера")
        }
        return TrackerRecord(trackerId: id, date: date)
    }
    
    func fetchAllTrackersRecord() -> [TrackerRecord] {
        guard let trackerRecordsCoreData = fetchedResultsController.fetchedObjects else { return [] }
        return trackerRecordsCoreData.compactMap { try? fetchTrackerRecord(from: $0) }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.recordDidChange()
    }
}

enum TrackerRecordStoreError: Error {
    case addRecordToCompletedTrackersError(description: String)
    case removeRecordFromCompletedTrackersError(description: String)
    case fetchTrackerRecordError(description: String)
}
