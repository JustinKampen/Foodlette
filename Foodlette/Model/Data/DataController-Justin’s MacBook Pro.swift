//
//  DataController.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/27/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    // -------------------------------------------------------------------------
    // MARK: - Data Controller Setup
    
    let persistentController: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentController.viewContext
    }
    
    //let backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistentController = NSPersistentContainer(name: modelName)
        //backgroundContext = persistentController.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        //backgroundContext.automaticallyMergesChangesFromParent = true
        //backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentController.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func saveContext() {
        let context = DataController.shared.persistentController.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
            }
        }
        
    }
    
    static let shared = DataController(modelName: "Foodlette")
}
