//
//  SpecialObject.swift
//  WallpaperIOS
//
//  Created by Mac on 08/08/2023.
//

import Foundation

// MARK: - Welcome
struct SpResponse: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let data: [SpWallpaper]
}




struct SpLiveResponse: Codable {
    let data: LiveDataClass
}

// MARK: - DataClass
struct LiveDataClass: Codable {
    let data: [SpLiveWallpaper]
}


// MARK: - SpLiveWallpaper
struct SpLiveWallpaper: Codable {
    let id, userID, cost, contentType: Int
    let path: [VideoPath]
    let thumbnail: [PathElement]
    let specialContentV2ID: Int
    let license: String?
    let active, dailyRating, downloaded, favorites: Int?
    let setCount, isTrend: Int?
    let createdAt, updatedAt: String?
    let specialContent: SpecialContent?
    var localVideoURLString : String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cost
        case contentType = "content_type"
        case path, thumbnail
        case specialContentV2ID = "special_content_v2_id"
        case license, active
        case dailyRating = "daily_rating"
        case downloaded, favorites
        case setCount = "set_count"
        case isTrend = "is_trend"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case specialContent = "special_content"
        case localVideoURLString = "local_video_url_string"
    }
}


struct VideoPath : Codable{
    let url : PathURLL
}

// MARK: - Datum
struct SpWallpaper: Codable {
    let id, userID, cost, contentType: Int
    let path: [PathElement]
    let thumbnail: PathElement?
    let specialContentV2ID: Int
    let license: String?
    let active, dailyRating, downloaded, favorites: Int
    let setCount, isTrend: Int
    let createdAt, updatedAt: String
    let specialContent: SpecialContent?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cost
        case contentType = "content_type"
        case path, thumbnail
        case specialContentV2ID = "special_content_v2_id"
        case license, active
        case dailyRating = "daily_rating"
        case downloaded, favorites
        case setCount = "set_count"
        case isTrend = "is_trend"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case specialContent = "special_content"
    }
}

// MARK: - PathElement
struct PathElement: Codable {
    let fileName: String
    let path: PathPath
  

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case path
       
    }
}

// MARK: - PathPath
struct PathPath: Codable {
    let full, preview, small, extraSmall: String

    enum CodingKeys: String, CodingKey {
        case full, preview, small
        case extraSmall = "extra_small"
    }
}

// MARK: - PathPath
struct PathURLL: Codable {
    let full, large, medium, small: String

    enum CodingKeys: String, CodingKey {
        case full, large, medium ,small
        
    }
}

// MARK: - SpecialContent
struct SpecialContent: Codable {
    let id: Int
    let title: String
    let type: Int
}
