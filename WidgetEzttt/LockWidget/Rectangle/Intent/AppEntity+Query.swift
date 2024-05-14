//
//  AppEntity+Query.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//


import WidgetKit
import AppIntents
import SwiftUI

struct RectSource: AppEntity {
    
    var id: String
    var actualName: String
    
    static var defaultQuery: RectQuery = RectQuery()
    
    func getCategory() -> CategoryLock? {
        return CoreDataService.shared.getLockCategory(name: actualName, family: .rectangle)
    }
    
    func isCustomCoundown() -> Bool {
        guard let cate = getCategory() else { return false }
        
        return cate.isCustomCountdown
    }
    
    func getAlignment() -> AlignmentQuote {
        guard let cate = getCategory() else { return .center }
        
        return AlignmentQuote(rawValue: cate.alignment ?? "") ?? .center
    }
    
    func isCustomCountdown() -> Bool {
        guard let cate = getCategory() else { return false }
        
        return cate.isCustomCountdown
    }
    
    func getTitleQuote() -> String {
        guard let cate = getCategory() else { return "" }
        
        return cate.unwrappedTitleQuote
    }
    
    static var defaultValue: RectSource {
        return RectSource(id: "choose", actualName: LockType.placeholder.rawValue)
    }
    
    func getSoundUrls() -> [URL] {
        guard let cate = getCategory() else { return [] }
        
        return CoreDataService.shared.getSounds(categoryLock: cate, family: .rectangle)
    }
    
         
    func getImages() -> [UIImage] {
        guard let cate = getCategory() else { return [UIImage(named: AssetConstant.imagePlacehodel)!] }
        let images = CoreDataService.shared.getImages(categoryLock: cate, family: .rectangle)
    
        return images
    }
    
    func getTimeDesitnation() -> Double {
        guard let cate = getCategory() else { return 1 }
        
        return cate.timeDestination
    }
    
    func getFontName() -> String {
        guard let cate = getCategory() else { return "" }
        
        return cate.unwrappedFontName
    }
    
    func getFontSize() -> Double {
        guard let cate = getCategory() else { return 40 }
        
        return cate.fontSize
    }
    
    func getLockType() -> LockType {
        guard let cate = getCategory() else { return .placeholder }
        
        return LockType(rawValue: cate.unwrappedLockType) ?? .placeholder
    }
    
    func getSelectedBackgroundStyle() -> SelectedBackgroundStyle {
        guard let cate = getCategory() else { return .transparent }
        
        return SelectedBackgroundStyle(rawValue: Int(cate.backgroundStyle)) ?? .transparent
    }
    
    static func getSuggested() -> [RectSource] {
        
        return CoreDataService.shared.getSuggestedName(isHome: false, familyLock: .rectangle).map { name in
            return RectSource(id: name, actualName: name)
        }
    }
    
    static func getAllSource() -> [RectSource] {
        var src = getSuggested()
        src.append(RectSource.defaultValue)
        return src
    }
    
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Image Viet"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
}

struct RectQuery: EntityStringQuery {
    
    func entities(matching string: String) async throws -> [RectSource] {
        let srcs = RectSource.getAllSource().filter { imgsrc in
            return imgsrc.id == string
        }
        print("DEBUG: \(srcs.count) entitiesa")
        
        return srcs
    }
    
    
    func entities(for identifiers: [RectSource.ID]) async throws -> [RectSource] {
   
        let imgs = RectSource.getAllSource().filter { imgsrc in
            return identifiers.contains { id in
                return id == imgsrc.id
            }
        }
        
        if imgs.count > 0 {
            return [imgs[0]]
        } else {
            return []
        }
        
    }
    
    func suggestedEntities() async throws -> [RectSource] {
        return RectSource.getSuggested()
    }
    
    func defaultResult() async -> RectSource? {
        return RectSource.defaultValue
    }
}

