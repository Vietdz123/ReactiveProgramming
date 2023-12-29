//
//  Model.swift
//  EztGenArt
//
//  Created by Duc on 14/12/2023.
//

import SwiftUI


struct GenArtResponse : Codable {
    let data : GenArtData
}

struct GenArtData : Codable{
    let data : [GenArtModel]
}

struct GenArtModel : Codable{
    let id : Int
    let name : String
    let thumbnails : [GenArtThumbnail]
}

struct GenArtThumbnail : Codable{
    let path : GenArtPath
}

struct GenArtPath : Codable{
    let preview : String
}


struct EztSendResponse: Codable {
    let data: SendResponse
}

struct SendResponse: Codable {
    let id, status: Int
}


struct EztGetResponse : Codable{
    let data : GetResponse
    
}

struct GetResponse : Codable{
    let id : Int
    let type : Int
    let status : Int
    let value : EztValue?

}

struct EztData : Codable{
    let path : String
    let upscale : Int?
  //  let api_params : ListString
    let url : String
}

struct ListString : Codable{
    let image : [String]
}

struct EztValue : Codable{
    let path : String
    let type : String
    let url : String
    let prompt : String?
}
