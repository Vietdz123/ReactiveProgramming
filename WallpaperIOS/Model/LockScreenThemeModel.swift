//
//  LockScreenThemeModel.swift
//  WallpaperIOS
//
//  Created by Duc on 07/05/2024.
//

import SwiftUI

struct LockScreenResponse: Codable, Hashable {
    let data: LockScreenData
}

struct LockScreenData : Codable, Hashable{
    let data  : [LockScreenObj]
}

struct LockScreenObj: Codable, Hashable {
    let id, order: Int
    let license: String
    let content: [LockContent]
    let trend: Int
    let thumbnail: [LockThumbnail]
    let active, category_id: Int
    
    let `private` : Int
}

struct LockContent: Codable, Hashable {
    let id: Int
    let data: ContentData?
    let type: String
}

struct ContentData: Codable, Hashable {
    let images: [LockThumbnail]?
    let fontID, fontSize: Int?
    let background: [LockThumbnail]?
    let contentInline: String?
    let delayAnimation: Int?

    enum CodingKeys: String, CodingKey {
        case images
        case fontID = "font_id"
        case fontSize = "font_size"
        case background
        case contentInline = "content_inline"
        case delayAnimation = "delay_animation"
    }
}



struct LockThumbnail: Codable, Hashable {
    let url: PathPath
    let keyType: String?
    let fileName: String?
    let typeFile: String?

    enum CodingKeys: String, CodingKey {
        case url
        case keyType = "key_type"
        case fileName = "file_name"
        case typeFile = "type_file"
    }
}
