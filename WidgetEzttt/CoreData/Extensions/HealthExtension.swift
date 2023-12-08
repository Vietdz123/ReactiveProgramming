//
//  HealthExtension.swift
//  WallPaper-CoreData
//
//  Created by MAC on 29/11/2023.
//

import Foundation
import CoreData

extension HealthItem {
    
    public var unwrappedName: String {
        name ?? "Unknown name"
    }
    
}

extension CoreDataService {
    
    func saveHealthItem(name: String) {
        
        let queryFamily = NSPredicate(format: "%K == %@", #keyPath(HealthItem.name), name)
        
        let request: NSFetchRequest<HealthItem> = HealthItem.fetchRequest()
        request.predicate = queryFamily
        
        if let _ = try? context.fetch(request).first  {
            return
        }
        
        let item = HealthItem(context: context)
        item.name = name
        saveContext()

    }
    
    func loadSuggestHealthItem() -> [HealthItem] {
        let request = HealthItem.fetchRequest()
        
        do {
            let items = try context.fetch(request)
            return items
        } catch {
            return []
        }
    }
    
    func getSuggestedNameHealthItem() -> [String] {
        let request = HealthItem.fetchRequest()
        
        do {
            let items = try context.fetch(request)
            let names = items.map { $0.unwrappedName }
            return names
        } catch {
            return []
        }
    }
 
}
