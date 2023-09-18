//
//  SearchViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 04/05/2023.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var tags : [Tag] = []
    @Published var tagsShow : [Tag] = []
    
    @Published var searchText : String = ""
    
    @Published var navigateToTag : Bool = false
    @Published var domain : String
    init(){
        domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        getAllTags()
    }
    
    func getAllTags(){
        guard let url  = URL(string: "\(domain)api/v1/popular-tags") else {
            return
        }
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            let tagsCollection = try? JSONDecoder().decode(TagCollection.self, from: data)
            DispatchQueue.main.async {
                self.tags.append(contentsOf: tagsCollection?.items ?? [])
                self.tagsShow = self.tags
            }
        }.resume()
    }
    
    
    func searchTag(text : String) {
        searchText = text
        if text.isEmpty {
            withAnimation{
                tagsShow = tags
            }
            
        }else{
            withAnimation{
                tagsShow = tags.filter{
                    $0.title.contains(text.lowercased())
                }
            }
        }
    }

    
}
