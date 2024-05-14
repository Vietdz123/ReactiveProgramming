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

struct InlineSource: AppEntity {
    
    var id: String
    var actualName: String
    
    static var defaultQuery: InlineQuery = InlineQuery()
    
    func getCategory() -> CategoryLock? {
        return CoreDataService.shared.getLockCategory(name: actualName, family: .inline)
    }
    
    static var defaultValue: InlineSource {
        return InlineSource(id: "choose", actualName: LockType.placeholder.rawValue)
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
    
    static func getSuggested() -> [InlineSource] {
        
        return CoreDataService.shared.getSuggestedName(isHome: false, familyLock: .inline).map { name in
            return InlineSource(id: name, actualName: name)
        }
    }
    
    static func getAllSource() -> [InlineSource] {
        var src = getSuggested()
        src.append(InlineSource.defaultValue)
        return src
    }
    
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Image Viet"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
    
}

struct InlineQuery: EntityStringQuery {
    
    func entities(matching string: String) async throws -> [InlineSource] {
        let srcs = InlineSource.getAllSource().filter { imgsrc in
            return imgsrc.id == string
        }
        
        return srcs
    }
    
    
    func entities(for identifiers: [ImageSource.ID]) async throws -> [InlineSource] {
   
        let imgs = InlineSource.getAllSource().filter { imgsrc in
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
    
    func suggestedEntities() async throws -> [InlineSource] {
        return InlineSource.getSuggested()
    }
    
    func defaultResult() async -> InlineSource? {
        return InlineSource.defaultValue
    }
}

