//
//  ServerHelper.swift
//  WallpaperIOS
//
//  Created by Mac on 20/06/2023.
//

import SwiftUI

struct ServerHelper {
   static func sendImageDataToServer(type : String, id : Int){
        let country = UserDefaults.standard.string(forKey: "user_country") ?? "unknow"
        let parameters: [String: Any] = ["image_id": id, "type": type, "country" : country, "app" : 2 ]
        let domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        guard let url = URL(string: "\(domain)api/v1/update-statistical") else {
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }
        
        session.dataTask(with: request, completionHandler: {
            _, _, _ in
        }).resume()
    }
    
    static func sendVideoDataToServer(type : String, id : Int){
         let country = UserDefaults.standard.string(forKey: "user_country") ?? "unknow"
         let parameters: [String: Any] = ["video_id": id, "type": type, "country" : country, "app" : 2 ]
         let domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
         guard let url = URL(string: "\(domain)api/v1/update-statistical") else {
             return
         }
         
         let session = URLSession.shared
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         
         do {
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
         } catch let error {
           print(error.localizedDescription)
           return
         }
         
         session.dataTask(with: request, completionHandler: {
             _, _, _ in

         }).resume()
     }
    
    static func sendImageSpecialDataToServer(type : String, id : Int){
         let country = UserDefaults.standard.string(forKey: "user_country") ?? "unknow"
         let parameters: [String: Any] = ["image_special_id": id, "type": type, "country" : country, "app" : 2 ]
         let domain = UserDefaults.standard.string(forKey: "wl_domain") ?? "https://wallpaper.eztechglobal.com/"
        
         guard let url = URL(string: "\(domain)api/v1/update-statistical") else {
             return
         }
         let session = URLSession.shared
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         do {
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
         } catch let error {
           print(error.localizedDescription)
           return
         }
         
         session.dataTask(with: request, completionHandler: {
             _, _, _ in
         }).resume()
     }
    
    
    static func sendDataWidget(type : String = "set", widget_id : Int){
         let country = UserDefaults.standard.string(forKey: "user_country") ?? "unknow"
         let parameters: [String: Any] = ["widget_id": widget_id, type: 1, "country" : country, "app_id" : 2 ]
   
        
         guard let url = URL(string: "https://widget.eztechglobal.com/api/v1/log_traffic") else {
             return
         }
         let session = URLSession.shared
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         do {
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
         } catch let error {
           print(error.localizedDescription)
           return
         }
         
         session.dataTask(with: request, completionHandler: {
             _, _, _ in
             
             
         }).resume()
     }
    
}

