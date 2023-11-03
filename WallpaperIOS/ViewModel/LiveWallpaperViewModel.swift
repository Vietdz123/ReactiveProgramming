//
//  LiveWallpaperViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 04/05/2023.
//

import SwiftUI

class LiveWallpaperViewModel: ObservableObject {
    @Published var liveWallpapers : [LiveWallpaper] = []
    @Published var offsetCount : Int = 0
    @Published var homeSortedBy : Sorted = .Popular
    @Published var domain : String 
   
    init(){
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
       // domain = "https://devwallpaper.eztechglobal.com/"
        getDataByPage()
    }

    func getDataByPage() {
        guard let url  = URL(string: "\(domain)api/v1/videos?limit=\(AppConfig.limit)&offset=\(offsetCount)\(getSortParamStr())\(AppConfig.forOnlyIOS)") else {
            return
        }
//        
//        guard let url  = URL(string: "\(domain)api/v1/videos?limit=138&offset=\(offsetCount)\(getSortParamStr())\(AppConfig.forOnlyIOS)") else {
//            return
//        }
        
        print("LIVE WALLPAPER \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            let itemsCurrentLoad = try? JSONDecoder().decode(LiveWallpaperCollection.self, from: data)
            DispatchQueue.main.async {
                self.liveWallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
                self.offsetCount = self.offsetCount + AppConfig.limit
                print("LIVE WALLPAPER \(self.offsetCount) " )
            }
            
        }.resume()

    }
    
    func shouldLoadData(id : Int) -> Bool {
        return id == liveWallpapers.count - 5
    }
    
    func getSortParamStr() -> String {
        switch homeSortedBy {
        
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


