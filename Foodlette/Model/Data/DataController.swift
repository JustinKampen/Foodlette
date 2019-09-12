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
    
    init(modelName: String) {
        persistentController = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentController.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func saveViewContext() {
        try? viewContext.save()
    }
    
    static let shared = DataController(modelName: "Foodlette")
}
