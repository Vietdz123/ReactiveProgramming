//
//  WallpaperCatalogViewModel.swift
//  WallpaperIOS
//
//  Created by Duc on 19/10/2023.
//

import SwiftUI


import Foundation

// MARK: - Welcome
struct DataTagSpecialObject: Codable {
    let data: DataTagSpecial
}

// MARK: - DataClass
struct DataTagSpecial: Codable {
    let currentPage: Int
    let data: [DataTag]
    let from: Int
    let path: String
    let perPage: Int
    let to: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case from
        case path
        case perPage = "per_page"
        case to
    }
}

// MARK: - Datum
struct DataTag: Codable {
    let id: Int
    let title: String
    let active, type, order: Int
    let relationship: Relationship
    let createdAt, updatedAt: String
    let tags: [SpecialTag]

    enum CodingKeys: String, CodingKey {
        case id, title, active, type, order, relationship
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case tags
    }
}

// MARK: - Relationship
struct Relationship: Codable {
    let appID: [Int]

    enum CodingKeys: String, CodingKey {
        case appID = "app_id"
    }
}

// MARK: - Tag
struct SpecialTag: Codable {
    let id: Int
    let title: String
    let active, laravelThroughKey: Int

    enum CodingKeys: String, CodingKey {
        case id, title, active
        case laravelThroughKey = "laravel_through_key"
    }
}

struct SpecialTagWithData {
    let specialTag : SpecialTag
    var wallpapers : [SpWallpaper]
}

class WallpaperCatalogViewModel: ObservableObject {
    
    @Published var shufflePackTags  : [SpecialTagWithData] = []
    @Published var depthEffectTags  : [SpecialTagWithData] = []
    @Published var dynamicTags  : [SpecialTagWithData] = []
    
    
    
   
    
    @Published var domain : String
    init() {
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        getAllTags()
       
        
    }
    
    func getAllTags()  {
        
  
        guard let url  = URL(string: "\(domain)api/v1/special-contents-v2?order_by=order+asc,type+desc&with=tags+id,title,active,daily_rating\(AppConfig.forOnlyIOS)") else {
            return
        }
        print("WallpaperCatalogViewModel \(url)")
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            if let dataCategory = try? JSONDecoder().decode(DataTagSpecialObject.self, from: data){
                DispatchQueue.main.async {
                    let dataTagSpecial = dataCategory.data.data
                    print("WallpaperCatalogViewModel count type: \(dataTagSpecial.count)")
                    if dataTagSpecial.count >= 3{
                        for shuffletag in dataTagSpecial[0].tags {
                            self.shufflePackTags.append(SpecialTagWithData(specialTag: shuffletag, wallpapers: []))
                        }
                       
                        for depthtag in dataTagSpecial[1].tags {
                            self.depthEffectTags.append(SpecialTagWithData(specialTag: depthtag, wallpapers: []))
                        }
                        
                        for dynamictag in dataTagSpecial[2].tags {
                            self.dynamicTags.append(SpecialTagWithData(specialTag: dynamictag, wallpapers: []))
                        }
                        
                        
                        
                    }
                  
                    
               
                   
                }
            }
           
        }.resume()
    }
    
    
    
    func checkIfLoadData(count : Int ,i : Int) -> Bool{
        if i == count - 3 {
            return true
        }else{
            return false
        }
    }
    
    
    
    func loadDataDepthEffectWhenAppear(dataType : Int,index : Int, tagID : Int){
        //MARK dataType is Shuffle Pack, Depth Effect, Dynamic
    
        
        
        let urlString = "\(domain)api/v1/image-specials?limit=7&offset=0&with=special_content+type,id,title&where=special_content_v2_id+\(dataType)&tag=\(tagID)\(getSortParamStr(sort: .NEW))\(AppConfig.forOnlyIOS)"
        
            guard let url  = URL(string: urlString) else {
                return
            }
            
            print("loadDataDepthEffectWhenAppear \(url)")
            
            URLSession.shared.dataTask(with: url){
                data, _ ,_  in
                if let data{
                    if let dataCategory = try? JSONDecoder().decode(SpResponse.self, from: data){
                        DispatchQueue.main.async {
                            if dataType == 1 {
                                self.shufflePackTags[index].wallpapers = dataCategory.data.data
                            }else if dataType == 2 {
                                self.depthEffectTags[index].wallpapers = dataCategory.data.data
                            }else if dataType == 3{
                                self.dynamicTags[index].wallpapers = dataCategory.data.data
                            }
                           
                           
                    
                        }
                    }
                }
                
              
            }.resume()
    }
    
    func getSortParamStr(sort : SpSort) -> String {
        if sort == .NEW{
            return "&order_by=id+desc"
        }else{
            return "&order_by=daily_rating+desc,id+desc"
         
        }
       
    }
    

    
}

