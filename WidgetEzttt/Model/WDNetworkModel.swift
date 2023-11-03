//
//  WDNetworkModel.swift
//  WallpaperIOS
//
//  Created by Duc on 26/10/2023.
//




import SwiftUI

struct EztWidgetResponse: Codable {
    let data: WidgetData
}

struct WidgetData: Codable {
    let data: [EztWidget]
}

struct EztWidget: Codable {
    let id: Int
    let thumbnail: [Thumbnail]
    let path: [WidgetPath]
    let category_id: Int
    let is_trend: Int
    let is_private: Int
    let order: Int
    let active: Int
    let download: Int
    let rating: Int
    let daily_rating: Int
    let set: Int
    let cost: Int
    let license: String
    let updated_at: String
    let created_at: String
    let category: CategoryWidget
    let apps: [EztApp]
    let tags: [WidgetTag]
}

extension EztWidget {
    func getRectangleUrlString() -> [String]{
        var listURL : [String] = []
        for thumbnail in self.path {
            if thumbnail.key_type == "rectangle"{
                listURL.append(thumbnail.url.full)
            }
        }
        return listURL
    }
    
    func getButtonCheckUrlString() -> [String]{
        var listURL : [String] = []
        for path in self.path {
            if path.key_type == "check"{
                listURL.append(path.url.full)
            }
        }
        return listURL
    }
    
    func getButtonUnCheckUrlString() -> [String]{
        var listURL : [String] = []
        for path in self.path {
            if path.key_type == "uncheck"{
                listURL.append(path.url.full)
            }
        }
        return listURL
    }
    
    func getURLStringLottie() -> [String]{
        var listURL : [String] = []
        let thumbnails = self.thumbnail
        for thumbnail in thumbnails {
            if thumbnail.key_type == "lottie_rectangle" {
                listURL.append( thumbnail.url.full)
            }
        }
        
        return listURL
    }
}

struct Thumbnail: Codable {
    let file_name: String
    let key_type: String
    let type_file: String
    let url: PathURL
}

struct WidgetPath: Codable {
    let file_name: String
    let key_type: String
    let type_file: String
    let url: PathURL
}

struct PathURL: Codable {
    let full: String
    let preview: String
    let small: String
    let extra_small: String
}

struct CategoryWidget: Codable {
    let id: Int
    let name: String
}

struct WidgetTag: Codable {
    let id: Int
    let name: String
}

struct EztApp: Codable {
    let id: Int
    let name: String
   
}

