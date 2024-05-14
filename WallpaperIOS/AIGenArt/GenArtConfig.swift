//
//  GenArtConfig.swift
//  WallpaperIOS
//
//  Created by Duc on 18/12/2023.
//

import Foundation

struct GenArtConfig {
    static let token : String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MDI0Mzc5OTAsImRhdGEiOnsidXNlcl9pZCI6MCwiZGV2aWNlX2lkIjowLCJjbGllbnRfaWQiOiJBcHAgRGV2IiwibmFtZSI6IklwaG9uZSAxMSIsInR5cGUiOjJ9LCJleHAiOjE3MDUwMjk5OTB9.UtrO-MnvMBqNa7JV_trzmEBDSMZUX6K8j0-mDBoarPg"
    
    static let sendImageToServerURL = "https://api.ezedit.ai/api/v1/stable-diffusion/img2img"
    static let sendPromptToServerURL = "https://api.ezedit.ai/api/v1/stable-diffusion/txt2img"
    static let getImageServerURL = "https://api.ezedit.ai/api/v1/queues-ai/"
    static let getAllModelURL = "https://api.ezedit.ai/api/v1/stable-models?order_by=order+desc,id+desc&fields=id,thumbnails,name&app=5"
    static let forbiddenURL = "https://api.ezedit.ai/api/v1/configurations?fields=key,value&where=key+stb_prompt_filter"
    
    static var forbiddenKeywords : [String] = []

    
    static let errorToast : String = "Error"
    
    static func checkKeyWord(text : String) -> Bool {
        let words = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
         let lowercasedKeywords = forbiddenKeywords.map { $0.lowercased() }
         
         for word in words {
             let lowercasedWord = word.lowercased()
             if lowercasedKeywords.contains(lowercasedWord) {
                 return true
             }
         }
         
         return false
    }
    
    static func getForbiddenResponse(){
        guard let url = URL(string: forbiddenURL) else { return }
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            
            let forbinndenRes = try? JSONDecoder().decode(ForbiddenResponse.self, from: data)
            DispatchQueue.main.async {
                if let value = forbinndenRes?.data.first?.value {
                    self.forbiddenKeywords = value.components(separatedBy: ",")
                    print("forbiddenKeywords count \(forbiddenKeywords.count)")
                }
            }
            
        }.resume()
    }
    
}

struct ForbiddenResponse : Codable {
    let data : [ForbiddenData]
}

struct ForbiddenData : Codable {
    let key : String
    let value : String
}
