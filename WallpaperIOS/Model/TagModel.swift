//
//  TagModel.swift
//  WallpaperIOS
//
//  Created by Duc on 19/09/2023.
//

import Foundation

// MARK: - Welcome
struct TagModel: Codable {
    let count: Int
    let items: [Tag]
}

//// MARK: - Items
//struct TagCollection: Codable {
//    let currentPage: Int
//    let data: [Tag]
//    let firstPageURL: String
//    let from: Int
//    let nextPageURL, path: String
//    let perPage: Int
//    let prevPageURL: String?
//    let to: Int
//
//    enum CodingKeys: String, CodingKey {
//        case currentPage = "current_page"
//        case data
//        case firstPageURL = "first_page_url"
//        case from
//        case nextPageURL = "next_page_url"
//        case path
//        case perPage = "per_page"
//        case prevPageURL = "prev_page_url"
//        case to
//    }
//}

// MARK: - Datum
struct Tag: Codable {
    let id: Int
    let title: String
    let multiBackground: MultiBackground?
    let previewSmallURL: String?
    let images: [ImageTag]

    enum CodingKeys: String, CodingKey {
        case id, title
        case multiBackground = "multi_background"
        case previewSmallURL = "preview_small_url"
        case images
    }
}

// MARK: - Image
struct ImageTag: Codable {
    let id: Int
    let previewSmallPath: String
    let previewSmallURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case previewSmallPath = "preview_small_path"
        case previewSmallURL = "preview_small_url"
    }
}

// MARK: - MultiBackground
struct MultiBackground: Codable {
    let imageID: [Int]

    enum CodingKeys: String, CodingKey {
        case imageID = "image_id"
    }
}

// MARK: - Encode/decode helpers

