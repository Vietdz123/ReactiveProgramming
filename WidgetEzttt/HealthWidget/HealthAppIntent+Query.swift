//
//  HealthAppIntent+Query.swift
//  WallPaper-CoreData
//
//  Created by MAC on 29/11/2023.
//

import WidgetKit
import AppIntents
import SwiftUI

struct HealthSource: AppEntity {
    
    var id: String
    var actualName: String
    
    static var defaultQuery: HealthQuery = HealthQuery()
    
    func getCategory() -> CategoryHome? {
        return CoreDataService.shared.getCategory(name: actualName)
    }
    
    static var defaultValue: HealthSource {
        return HealthSource(id: "choose", actualName: "choose")
    }
            
    func getImages(family: FamilyHome) -> [UIImage] {
        guard let cate = getCategory() else { return [UIImage(named: AssetConstant.imagePlacehodel)!] }
        let images = CoreDataService.shared.getImages(category: cate, family: family)
        
        return images
    }
    
    func getHealthType() -> HealthEnum {
        HealthEnum.getType(name: actualName)
    }
    
    static func getSuggested() -> [HealthSource] {
        
        return CoreDataService.shared.getSuggestedNameHealthItem().map { name in
            return HealthSource(id: name, actualName: name)
        }
    }
    
    static func getAllSource() -> [HealthSource] {
        var src = getSuggested()
        
        src.append(HealthSource.defaultValue)
        return src
    }
    
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Health Viet"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
}

struct HealthQuery: EntityStringQuery {
    
    func entities(matching string: String) async throws -> [HealthSource] {
        let srcs = HealthSource.getAllSource().filter { imgsrc in
            return imgsrc.id == string
        }
        
        return srcs
    }
    
    
    func entities(for identifiers: [ImageSource.ID]) async throws -> [HealthSource] {
   
        let imgs = HealthSource.getAllSource().filter { imgsrc in
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
    
    func suggestedEntities() async throws -> [HealthSource] {
        return HealthSource.getSuggested()
    }
    
    func defaultResult() async -> HealthSource? {
        return HealthSource.defaultValue
    }
    
}


