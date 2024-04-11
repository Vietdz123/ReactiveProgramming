//
//  SearchViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 04/05/2023.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var tags : [Tag] = []
  //  @Published var tagsShow : [Tag] = []
    
    @Published var searchText : String = ""
    
    @Published var navigateToTag : Bool = false
    @Published var domain : String
    
    @Published var tagCurrentOfffset : Int = 0
    
    init(){
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        getTags()
    }
    
    func getTags(){
        guard let url  = URL(string: "\(domain)api/v2/popular-tags?fields=id,title,multi_background&with=images+id,preview_small_path&order_by=sort+asc&offset=\(tagCurrentOfffset)&limit=\(AppConfig.limit)") else {
            return
        }
        print("ViewModel SearchViewModel tagURL \(url.absoluteString)")
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            let tagsCollection = try? JSONDecoder().decode(TagModel.self, from: data)
            DispatchQueue.main.async {
                self.tags.append(contentsOf: tagsCollection?.items ?? [])
                self.tagCurrentOfffset += AppConfig.limit
                print("ViewModel SearchViewModel tag count \(self.tags.count)")
                
            }
        }.resume()
    }
    
    
    func checkLoadNextPage(index : Int) -> Bool {
        if tags.count - index == 5 {
            return true
        }
        return false
    }
    
    
    func searchTag(text : String) {
        if searchText == text {
            return
        }
        searchText = text
        if text.isEmpty || text.count == 1 {
            return
        }else{
            tagCurrentOfffset = 0
            tags.removeAll()
            guard let url  = URL(string: "\(domain)api/v2/popular-tags?fields=id,title,multi_background&with=images+id,preview_small_path&order_by=sort+asc&title_search=\(text)") else {
                return
            }
            print("ViewModel SearchViewModel tagURL \(url.absoluteString)")
            URLSession.shared.dataTask(with: url){
                data, _ ,err  in
                guard let data = data, err == nil else {
                    return
                }
                let tagsCollection = try? JSONDecoder().decode(TagModel.self, from: data)
                DispatchQueue.main.async {
                    self.tags.append(contentsOf: tagsCollection?.items ?? [])
                    self.tagCurrentOfffset += AppConfig.limit
                    
                }
            }.resume()
        }
    }

    
}
