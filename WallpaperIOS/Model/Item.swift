//
//  Item.swift
//  WallpaperIOS
//
//  Created by Mac on 28/04/2023.
//

import SwiftUI


struct CategoryWithData : Codable {
    let category : Category
    var wallpapers : [Wallpaper] = []
}

struct Category: Codable {
    let id: Int
    let title: String
  //  let createdAt: String?
  //  let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
     //   case createdAt = "created_at"
     //   case updatedAt = "updated_at"
    }
}

struct CategoryList: Codable {
  
    let data: [Category]
}

struct WallpaperList: Codable {
    let count: Int
    let items: [Wallpaper]
}

struct Wallpaper:  Identifiable,  Codable, Hashable {
    let id: Int
    let category_id: Int
    let user_id: Int?
    let user_pseudo_id: String?
    let colors: [[String]]?
    let content_type: String
    let cost: Int?
    let tags: [String]
    let description: String?
    let downloads: Int
    let favorites: Int
    let rating: Int
    let for_adult_only: Bool
    let license: String?
    let min_cost_ends_at: String?
    let source_link: String?
    let uploader_type: String?
    let author: String?
    let adapted_path: String?
    let adapted_landscape_path: String?
    let original_path: String?
    let preview_small_path: String?
    let uploaded_at1: String?
    let created_at: String?
    let updated_at: String?
    let uploaded_at: String?
    let variations: Variations
}

struct Variations: Codable {
    let adapted: Adapted
    let adapted_landscape: AdaptedLandscape?
    let original: Original?
    let preview_small: PreviewSmall
}

struct Adapted: Codable {
    let resolution: Resolution
    let size: Int
    let url: String
}

struct AdaptedLandscape: Codable {
    let resolution: Resolution?
    let size: Int?
    let url: String?
}

struct Original: Codable {
    let resolution: Resolution?
    let size: Int?
    let url: String?
}

struct PreviewSmall: Codable {
    let resolution: Resolution
    let size: Int
    let url: String
}

struct Resolution: Codable {
    let height: Int?
    let width: Int?
}

struct LiveWallpaper:  Identifiable,  Codable, Hashable  {
    let id: Int
    let cost: Int?
    let tags: [String]
    let downloads: Int?
    let favorites: Int?
    let rating: Int?
    let license: String?
    let min_cost_ends_at: String?
    let source_link: String?
    let author: String?
    let sort_number: Int?
    let active: Int
    let uploaded_at: String?
    let created_at: String?
    let updated_at: String?
    let image_variations: ImageVariations
    let video_variations: VideoVariations
}

struct ImageVariations: Codable {
    let adapted: Adapted
    let preview_small: PreviewSmall
}


struct VideoVariations: Codable {
    let adapted: Adapted
    let preview_small: PreviewSmall
}

struct LiveWallpaperCollection: Codable {
    let count: Int
    let items: [LiveWallpaper]
}

extension Wallpaper {
   
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        return lhs.id == rhs.id
    }
}

extension LiveWallpaper {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public static func == (lhs: LiveWallpaper, rhs: LiveWallpaper) -> Bool {
        return lhs.id == rhs.id
    }
}
