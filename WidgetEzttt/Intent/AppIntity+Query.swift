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
    
    func getRoutineType() -> RoutinMonitorType {
        
        let components = actualName.split(separator: "-")
        if components.count >= 3 {
            
            let nameType = String(components[1])
            let type = RoutinMonitorType.getType(name: nameType)
            return type
        }
        
        return .random
        
    }
    
    static var defaultValue: ImageSource {
        return ImageSource(id: "choose", actualName: "placholder", folderModel: FolderModel(name: "placeHolder", suggestedName: "placeHolder", type: .placeholder))
    }
    
    static var defaultQuery: ImageQuery = ImageQuery()
        
    var folderModel: FolderModel
    
    func getImages(family: FamilyFolderType) -> [UIImage] {
        FileService.shared.readAllImages(from: self.folderModel.name, with: family)
    }
    
    func getButtonChecklistModel() -> ButtonCheckListModel {
        FileService.shared.getButtonChecklistModel(from: self.folderModel.name)
    }
    
    static func getSuggested() -> [ImageSource] {
        return FileService.shared.getFolderModels().map { folder in
            return ImageSource(id: folder.suggestedName, actualName: folder.name, folderModel: folder)
        }
    }
    
    static func getAllSource() -> [ImageSource] {
        var src = FileService.shared.getFolderModels().map { folder in
            return ImageSource(id: folder.suggestedName, actualName: folder.name, folderModel: folder)
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
        return ImageSource.getAllSource().filter { imgsrc in
            return imgsrc.id == string
        }
    }
    
    
    func entities(for identifiers: [ImageSource.ID]) async throws -> [ImageSource] {
        
        let imgs = ImageSource.getAllSource().filter { imgsrc in
            return identifiers.contains { id in
                return id == imgsrc.id
            }
        }
        
        if imgs.count > 0 && WidgetViewModel.shared.dict[imgs[0].actualName] == nil {
            WidgetViewModel.shared.dict[imgs[0].actualName] = ImageDataViewModel()
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

