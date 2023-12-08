//
//  AppIntent+Query.swift
//  WallPaper
//
//  Created by MAC on 31/10/2023.
//

import WidgetKit
import AppIntents
import SwiftUI

struct ImageSource: AppEntity {
    
    var id: String
    var actualName: String
    
    static var defaultQuery: ImageQuery = ImageQuery()
    
    func getCategory() -> CategoryHome? {
        return CoreDataService.shared.getCategory(name: actualName)
    }
    
    static var defaultValue: ImageSource {
        return ImageSource(id: "choose", actualName: WDHomeFolderType.placeholder.rawValue)
    }
    
    func getSoundUrls(family: FamilyHome) -> [URL] {
        guard let cate = getCategory() else { return [] }
        
        return CoreDataService.shared.getSounds(category: cate, family: family)
    }
    
    func getButtonChecklistModel() -> ButtonCheckListModel {
        guard let cate = getCategory() else { return ButtonCheckListModel() }
        
        return CoreDataService.shared.getButtonCheckListModel(category: cate)
    }
    
    func getRoutineType() -> RoutinMonitorType {
        guard let cate = getCategory() else { return .single }
        
        return CoreDataService.shared.getRoutineType(with: cate.unwrappedRoutineType)
        
    }
    
    func getDigitalType() -> DigitalFriendType {
        guard let cate = getCategory() else { return .changeBackground }
        
        return CoreDataService.shared.getDigitalType(with: cate.unwrappedDigitalType)
        
    }
    
    func getSoundType() -> SoundType {
        guard let cate = getCategory() else { return .circle }
        
        return CoreDataService.shared.getSoundType(with: cate.unwrappedSoundType)
        
    }
    
    func getFolderType() -> WDHomeFolderType {
        guard let cate = getCategory() else { return .placeholder }
        
        return CoreDataService.shared.getFolderType(with: cate.unwrappedFolder)
    }
            
    func getImages(family: FamilyHome) -> [UIImage] {
        guard let cate = getCategory() else { return [UIImage(named: AssetConstant.imagePlacehodel)!] }
        let images = CoreDataService.shared.getImages(category: cate, family: family)
        
        return images
    }
    
    static func getSuggested() -> [ImageSource] {
        
        return CoreDataService.shared.getSuggestedName().map { name in
            return ImageSource(id: name, actualName: name)
        }
    }
    
    static func getAllSource() -> [ImageSource] {
        var src = CoreDataService.shared.getSuggestedName().map { name in
            return ImageSource(id: name, actualName: name)
        }
        
        src.append(ImageSource.defaultValue)
        return src
    }
    
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Image Viet"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
}

struct ImageQuery: EntityStringQuery {
    
    func entities(matching string: String) async throws -> [ImageSource] {
        let srcs = ImageSource.getAllSource().filter { imgsrc in
            return imgsrc.id == string
        }
        
        return srcs
    }
    
    
    func entities(for identifiers: [ImageSource.ID]) async throws -> [ImageSource] {
   
        let imgs = ImageSource.getAllSource().filter { imgsrc in
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
    
    func suggestedEntities() async throws -> [ImageSource] {
        return ImageSource.getSuggested()
    }
    
    func defaultResult() async -> ImageSource? {
        return ImageSource.defaultValue
    }
    
}

