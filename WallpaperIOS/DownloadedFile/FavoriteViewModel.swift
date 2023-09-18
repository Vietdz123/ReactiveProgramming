//
//  FavoriteViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 26/05/2023.
//

import SwiftUI
import CoreData

class FavoriteViewModel: ObservableObject {
    private let viewContext = PersistenceController.shared.container.viewContext
    @Published var listFavWL: [FavoriteWallpaper] = []
    
    init(){
        fetchFavoriteWL()
    }
    
    
    func fetchFavoriteWL(){
        let request = NSFetchRequest<FavoriteWallpaper>(entityName: "FavoriteWallpaper")
        do {
            listFavWL = try viewContext.fetch(request)
        }catch{
            print("error")
        }
        
    }
    
    func addFavoriteWLToCoreData(id : Int, preview_url : String, url : String, type : String, contentType : String, cost : Int = 0) {
        let wallpaper = FavoriteWallpaper(context: viewContext)
        wallpaper.wl_id = Int32(id)
        wallpaper.preview_url = preview_url
        wallpaper.url = url
        wallpaper.type = type
        wallpaper.content_type = contentType
        wallpaper.cost = Int32(cost)
        save()
        self.fetchFavoriteWL()
        
       }
    
    func deleteFavWL(id : Int){
        guard let index = listFavWL.firstIndex(where: {
            $0.wl_id == id
        }) else {
            return
        }
       
        viewContext.delete(listFavWL[index])
        listFavWL.remove(at: index)
        save()
    }
    
    
    
    func isFavorite(id : Int) -> Bool {
        return listFavWL.contains{
            wl in
            wl.wl_id == id
        }
    }
    
    
    func save() {
           do {
               try viewContext.save()
           }catch {
               print("Error saving")
           }
       }
}

