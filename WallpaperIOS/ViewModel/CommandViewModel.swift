//
//  CommandViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 25/05/2023.
//

import SwiftUI


class CommandViewModel: ObservableObject {
    @Published var maxCount : Int = 0
    @Published var wallpapers : [Wallpaper] = []
    @Published var sortedBy : Sorted = .Popular
    @Published var currentOffset : Int = 0
    @Published var randomOffset : Int = 0
    @Published var tagRandomOffset : Int = 0
    
    @Published var domain : String
    
    init() {
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        if UserDefaults.standard.bool(forKey: "home_load_first") == false{
            UserDefaults.standard.set(true, forKey: "home_load_first")
        }else{
            randomOffset = Int.random(in: 0...800)
            tagRandomOffset = Int.random(in: 0...200)
        }
        getWallpapers()
    }
    
    func getWallpapers(){
        
    }
    
    func shouldLoadData(id : Int) -> Bool {
        return id == wallpapers.count - 6
    }
    
  
    
    func getSortParamStr() -> String {
        switch sortedBy {
            
        case .Newest:
            return ""
        case .Popular:
            return "&sort=rating"
        case .Downloaded:
            return "&sort=downloads"
        case .Favorite:
            return "&sort=favorites"
        }
    }
    
}

class HomeViewModel : CommandViewModel {
    @Published var tags : [Tag] = []
   
    
    override init() {
        super.init()
        self.getTags()
    }
    override func getWallpapers() {
        
        guard let url  = URL(string: "\(domain)api/v1/data?limit=\(AppConfig.limit)&offset=\(randomOffset)\(getSortParamStr())\(AppConfig.forOnlyIOS)") else {
            return
        }
        
        
        
        print("ViewModel HomeViewModel \(url.absoluteString)")
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            if err != nil {
                print("MY_ERROR \(err!.localizedDescription)")
            }
            
            
            let itemsCurrentLoad = try? JSONDecoder().decode(WallpaperList.self, from: data)
            
            DispatchQueue.main.async {
                
                self.wallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
                self.randomOffset += AppConfig.limit
                
            }
            
        }.resume()
    }
    
    func getTags(){
        print("ViewModel HomeViewModel getTags")
        guard let url  = URL(string: "\(domain)api/v2/popular-tags?fields=id,title,multi_background&with=images+id,preview_small_path&order_by=sort+asc&offset=\(tagRandomOffset)&limit=\(AppConfig.limit)") else {
            print("ViewModel HomeViewModel getTags return")
            return
        }
        print("ViewModel HomeViewModel tagURL \(url.absoluteString)")
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            let tagsCollection = try? JSONDecoder().decode(TagModel.self, from: data)
            DispatchQueue.main.async {
                self.tags.append(contentsOf: tagsCollection?.items ?? [])
                self.tagRandomOffset += AppConfig.limit
                
            }
        }.resume()
    }
    
 
    
    func checkLoadNextPageTag(index : Int) -> Bool {
        if tags.count - index == 5 {
            return true
        }
        return false
    }
    
    
}


class ExclusiveViewModel : CommandViewModel {
    
    override func getWallpapers() {
        
     
//        let urlString = "https://devwallpaper.eztechglobal.com/api/v1/data?limit=\(AppConfig.limit)&offset=\(currentOffset)&order_by=daily_rating+desc,updated_at+desc\(AppConfig.forOnlyIOS)&types[]=private&screen=exclusive&only_app=1"
        let urlString = "\(domain)api/v1/data?limit=\(AppConfig.limit)&offset=\(currentOffset)&order_by=daily_rating+desc,updated_at+desc\(AppConfig.forOnlyIOS)&types[]=private&app=2&screen=exclusive&only_app=1"
        
        
        
        guard let url  = URL(string: urlString) else {
            return
        }
        
        
        print("ViewModel ExclusiveViewModel \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            
            let itemsCurrentLoad = try? JSONDecoder().decode(WallpaperList.self, from: data)
            
            DispatchQueue.main.async {
                self.wallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
                self.currentOffset = self.currentOffset + AppConfig.limit
                //UserDefaults.standard.set(markOffset + AppConfig.limit, forKey: "exclusive_markoffset")
                
            }
            
        }.resume()
    }
    
}


enum TagTab : String, CaseIterable {
    case NEW  = "Newest"
    case TOP = "Top"
}

class TagViewModel : CommandViewModel {
    @Published var tag : String = ""
    @Published var navigateAtHome : Bool = false
    
    override init() {
        super.init()
        print("TagViewModel init \(tag)")
    }
    
    override func getWallpapers() {
        
        guard let url  = URL(string: "\(domain)api/v1/data?query=\(tag)&offset=\(currentOffset)&limit=\(AppConfig.limit)\(getSortParamStr())\(AppConfig.forOnlyIOS)") else {
            return
        }
        print("TagViewModel url \(url.absoluteString)")
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            
            let itemsCurrentLoad = try? JSONDecoder().decode(WallpaperList.self, from: data)
            DispatchQueue.main.async {
                self.wallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
                self.currentOffset = self.wallpapers.count
                self.maxCount = itemsCurrentLoad?.count ?? 100
                
                
            }
            
        }.resume()
    }
    
    
    
    
    
    
}

enum CategorySorted : String, CaseIterable {
    case NEW = "Newest"
    case TOP = "Top"
}

class CategoryPageViewModel : CommandViewModel {
   
    @Published var category : Category?
    @Published var categorySort : CategorySorted = .NEW
    
    override func getWallpapers() {
        
        if category != nil{
            
            let sort = ( categorySort == .NEW ) ? "&order_by=uploaded_at+desc" : "&order_by=daily_rating+desc,is_trend+desc"
            
            guard let url  = URL(string: "\(domain)api/v1/data?category_id=\(category?.id ?? 1)&limit=\(AppConfig.limit)&offset=\(currentOffset)\(sort)&not_prioritize_private=1\(AppConfig.forOnlyIOS)") else {
                return
            }
            
            
            
            print("CategoryPageViewModel \(url.absoluteString)")
            
            URLSession.shared.dataTask(with: url){
                data, _ ,err  in
                guard let data = data, err == nil else {
                    return
                }
                
                let itemsCurrentLoad = try? JSONDecoder().decode(WallpaperList.self, from: data)
                DispatchQueue.main.async {
                    self.wallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
                    self.currentOffset = self.wallpapers.count
                    //   self.maxCount = ( itemsCurrentLoad?.count  ?? 115 ) - 15
                }
                
            }.resume()
            
        }
    }
}


class FindViewModel : CommandViewModel {
    
    @Published var query : String = ""
    
    override func getWallpapers() {
        if query.isEmpty {
            return
        }
        
        print("FINDVIEWMODEL \(query)")
        
        guard let url  = URL(string: "\(domain)api/v1/data?query=\(query)&limit=\(AppConfig.limit)&offset=\(currentOffset)&limit=30\(getSortParamStr())\(AppConfig.forOnlyIOS)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            let itemsCurrentLoad = try? JSONDecoder().decode(WallpaperList.self, from: data)
            DispatchQueue.main.async {
                self.wallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
                print("FINDVIEWMODEL \(self.wallpapers.count)")
                self.currentOffset = self.wallpapers.count
              
                
                
                
            }
            
        }.resume()
        
    }
}

