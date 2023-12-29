//
//  JWTHelper.swift
//  EztGenArt
//
//  Created by Duc on 14/12/2023.
//

import Foundation
import UIKit
import SwiftJWT


struct TokenHelper{
    
    
    static func genToken(onSuccess : @escaping (String) -> (), onFailure : @escaping () -> () ){
        let typeDevice = 2 // 2 for IOS
        let createdTime = Int(Date().timeIntervalSince1970 + 60 * 60 * 24)
        let data = ClaimData(userId: 0, deviceId: 0, type: typeDevice, name: Utils.deviceName, clientId: Utils.deviceID)
        let signer = JWTSigner.hs256(key: "YCRLIVHEKCVYMUIGJTPXKYVCTXSHBWDSWZFHLUWEBOLNSQKHUIQVTCMESLBIHMGSNGHEAFTANSTUNCYBVTIBJXSHQWJEFGMVNQOQ".data(using: .utf8) ?? Data())
        var jwt = JWT(claims: MyClaims(data: data, exp: createdTime))
        do {
            let encodedToken = try jwt.sign(using: signer)
            print("JWT: \(encodedToken)")
            onSuccess(encodedToken)

        } catch {
            onFailure()
            print("Error encoding JSON to JWT: \(error)")
        }
    }
}


struct MyClaims: Claims {
    var data: ClaimData
    var exp: Int
}

struct ClaimData: Codable {
    var userId: Int
    var deviceId: Int
    var type: Int
    var name: String
    var clientId: String
    
    enum CodingKeys : String, CodingKey {
        case userId = "user_id"
        case deviceId = "device_id"
        case clientId = "client_id"
        case type
        case name
    }
}

struct Utils{
    static var deviceID: String {
          return UIDevice.current.identifierForVendor?.uuidString ?? ""
      }
      
      static var deviceName: String {
          return UIDevice.current.name
      }
}


