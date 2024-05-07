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
    @Published var domain : String
    @Published var sort : SpSort //= .NEW
    @Published var sortByTop : SpTopRate
   
  
    
    
    init(sort : SpSort = .NEW, sortByTop : SpTopRate = .TOP_WEEK) {
        self.sort = sort
        self.sortByTop = sortByTop
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        getWallpapers()
    }
    
   
        
        
         func getWallpapers() {
         
        
            let urlString = "\(domain)api/v1/video-specials?limit=\(AppConfig.limit)&offset=\(currentOffset)\(getSortParamStr())&mobile_app_id=2&app=2"
            
            guard let url  = URL(string: urlString) else {
                return
            }
            
            
            print("ViewModel SP LiveWallpaperViewModel \(url.absoluteString)")
            
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
                    print("ViewModel SP LiveWallpaperViewModel count: \(self.wallpapers.count)")

    //                self.wallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
                   
                    //UserDefaults.standard.set(markOffset + AppConfig.limit, forKey: "exclusive_markoffset")

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




//class LiveWallpaperViewModel: ObservableObject {
//    @Published var liveWallpapers : [LiveWallpaper] = []
//    @Published var offsetCount : Int = 0
//    @Published var homeSortedBy : Sorted = .Downloaded
//    @Published var domain : String
//   
//    init(){
//       // domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
//        domain = "https://devwallpaper.eztechglobal.com/"
//        getDataByPage()
//    }
//
//    func getDataByPage() {
//        guard let url  = URL(string: "\(domain)\(APIHelper.LIVE_WALLPAPER)&limit=\(AppConfig.limit)&offset=\(offsetCount)\(getSortParamStr())\(AppConfig.forOnlyIOS)") else {
//            return
//        }
////        
////        guard let url  = URL(string: "\(domain)api/v1/videos?limit=138&offset=\(offsetCount)\(getSortParamStr())\(AppConfig.forOnlyIOS)") else {
////            return
////        }
//        
//        print("LIVE WALLPAPER \(url.absoluteString)")
//        
//        URLSession.shared.dataTask(with: url){
//            data, _ ,err  in
//            guard let data = data, err == nil else {
//                return
//            }
//            let itemsCurrentLoad = try? JSONDecoder().decode(LiveWallpaperCollection.self, from: data)
//            DispatchQueue.main.async {
//                self.liveWallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
//                self.offsetCount = self.offsetCount + AppConfig.limit
//                print("LIVE WALLPAPER \(self.offsetCount) " )
//            }
//            
//        }.resume()
//
//    }
//    
//    func shouldLoadData(id : Int) -> Bool {
//        return id == liveWallpapers.count - 5
//    }
//    
//    func getSortParamStr() -> String {
//        switch homeSortedBy {
//        
//        case .Newest:
//           return ""
//        case .Popular:
//            return "&sort=rating"
//        case .Downloaded:
//            return "&sort=downloads"
//        case .Favorite:
//            return "&sort=favorites"
//        }
//    }
//    
//    
//}


