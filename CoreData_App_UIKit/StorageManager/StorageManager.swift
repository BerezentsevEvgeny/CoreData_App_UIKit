//
//  StorageManager.swift
//  CoreData_App_UIKit
//
//  Created by Евгений Березенцев on 03.01.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack

    var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreData_App_UIKit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    let context: NSManagedObjectContext
    
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createCar(with name: String, year: Int64) {
        guard let description = NSEntityDescription.entity(forEntityName: "Car", in: context) else { return }
        guard let car = NSManagedObject(entity: description, insertInto: context) as? Car else { return }
        car.name = name
        car.year = year
        saveContext()
    }
    
    func fetch(completion: (Result<[Car],Error>)->Void) {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        do {
            let cars = try persistentContainer.viewContext.fetch(fetchRequest)
            completion(.success(cars))
        } catch let error {
            completion(.failure(error))
        }
    }
    

    
    
    
    
    
    
}

