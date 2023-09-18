//
//  CategoryViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 28/04/2023.
//

import SwiftUI

class CategoryViewModel: ObservableObject {
    
    let limit : Int = 5
    
    @Published var categorieList : [Category] = []
    @Published var categorieWithData : [CategoryWithData] = []
    @Published var navigate : Bool = false
    @Published var navigateAtHome : Bool = false
    @Published var domain : String
    
    @Published var newTrendingWL : [Wallpaper] = []
    
    @Published var current : Int = 0
    
    init(){
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        getNewTrending()
        getAllCategory()
    }
    
    func getAllCategory() {
        guard let url  = URL(string: "http://3.8.138.29/api/v2/categories?fields=id,title&where_not=id+192&order_by=daily_rating+desc,order+asc\(AppConfig.forOnlyIOS)") else {
            return
        }
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            let dataCategory = try? JSONDecoder().decode(CategoryList.self, from: data)
            DispatchQueue.main.async {
                self.categorieList.append(contentsOf: dataCategory?.data ?? [])
                print("CategoryViewModel \(self.categorieList.count)")
                self.getCategoryWithData()
               
            }
        }.resume()
    }
    
    func checkIfLoadData(i : Int) -> Bool{
        if i == categorieWithData.count - 3 {
            return true
        }else{
            return false
        }
    }
    
    //https://wallpp2.ezlifetech.com/api/v1/data?categories_id=1&limit=5
    
    func getCategoryWithData(){
        if categorieList.count == categorieWithData.count {
            return
        }
        let to : Int = categorieWithData.count
        var from : Int = to + 5
        if from > categorieList.count - 1 {
            from = categorieList.count - 1
        }
        let randomOffset = 0
        for i in to..<from{
                
          
            let category_id = categorieList[i].id
            
          //  if category_id != 192 {
                let url = "\(domain)api/v1/data?category_id=\(category_id)&limit=7&offset=\(randomOffset)\(AppConfig.forOnlyIOS)&sort=rating"
                guard let url  = URL(string: url) else {
                    return
                }
                
                print("category_id \(url)")
                
                URLSession.shared.dataTask(with: url){
                    data, _ ,err  in
                    guard let data = data, err == nil else {
                        return
                    }
                    let dataCategory = try? JSONDecoder().decode(WallpaperList.self, from: data)
                    DispatchQueue.main.async {
                        self.categorieWithData.append(CategoryWithData(category: self.categorieList[i], wallpapers: dataCategory?.items ?? []))
                    }
                }.resume()
         //   }
        }
    }
    
    
    func getNewTrending(){
        let url = "\(domain)api/v1/data?category_id=192&limit=7&offset=0\(AppConfig.forOnlyIOS)"
        guard let url  = URL(string: url) else {
            return
        }
        
        print("Category VM getNewTrending: \(url)")
        
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            let dataCategory = try? JSONDecoder().decode(WallpaperList.self, from: data)
            DispatchQueue.main.async {
                self.newTrendingWL =  dataCategory?.items ?? []
            }
        }.resume()

    }
    
//    func getSortParamStr() -> String {
//        switch sortedBy {
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
    
}
