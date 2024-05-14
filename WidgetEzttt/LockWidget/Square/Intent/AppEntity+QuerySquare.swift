//
//  AppEntity+Query.swift
//  Wallpaper-WidgetExtension
//
//  Created by MAC on 24/11/2023.
//

import Foundation


import WidgetKit
import AppIntents
import SwiftUI

struct SquareSource: AppEntity {
    
    var id: String
    var actualName: String
    
    static var defaultQuery: SquareQuery = SquareQuery()
    
    func getCategory() -> CategoryLock? {
        return CoreDataService.shared.getLockCategory(name: actualName, family: .square)
    }
    
    func isCustomCoundown() -> Bool {
        guard let cate = getCategory() else { return false }
        
        return cate.isCustomCountdown
    }
    
    func getAlignment() -> AlignmentQuote {
        guard let cate = getCategory() else { return .center }
        
        return AlignmentQuote(rawValue: cate.alignment ?? "") ?? .center
    }
    
    func getTitleQuote() -> String {
        guard let cate = getCategory() else { return "" }
        
        return cate.unwrappedTitleQuote
    }
    
    static var defaultValue: SquareSource {
        return SquareSource(id: "choose", actualName: LockType.placeholder.rawValue)
    }
    
    func getSoundUrls() -> [URL] {
        guard let cate = getCategory() else { return [] }
        
        return CoreDataService.shared.getSounds(categoryLock: cate, family: .square)
    }
    
    func getFamilySizeType() -> FamilyTypeGifResonpse {
        guard let cate = getCategory() else { return .squareIcon }
        
        return FamilyTypeGifResonpse(rawValue: cate.unwrappedGroupSizeType) ?? .squareIcon
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
         
    func getImages() -> [UIImage] {
        guard let cate = getCategory() else { return [UIImage(named: AssetConstant.imagePlacehodel)!] }
        let images = CoreDataService.shared.getImages(categoryLock: cate, family: .square)
        
        return images
    }
    
    func getLockType() -> LockType {
        guard let cate = getCategory() else { return .placeholder }
        
        return LockType(rawValue: cate.unwrappedLockType) ?? .placeholder
    }
    
    func getSelectedBackgroundStyle() -> SelectedBackgroundStyle {
        guard let cate = getCategory() else { return .transparent }
        
        return SelectedBackgroundStyle(rawValue: Int(cate.backgroundStyle)) ?? .transparent
    }
    
    static func getSuggested() -> [SquareSource] {
        
        return CoreDataService.shared.getSuggestedName(isHome: false, familyLock: .square).map { name in
            return SquareSource(id: name, actualName: name)
        }
    }
    
    static func getAllSource() -> [SquareSource] {
        var src = getSuggested()
        src.append(SquareSource.defaultValue)
        return src
    }
    
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Image Viet"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
    
}

struct SquareQuery: EntityStringQuery {
    
    func entities(matching string: String) async throws -> [SquareSource] {
        let srcs = SquareSource.getAllSource().filter { imgsrc in
            return imgsrc.id == string
        }
        print("DEBUG: \(srcs.count) entitiesa")
        
        return srcs
    }
    
    
    func entities(for identifiers: [SquareSource.ID]) async throws -> [SquareSource] {
   
        let imgs = SquareSource.getAllSource().filter { imgsrc in
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
    
    func suggestedEntities() async throws -> [SquareSource] {
        return SquareSource.getSuggested()
    }
    
    func defaultResult() async -> SquareSource? {
        return SquareSource.defaultValue
    }
}

