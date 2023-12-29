//
//  EztWatchFaceViewModel.swift
//  WallpaperIOS
//
//  Created by Duc on 24/11/2023.
//

import SwiftUI

class EztWatchFaceViewModel: SpViewModel {
 
        
        
        override func getWallpapers() {
            
            let urlString = "\(domain)\(APIHelper.WATCH_FACE)limit=\(AppConfig.limit)\(getSortParamStr())&offset=\(currentOffset)\(AppConfig.forOnlyIOS)"
                
                guard let url  = URL(string: urlString) else {
                    return
                }
                
                
                print("ViewModel SP EztWatchFaceViewModel \(url.absoluteString)")
                
                URLSession.shared.dataTask(with: url){
                    data, _ ,err  in
                    guard let data = data, err == nil else {
                        return
                    }
                   
                    let itemsCurrentLoad = try? JSONDecoder().decode(SpResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.wallpapers.append(contentsOf: itemsCurrentLoad?.data.data  ?? [])
                        self.currentOffset = self.currentOffset + AppConfig.limit


                    }
                    
                }.resume()
            }
        
        
   
    
   
}

