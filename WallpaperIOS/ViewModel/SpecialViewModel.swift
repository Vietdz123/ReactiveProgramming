//
//  ShufflePackViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 08/08/2023.
//

import SwiftUI


// Dynamic "https://devwallpaper.eztechglobal.com/api/v1/image-specials?limit=\(AppConfig.limit)\(getSortParamStr())&with=special_content+type,id,title&where=special_content_v2_id+1&app=2"
// Depth Effect "https://devwallpaper.eztechglobal.com/api/v1/image-specials?limit=\(AppConfig.limit)\(getSortParamStr())&with=special_content+type,id,title&where=special_content_v2_id+5&app=2"
// Shuffle "https://devwallpaper.eztechglobal.com/api/v1/image-specials?limit=\(AppConfig.limit)\(getSortParamStr())&with=special_content+type,id,title&where=special_content_v2_id+4&app=2"

class SpViewModel: ObservableObject {
   
    @Published var wallpapers : [SpWallpaper] = []
    @Published var currentOffset : Int = 0
    @Published var domain : String
    
  
    
    
    init() {
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        getWallpapers()
    }
    
    func getWallpapers(){
        
    }
    
    func shouldLoadData(id : Int) -> Bool {
        return id == wallpapers.count - 6
    }
    
    func getSortParamStr() -> String {
        return "&order_by=id+desc"
    }
    
}


class DynamicIslandViewModel : SpViewModel {
    
    
    override func getWallpapers() {
     
    
        let urlString = "\(domain)api/v1/image-specials?limit=\(AppConfig.limit)\(getSortParamStr())&offset=\(currentOffset)&with=special_content+type,id,title&where=special_content_v2_id+3\(AppConfig.forOnlyIOS)"
        
        guard let url  = URL(string: urlString) else {
            return
        }
        
        
        print("ViewModel SP DynamicIslandViewModel \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
           
            print("ViewModel SP DynamicIslandViewModel \(data.count)")
            
            let itemsCurrentLoad = try? JSONDecoder().decode(SpResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.wallpapers.append(contentsOf: itemsCurrentLoad?.data.data ?? [])
                self.currentOffset = self.currentOffset + AppConfig.limit
                

//                self.wallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
               
                //UserDefaults.standard.set(markOffset + AppConfig.limit, forKey: "exclusive_markoffset")

            }
            
        }.resume()
    }

    
}

class DepthEffectViewModel : SpViewModel {
    
    
    override func getWallpapers() {
        
            let urlString = "\(domain)api/v1/image-specials?limit=\(AppConfig.limit)\(getSortParamStr())&offset=\(currentOffset)&with=special_content+type,id,title&where=special_content_v2_id+2\(AppConfig.forOnlyIOS)"
            
            guard let url  = URL(string: urlString) else {
                return
            }
            
            
            print("ViewModel SP DepthEffectViewModel \(url.absoluteString)")
            
            URLSession.shared.dataTask(with: url){
                data, _ ,err  in
                guard let data = data, err == nil else {
                    return
                }
               
                let itemsCurrentLoad = try? JSONDecoder().decode(SpResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.wallpapers.append(contentsOf: itemsCurrentLoad?.data.data  ?? [])
                    self.currentOffset = self.currentOffset + AppConfig.limit
                    
              
    //                self.wallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
                   
                    //UserDefaults.standard.set(markOffset + AppConfig.limit, forKey: "exclusive_markoffset")

                }
                
            }.resume()
        }
    
    
}




class ShufflePackViewModel: SpViewModel {
    
    override func getWallpapers() {
        
            let urlString = "\(domain)api/v1/image-specials?limit=\(AppConfig.limit)\(getSortParamStr())&offset=\(currentOffset)&with=special_content+type,id,title&where=special_content_v2_id+1\(AppConfig.forOnlyIOS)"
            
            guard let url  = URL(string: urlString) else {
                return
            }
            
            
            print("ViewModel SP ShufflePackViewModel \(url.absoluteString)")
            
            URLSession.shared.dataTask(with: url){
                data, _ ,err  in
                guard let data = data, err == nil else {
                    return
                }
               
                let itemsCurrentLoad = try? JSONDecoder().decode(SpResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.wallpapers.append(contentsOf: itemsCurrentLoad?.data.data  ?? [])
                    self.currentOffset = self.currentOffset + AppConfig.limit
                    
              
    //                self.wallpapers.append(contentsOf: itemsCurrentLoad?.items ?? [])
                   
                    //UserDefaults.standard.set(markOffset + AppConfig.limit, forKey: "exclusive_markoffset")

                }
                
            }.resume()
        }
   
}
