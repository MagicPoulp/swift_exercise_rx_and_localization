//
//  PersistentStorageManager.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-14.
//

import Foundation
import UIKit
import CoreData

// https://www.raywenderlich.com/7569-getting-started-with-core-data-tutorial#toc-anchor-003
class PersistenceStorageManager {

    func save(language: String) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext

        // if the entity exists we must update it
        // https://stackoverflow.com/questions/42294358/overwrite-on-core-data-value
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GlobalDataEntity")
        do {
            let fetchResults = try managedContext.fetch(request)
            let languageMO: NSManagedObject
            // 2
            if fetchResults.isEmpty {
                let entity = NSEntityDescription.entity(forEntityName: "GlobalDataEntity", in: managedContext)
                languageMO = NSManagedObject(entity: entity!, insertInto: managedContext)
            } else {
                languageMO = fetchResults[0] as! NSManagedObject
            }
            // 3
            languageMO.setValue(language, forKeyPath: "language")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func getSavedManagedObject() -> NSManagedObject? {
        //1
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "GlobalDataEntity")
        
        //3
        do {
            let context: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            if (context.count > 0) {
                return context[0]
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func getSavedLanguage() -> String? {
        guard let languageMO = getSavedManagedObject() else {
            return nil
        }
        guard let language = languageMO.value(forKey: "language") else {
            return nil
        }
        return language as! String?
    }
}
