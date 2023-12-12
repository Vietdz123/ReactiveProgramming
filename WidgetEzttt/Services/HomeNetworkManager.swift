//
//  NetworkManager.swift
//  WallPaper
//
//  Created by MAC on 26/10/2023.
//

import SwiftUI

enum WDNetworkManagerConstant {
    
    static let sheme = "https"
    static let host = "widget.eztechglobal.com"
    static let pathWidget = "/api/v1/widgets"
    static let pathGif = "/api/v1/gifs"
    static let query = "category+id,name-apps+id,name-tags+id,name"
    
}

class WDHomeNetworkManager {
    let context = CoreDataService.shared.context
    
    static let shared = WDHomeNetworkManager()

    func requestApi(completion: @escaping ((Bool) -> Void)) {
        
        guard let url = constructRequest() else { completion(false); return }
        let urlRequest = URLRequest(url: url)
        let dispathGroup = DispatchGroup()
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            DispatchQueue.main.async {
                if error != nil { completion(false); return }
                guard let data = data else { completion(false); return }
                
                do {
                   
                    let response = try JSONDecoder().decode(EztWidgetHomeResponse.self, from: data)
                    
                    response.data.data.forEach { ezWidget in
                        dispathGroup.enter()
                        self.downloadFileCoreData(data: ezWidget) {
                            dispathGroup.leave()
                        }
                    }
                    
                    dispathGroup.notify(queue: .main) {
                        completion(true)
                    }

                } catch {
                    print("DEBUG: \(error.localizedDescription) fdfds")
                    completion(false)
                }
            }

        }.resume()

    }
    
     func downloadFileCoreData(data: EztWidget, completion: @escaping(() -> Void)) {
        let dispathGroup = DispatchGroup()
        let folderType = WDHomeFolderType.getType(name: data.category.name)
        let foldername = "\(folderType.nameId) \(data.id)"
        
        let existCate = CoreDataService.shared.getCategory(name: foldername)
        if let existCate = existCate, let items = existCate.items {
            existCate.removeFromItems(items)

            self.context.delete(existCate)
        }
        
        let category = CategoryHome(context: context)
        category.folderType = folderType.rawValue
        category.name = foldername
        category.creationDate = Date().timeIntervalSinceNow
        category.currentCheckImageRoutine = Array(repeating: 0, count: 7)
        category.isCheckedRoutine = Array(repeating: false, count: 7)
        category.hasSound = false
        category.shouldPlaySound = false
        category.delayAnimation = Double(data.delay_animation) / 1000.0
        
        if folderType == .routineMonitor {
            let routineType = RoutinMonitorType.getType(name: data.tags[0].name).nameId
            category.routineType = routineType
        } else if folderType == .sound {
            let soundType = SoundType.getType(name: data.tags[0].name).nameId
            category.soundType = soundType
        } else if folderType == .digitalFriend {
            let digitalType = DigitalFriendType.getType(name: data.tags.first?.name ?? DigitalFriendType.changeBackground.nameId)
            category.digitalType = digitalType.nameId
        } 
        
        var widgetPath = data.path
        if let sounds = data.sound {
            widgetPath = sounds.map { sound in
                return WidgetPath(file_name: sound.file_name, key_type: sound.key_type, type_file: sound.type_file, url: sound.url)
            } + data.path
            category.hasSound = !sounds.isEmpty
        }

        for (index, path) in widgetPath.enumerated()  {
                
            dispathGroup.enter()
            
            let familyType = FamilyHome.getType(name: path.key_type)
            let item = ItemHome(context: context)
            item.family = familyType.rawValue
            item.creationDate = Date().timeIntervalSinceNow + Double(1000 * index)
            item.name = path.file_name
            item.routine_type = (folderType == .routineMonitor) ? RoutinMonitorType.getType(name: data.tags[0].name).nameId : nil
            
            
            guard let url = URL(string: path.url.full),
                  let file = FileService.relativePath(with: foldername)?.appendingPathComponent("\(path.file_name)")
            else {  context.reset(); dispathGroup.leave(); completion(); return }
            
            let urlRequest = URLRequest(url: url)

            URLSession.shared.downloadTask(with: urlRequest) { urlResponse, _, error in
                
                if let _ = error { self.context.reset(); dispathGroup.leave(); completion(); return }
                
                guard let urlResponse = urlResponse else  { self.context.reset(); dispathGroup.leave(); completion(); return  }
                
                FileService.shared.writeToSource(with: foldername, with: urlResponse, to: file)
                
                category.addToItems(item)
                self.saveContext()
                
                dispathGroup.leave()
                
            }.resume()
        }
        
        dispathGroup.notify(queue: .main) {
            completion()
        }
        
    }
    

}


extension WDHomeNetworkManager {
    
    private func constructRequest() -> URL? {
        
        var components = URLComponents()
        components.scheme = WDNetworkManagerConstant.sheme
        components.host = WDNetworkManagerConstant.host
        components.path = WDNetworkManagerConstant.pathWidget
        components.queryItems = [
            URLQueryItem(name: "with", value: WDNetworkManagerConstant.query),
            URLQueryItem(name: "limit", value: "\(100)"),
            URLQueryItem(name: "offset", value: "\(30)"),
//            URLQueryItem(name: "where", value: "active+0"),
//            URLQueryItem(name: "dev", value: "1"),
        ]
        
        return components.url
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                
            } catch {
                print("DEBUG: error savecontext \(error.localizedDescription)")
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func downloadFile(data: EztWidget, completion: @escaping(() -> Void)) {
        
        let dispathGroup = DispatchGroup()
        let folderType = WDHomeFolderType.getType(name: data.category.name)
        var folderName = "\(folderType.nameId) \(data.id)"
        if folderType == .routineMonitor {
            let typeRoutine = RoutinMonitorType.getType(name: data.tags[0].name).nameId
            folderName =  "\(typeRoutine)-\(folderType.nameId) \(data.id)"
        }
        
        for (index, path) in data.path.enumerated() {
                
            dispathGroup.enter()
            
            let familyType = FamilyHome.getType(name: path.key_type)
            
            guard let url = URL(string: path.url.full),
                  let file = FileService.relativePath(with: "\(folderType.nameId)-\(folderName)")?.appendingPathComponent(familyType.rawValue).appendingPathComponent("\(path.file_name)")
            else { completion(); return}
    
            FileManager.default.createFile(atPath: file.path, contents: nil)
            
            
            let urlRequest = URLRequest(url: url)

            URLSession.shared.downloadTask(with: urlRequest) { urlResponse, _, error in
                if let _ = error { completion(); return }
                
                guard let urlResponse = urlResponse else  { completion(); return }
                
                
                FileService.shared.writeToSource(with: folderName,
                                                 with: urlResponse,
                                                 to: file,
                                                 widgetType: folderType,
                                                 familySize: familyType)
                do {
                    try FileManager.default.setAttributes([.creationDate: Date.now.addingTimeInterval(Double(index) * 10000000)], ofItemAtPath: file.path)
                } catch {
                    print("DEBUG: wwhy failed \(error.localizedDescription) and \(file.absoluteURL)")
                }
                dispathGroup.leave()
                
            }.resume()
        }
        
        dispathGroup.notify(queue: .main) {
            completion()
        }

    }
}
