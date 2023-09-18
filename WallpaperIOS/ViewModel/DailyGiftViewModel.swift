//
//  DailyGiftViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 29/06/2023.
//

import SwiftUI

class DailyGiftViewModel: ObservableObject {
    @Published var wallpapers : [Wallpaper] = []
    @Published var domain : String
    init(){
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        getWallpaperExclusive7coin()
    }
    
    func getWallpaperExclusive7coin(){
        guard let url  = URL(string: "\(domain)api/v1/get-ramdom-image") else {
            return
        }
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            if let itemsCurrentLoad = try? JSONDecoder().decode(Wallpaper.self, from: data) {
                DispatchQueue.main.async {
                    self.wallpapers.append( itemsCurrentLoad )
                }
            }
        }.resume()
    }
}

