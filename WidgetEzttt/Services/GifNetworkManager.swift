//
//  GifNetworkManager.swift
//  WallPaper-CoreData
//
//  Created by MAC on 24/11/2023.
//

import SwiftUI

//
//class WDGifNetworkManager {
//    let context = CoreDataService.shared.context
//    
//    static let shared = WDGifNetworkManager()
//
//    func requestApi(completion: @escaping ((Bool) -> Void)) {
//        
//        guard let url = constructRequest() else { completion(false); return }
//        let urlRequest = URLRequest(url: url)
//        let dispathGroup = DispatchGroup()
//        
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            
//            DispatchQueue.main.async {
//                if error != nil { completion(false); return }
//                guard let data = data else { completion(false); return }
//                
//                do {
//                    print("DEBUG: \(try? JSONSerialization.jsonObject(with: data))")
//                    let response = try JSONDecoder().decode(EztWidgetGifLockResponse.self, from: data)
//                    
//                    response.data.data.forEach { gifWidget in
//                        dispathGroup.enter()
//                        self.downloadFileCoreData(data: gifWidget) {
//                            dispathGroup.leave()
//                        }
//                    }
//                    
//                    dispathGroup.notify(queue: .main) {
//                        completion(true)
//                    }
//
//                } catch {
//                    print("DEBUG: \(error.localizedDescription) fdfds")
//                    completion(false)
//                }
//            }
//
//        }.resume()
//
//    }
//    
//    private func downloadFileCoreData(data: EztLockGifWidget, completion: @escaping(() -> Void)) {
//        let dispathGroup = DispatchGroup()
//        let folderType = FamilyLock.getType(name: FamilyLock(rawValue: data.type)?.name ?? "").name
//        let foldername = "\(LockType.gif.rawValue) \(data.id)"
//        
//        let existCate = CoreDataService.shared.getLockCategory(name: foldername)
//        let familyLock = FamilyLock.getType(name: FamilyLock(rawValue: data.type)?.name ?? "").name
//        if let existCate = existCate, let items = existCate.items {
//            existCate.removeFromItems(items)
//
//            self.context.delete(existCate)
//        }
//        
//        let category = CategoryLock(context: context)
//        
//        category.lockType = LockType.gif.rawValue
//        category.name = foldername
//        category.creationDate = Date().timeIntervalSinceNow
//        category.hasSound = false
//        category.delayAnimation = Double(data.delay_animation) / 1000.0
//        category.familyType = familyLock
//        
//        let widgetPath = data.file
////        if let sounds = data.sound {
////            widgetPath += sounds.map { sound in
////                return WidgetPath(file_name: sound.file_name, key_type: sound.key_type, type_file: sound.type_file, url: sound.url)
////            }
////            category.hasSound = !sounds.isEmpty
////        }
//
//        for (index, path) in widgetPath.enumerated()  {
//                
//            dispathGroup.enter()
//            
//            let item = Item(context: context)
//            item.family = familyLock
//            item.creationDate = Date().timeIntervalSinceNow + Double(1000 * index)
//            item.name = path.file_name
//            
//            guard let url = URL(string: path.url.full),
//                  let file = FileService.relativePath(with: foldername)?.appendingPathComponent("\(path.file_name)")
//            else {  context.reset(); dispathGroup.leave(); completion(); return }
//            
//            let urlRequest = URLRequest(url: url)
//
//            URLSession.shared.downloadTask(with: urlRequest) { urlResponse, _, error in
//                
//                if let _ = error { self.context.reset(); dispathGroup.leave(); completion(); return }
//                
//                guard let urlResponse = urlResponse else  { self.context.reset(); dispathGroup.leave(); completion(); return  }
//                
//                FileService.shared.writeToSource(with: foldername, with: urlResponse, to: file)
//                
//                category.addToItems(item)
//                self.saveContext()
//                
//                dispathGroup.leave()
//                
//            }.resume()
//        }
//        
//        dispathGroup.notify(queue: .main) {
//            completion()
//        }
//        
//    }
//    
//
//}
//
//
//extension WDGifNetworkManager {
//    
//    private func constructRequest() -> URL? {
//        
//        var components = URLComponents()
//        components.scheme = WDNetworkManagerConstant.sheme
//        components.host = WDNetworkManagerConstant.host
//        components.path = WDNetworkManagerConstant.pathGif
//        components.queryItems = [
//            URLQueryItem(name: "with", value: WDNetworkManagerConstant.query),
//            URLQueryItem(name: "limit", value: "\(100)"),
////            URLQueryItem(name: "where", value: "active+0"),
////            URLQueryItem(name: "dev", value: "1"),
//        ]
//        
//        return components.url
//    }
//    
//    func saveContext() {
//        if context.hasChanges {
//            do {
//                try context.save()
//                
//            } catch {
//                let nserror = error as NSError
//                print("DEBUG: error savecontext \(error.localizedDescription)")
//                //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//    
//}
