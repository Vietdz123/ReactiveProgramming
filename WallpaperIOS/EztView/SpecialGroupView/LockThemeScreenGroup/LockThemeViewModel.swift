//
//  LockThemeViewModel.swift
//  WallpaperIOS
//
//  Created by Duc on 07/05/2024.
//

import SwiftUI

class LockThemeViewModel: ObservableObject {
  
    @Published var wallpapers : [LockScreenObj] = []
    
    @Published var currentOffset : Int = 0
    @Published var domain : String
    @Published var sort : SpSort //= .NEW
    @Published var sortByTop : SpTopRate
    
    init(sort : SpSort = .NEW, sortByTop : SpTopRate = .TOP_WEEK) {
        self.sort = sort
        self.sortByTop = sortByTop
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        getWallpapers()
    }
    
    func getWallpapers(){
        
            let urlString = "\(domain)api/v1/themes?limit=\(AppConfig.limit)\(getSortParamStr())&offset=\(currentOffset)\(AppConfig.forOnlyIOS)"
            
            guard let url  = URL(string: urlString) else {
                return
            }
            
            
            print("LockThemeViewModel  \(url.absoluteString)")
            
            URLSession.shared.dataTask(with: url){
                data, _ ,err  in
                guard let data = data, err == nil else {
                    return
                }
               
                print("LockThemeViewModel \(data.count)")
                
                let itemsCurrentLoad = try? JSONDecoder().decode(LockScreenResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.wallpapers.append(contentsOf: itemsCurrentLoad?.data.data ?? [])
                    self.currentOffset = self.currentOffset + AppConfig.limit
                    print("LockThemeViewModel \(self.wallpapers.count)")
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
