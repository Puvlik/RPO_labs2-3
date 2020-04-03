import UIKit
import CoreData

final class CoreDataHelper {
    private init() {}
    static let shared = CoreDataHelper()
    
    func saveData(data: [String: String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("can't save data")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
            print("can't save data")
            return
        }
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(data["label"], forKeyPath: "label")
        person.setValue(data["image"], forKeyPath: "image")
        person.setValue(data["time"], forKeyPath: "time")
        person.setValue(data["weight"], forKeyPath: "weight")
        person.setValue(data["calories"], forKeyPath: "calories")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    func getData(completion: @escaping (_ error: String?, _ data: [[String: String]]?) -> ()) {
        var result = [[String: String]]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion("can't save data", nil)
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            let entries = try managedContext.fetch(fetchRequest) as? [User]
            for entry in entries ?? [] {
                let keys = Array(entry.entity.attributesByName.keys)
                guard let dict = entry.dictionaryWithValues(forKeys: keys) as? [String: String] else { return }
                result.append(dict)
            }
            completion(nil, result)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
