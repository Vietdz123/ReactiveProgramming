//
//  CoreDataService.swift
//  WallPaper-CoreData
//
//  Created by MAC on 13/11/2023.
//

import SwiftUI
import CoreData

class CoreDataService {
    
    let context = DataController().container.viewContext
    
    static let shared = CoreDataService()
    
    //MARK: - Home
    func getAllCategory() -> [CategoryHome] {
        let request = CategoryHome.fetchRequest()
        
        do {
            let categories = try context.fetch(request)
            return categories
        } catch {
            return []
        }
    }
    

    
    func getSuggestedName(isHome: Bool = true, familyLock: FamilyLock = .rectangle) -> [String] {
        if isHome {
            let categories = getAllCategory()
            
            let names =  categories.map { $0.unwrappedName }
            return names
        } else {
            return []
        }

    }
    
    func getImages(category: CategoryHome, family: FamilyHome) -> [UIImage] {
        
        let items = category.itemArray
        var images: [UIImage] = []
        
        var filterItems = items.filter { item in
            return item.unwrappedFamily == family.rawValue
        }
        
        filterItems = filterItems.sorted { $0.creationDate < $1.creationDate }

        filterItems.forEach { item in
            guard let image = FileService.shared.readImage(with: category.unwrappedName, item: item) else { return }
            images.append(image)

        }
        
        
        return images
    }
    


    
    func getCategory(name: String) -> CategoryHome? {
        
        let query = NSPredicate(format: "%K == %@", #keyPath(CategoryHome.name), name)
        let request: NSFetchRequest<CategoryHome> = CategoryHome.fetchRequest()
        request.predicate = query
        
        guard let category = try? context.fetch(request).first else { return nil }
        return category
    }
    

    
    func getFolderType(with nameFolder: String) -> WDHomeFolderType {
        return WDHomeFolderType.getType(name: nameFolder)
    }
    
    func getRoutineType(with nameRoutine: String) -> RoutinMonitorType {
        return RoutinMonitorType.getType(name: nameRoutine)
    }
    
    func getDigitalType(with nameDigital: String) -> DigitalFriendType {
        return DigitalFriendType.getType(name: nameDigital)
    }
    
    func getSoundType(with nameSound: String) -> SoundType {
        return SoundType.getType(name: nameSound)
    }
    
    func getSounds(category: CategoryHome, family: FamilyHome) -> [URL] {
        let items = category.itemArray
        
        let filterItems = items.filter { item in
            return item.unwrappedFamily == family.rawValue
        }
        
        var urls: [URL] = []
        filterItems.forEach { item in
            guard let url = FileService.shared.readUrls(with: category.unwrappedName, item: item) else { return }
            urls.append(url)
        }
        
        return urls
    }
    

    
    func getButtonCheckListModel(category: CategoryHome) -> ButtonCheckListModel {
        
        let items = category.itemArray
        
        let checkItems = items.filter { item in
            return item.unwrappedFamily == FamilyHome.check.rawValue
        }
        
        let uncheckItems = items.filter { item in
            return item.unwrappedFamily == FamilyHome.uncheck.rawValue
        }
        
        var checkImages: [UIImage] = []
        var uncheckImages: [UIImage] = []
        
        checkItems.forEach { item in
            guard let image = FileService.shared.readImage(with: category.unwrappedName, item: item) else { return }
            checkImages.append(image)
        }
        
        uncheckItems.forEach { item in
            guard let image = FileService.shared.readImage(with: category.unwrappedName, item: item) else { return }
            uncheckImages.append(image)
        }
        
        return ButtonCheckListModel(checkImage: checkImages, uncheckImage: uncheckImages)
    }

}


// MARK: - Private
extension CoreDataService {
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                
            } catch {
                print("DEBUG: fatal error \(error.localizedDescription)")
//                fatalError("fatal \(error.localizedDescription)")
                
            }
        }
    }
    
}
