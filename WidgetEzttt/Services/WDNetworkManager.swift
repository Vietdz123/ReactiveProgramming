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
    static let pathV1 = "/api/v1/widgets"
    static let query = "category+id,name-apps+id,name-tags+id,name"
    
}

class WDNetworkManager {
    
    static let shared = WDNetworkManager()

    func requestApi(completion: @escaping ((Bool) -> Void)) {
        
        guard let url = constructRequest() else { completion(false); return }
        let urlRequest = URLRequest(url: url)
        let dispathGroup = DispatchGroup()
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            DispatchQueue.main.async {
                if error != nil { completion(false); return }
                guard let data = data else { completion(false); return }
                
                do {
                    let response = try JSONDecoder().decode(EztWidgetResponse.self, from: data)
                    
                    response.data.data.forEach { ezWidget in
                        dispathGroup.enter()
                        self.downloadFile(data: ezWidget) {
                            dispathGroup.leave()
                        }
                    }
                    
                    dispathGroup.notify(queue: .main) {
                        completion(true)
                    }

                } catch {
                    print("DEBUG: \(error.localizedDescription)")
                    DispatchQueue.main.async { completion(false) }
                }
            }

        }.resume()

    }
    
    
    func downloadFile(data: EztWidget, completion: @escaping(() -> Void)) {
        
        let dispathGroup = DispatchGroup()
        let folderType = WDFolderType.getType(name: data.category.name)
        var folderName = "\(folderType.nameId) \(data.id)"
        if folderType == .routineMonitor {
            let typeRoutine = RoutinMonitorType.getType(name: data.tags[0].name).nameId
            folderName =  "\(typeRoutine)-\(folderType.nameId) \(data.id)"
        }
        
        for (index, path) in data.path.enumerated() {
                
            dispathGroup.enter()
            
            let familyType = FamilyFolderType.getType(name: path.key_type)
            
            guard let url = URL(string: path.url.full),
                  let file = FileService.relativePath(with: "\(folderType.nameId)-\(folderName)")?.appendingPathComponent(familyType.rawValue).appendingPathComponent("\(path.file_name)")
            else { completion(); return}
    
            
            let urlRequest = URLRequest(url: url)
            FileManager.default.createFile(atPath: file.lastPathComponent, contents: nil)
            URLSession.shared.downloadTask(with: urlRequest) { urlResponse, _, error in
                if let _ = error { completion(); return }
                
                guard let urlResponse = urlResponse else  { completion(); return }

                FileService.shared.writeToSource(with: folderName,
                                                 with: urlResponse,
                                                 to: file,
                                                 widgetType: folderType,
                                                 familySize: familyType)
                
                
                do {
                    try FileManager.default.setAttributes([.creationDate: Date.now.addingTimeInterval(Double(index + 1) * 1000000)], ofItemAtPath: file.path)
                } catch {
                    print("DEBUG: \(error.localizedDescription) why error")
                }
                
                dispathGroup.leave()
            }.resume()
        }
        
        dispathGroup.notify(queue: .main) {
            completion()
        }

    }
    
    
    private func constructRequest() -> URL? {
        
        var components = URLComponents()
        components.scheme = WDNetworkManagerConstant.sheme
        components.host = WDNetworkManagerConstant.host
        components.path = WDNetworkManagerConstant.pathV1
        components.queryItems = [
            URLQueryItem(name: "with", value: WDNetworkManagerConstant.query),
        ]
        
        return components.url
    }
    
    
}
