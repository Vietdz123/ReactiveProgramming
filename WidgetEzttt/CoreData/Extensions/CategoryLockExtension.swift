//
//  CategoryLockExtension.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//


import SwiftUI
//
//extension CategoryLock {
//    
//    @NSManaged public var currentIndexDigitalFriend: Double
//    
//    public var unwrappedName: String {
//        name ?? "Unknown name"
//    }
//    
//    public var unwrappedLockType: String {
//        lockType ?? "Unknown name"
//    }
//    
//    public var unwrappedFamily: String {
//        familyType ?? "Unknown name"
//    }
//    
//    
//    public var unwrappedTextAlignment: String {
//        textAlignment ?? "Unknown name"
//    }
//    
//    public var unwrappedTextColor: String {
//        textColor ?? "Unknown name"
//    }
//    
//    public var unwrappedSoundType: String {
//        soundType ?? "Unknown name"
//    }
//    
//    public var unwrappedFontType: String {
//        fontType ?? "Unknown name"
//    }
//    
//    public var itemArray: [Item] {
//        
//        let itemSet = items as? Set<Item> ?? []
//        
//        return itemSet.sorted {
//            $0.creationDate < $1.creationDate
//        }
//    }
//    
//    func getItemFamily(filter: FamilyHome) -> [Item] {
//        
//        let itemSet = items as? Set<Item> ?? []
//        
//        let familyItem = itemSet.filter { item in
//            return item.unwrappedFamily.contains(filter.rawValue)
//        }
//        
//        return familyItem.sorted {
//            $0.creationDate < $1.creationDate
//        }
//    }
//    
//    func updateCurrentIndex(isRect: Bool = true)  {
//        if isRect {
//            if numberImagesRect <= 0 {  isFirstImage = true;  return }
//           
//           if currentIndexDigitalFriend < numberImagesRect - 1 {
//               currentIndexDigitalFriend += 1
//               isFirstImage = false
//               
//           } else {
//               currentIndexDigitalFriend = 0
//               isFirstImage = true
//           }
//        } else {
//            if numberImagesSquare <= 0 {  isFirstImage = true;  return }
//           
//           if currentIndexDigitalFriend < numberImagesSquare - 1 {
//               currentIndexDigitalFriend += 1
//               isFirstImage = false
//               
//           } else {
//               currentIndexDigitalFriend = 0
//               isFirstImage = true
//           }
//        }
//
//        
//        CoreDataService.shared.saveContext()
//    }
//    
//    func getCurrentImage(images: [UIImage]) -> UIImage {
//        if self.currentIndexDigitalFriend >= Double(images.count)  {
//            return images.count == 0 ? UIImage(named: AssetConstant.imagePlacehodel)! : images[0]
//        }
//        return images.count == 0 ? UIImage(named: AssetConstant.imagePlacehodel)! : images[Int(currentIndexDigitalFriend)]
//    }
//    
//    func getRandomImage(images: [UIImage]) -> UIImage {
//        return images.count == 0 ? UIImage(named: AssetConstant.imagePlacehodel)! : images.shuffled().first!
//    }
//    
//    func updateNumberRectImage(number: Double) {
//        
//        self.numberImagesRect = number
//        CoreDataService.shared.saveContext()
//        
//    }
//    
//    func updateNumberSquareImage(number: Double) {
//        
//        self.numberImagesSquare = number
//        CoreDataService.shared.saveContext()
//        
//    }
//
//}
