//
//  LiveWallpaperViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 04/05/2023.
//

import SwiftUI


class LiveWallpaperViewModel: ObservableObject {
    
    @Published var wallpapers : [SpLiveWallpaper] = []
    @Published var currentOffset : Int = 0
    @Published var domain : String = "https://wallpaper.eztechglobal.com/"
    @Published var sort : SpSort = .NEW
    @Published var sortByTop : SpTopRate = .TOP_WEEK
    
    init(sort : SpSort = .NEW, sortByTop : SpTopRate = .TOP_WEEK) {
        self.sort = sort
        self.sortByTop = sortByTop
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        getWallpapers()
    }
    
    init(wallpapers: [SpLiveWallpaper]) {
        self.wallpapers = wallpapers
    }
    
    func getWallpapers() {
        
        let urlString = "\(domain)api/v1/video-specials?limit=\(AppConfig.limit)&offset=\(wallpapers.count)\(getSortParamStr())&mobile_app_id=2&app=2"
        
        guard let url  = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            
            print("ViewModel SP LiveWallpaperViewModel dataCount \(data.count)")
            
            let itemsCurrentLoad = try? JSONDecoder().decode(SpLiveResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.wallpapers.append(contentsOf: itemsCurrentLoad?.data.data ?? [])
                self.currentOffset = self.currentOffset + AppConfig.limit
            }
            
        }.resume()
    }
    
    
    func shouldLoadData(id : Int) -> Bool {
        return id == wallpapers.count - 6
    }
    
    func getSortParamStr() -> String {
        if sort == .NEW{
            return "&order_by=id+desc"
        }else{
            
            if sortByTop == .TOP_WEEK {
                return "&order_by=daily_rating+desc,id+desc"
            }else{
                return "&order_by=monthly_rating+desc,id+desc"
            }
            
            
        }
        
    }
    
    
}


