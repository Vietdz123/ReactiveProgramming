//
//  CategoryExtension.swift
//  WallPaper-CoreData
//
//  Created by MAC on 13/11/2023.
//

import SwiftUI

extension CategoryHome {
    
    @NSManaged public var currentCheckImageRoutine: [Double]
    @NSManaged public var isCheckedRoutine: [Bool]
    
    public var unwrappedName: String {
        name ?? "Unknown name"
    }
    
    public var unwrappedFolder: String {
        folderType ?? "Unknown name"
    }
    
    public var unwrappedRoutineType: String {
        routineType ?? "Unknown name"
    }
    
    public var unwrappedDigitalType: String {
        digitalType ?? "Unknown name"
    }
    
    public var unwrappedSoundType: String {
        soundType ?? "Unknown name"
    }
    
    public var itemArray: [ItemHome] {
        
        let itemSet = items as? Set<ItemHome> ?? []
        
        return itemSet.sorted {
            $0.creationDate < $1.creationDate
        }
    }
    
    func getItemFamily(filter: FamilyHome) -> [ItemHome] {
        
        let itemSet = items as? Set<ItemHome> ?? []
        
        let familyItem = itemSet.filter { item in
            return item.unwrappedFamily.contains(filter.rawValue)
        }
        
        return familyItem.sorted {
            $0.creationDate < $1.creationDate
        }
    }
    
    func updateCurrentIndex(isRect: Bool = true)  {
        if isRect {
            if numberImagesRect <= 0 {  isFirstImage = true;  return }
           
           if currentIndexDigitalFriend < numberImagesRect - 1 {
               currentIndexDigitalFriend += 1
               isFirstImage = false
               
           } else {
               currentIndexDigitalFriend = 0
               isFirstImage = true
           }
        } else {
            if numberImagesSquare <= 0 {  isFirstImage = true;  return }
           
           if currentIndexDigitalFriend < numberImagesSquare - 1 {
               currentIndexDigitalFriend += 1
               isFirstImage = false
               
           } else {
               currentIndexDigitalFriend = 0
               isFirstImage = true
           }
        }

        
        CoreDataService.shared.saveContext()
    }
    
    func getCurrentImage(images: [UIImage]) -> UIImage {
        if self.currentIndexDigitalFriend >= Double(images.count)  {
            return images.count == 0 ? UIImage(named: AssetConstant.imagePlacehodel)! : images[0]
        }
        return images.count == 0 ? UIImage(named: AssetConstant.imagePlacehodel)! : images[Int(currentIndexDigitalFriend)]
    }
    
    func getRandomImage(images: [UIImage]) -> UIImage {
        return images.count == 0 ? UIImage(named: AssetConstant.imagePlacehodel)! : images.shuffled().first!
    }
    
    func updateNumberCheckedImage(number: Double) {
        
        self.numberCheckedImages = number
        CoreDataService.shared.saveContext()
        
    }
    
    func updateNumberRectImage(number: Double) {
        
        self.numberImagesRect = number
        CoreDataService.shared.saveContext()
        
    }
    
    func updateNumberSquareImage(number: Double) {
        
        self.numberImagesSquare = number
        CoreDataService.shared.saveContext()
        
    }

}

class ArrayDoubleTransformer: ValueTransformer {
    /// Dùng để convert `Type` sang `Data`.
    override func transformedValue(_ value: Any?) -> Any? {
        guard let dataArray = value as? Array<Double> else { return nil }
        do {
          let data = try NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
            return data
        } catch {
          return nil
        }
    }

    /// Dùng để convert `Data` sang `Type`.
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let image = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data) as? [Double]
            return image
        } catch {
            return nil
        }
    }
}

class ArrayBoolTransformer: ValueTransformer {
    /// Dùng để convert `Type` sang `Data`.
    override func transformedValue(_ value: Any?) -> Any? {
        guard let dataBool = value as? Array<Bool> else { return nil }
        do {
          let data = try NSKeyedArchiver.archivedData(withRootObject: dataBool, requiringSecureCoding: true)
            return data
        } catch {
          return nil
        }
    }

    /// Dùng để convert `Data` sang `Type`.
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let image = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data) as? [Bool]
            return image
        } catch {
            return nil
        }
    }
}
