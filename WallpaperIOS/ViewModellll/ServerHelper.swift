//
//  ServerHelper.swift
//  WallpaperIOS
//
//  Created by Mac on 20/06/2023.
//

import SwiftUI

struct ServerHelper {
    
    static var eztEmpeloyee : Bool = false
    
    
    //MARK: for wallpaper thường
   static func sendImageDataToServer(type : String = "set", id : Int){
       
       if eztEmpeloyee{
           print("Ezt eztEmpeloyee")
           return
       }
       print("Ezt senddata")
       
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
  
    //MARK: for specail wallpaper == depth effect, dynamic ....
    static func sendImageSpecialDataToServer(type : String = "download", id : Int){
        if eztEmpeloyee{
            print("Ezt eztEmpeloyee")
            return
        }
        print("Ezt senddata")
        
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
    
    //MARK: for specail live wallpaper
    static func sendVideoSpecialDataToServer(type : String = "download", id : Int){
        if eztEmpeloyee{
            print("Ezt eztEmpeloyee")
            return
        }
        print("Ezt senddata")
        
         let country = UserDefaults.standard.string(forKey: "user_country") ?? "unknow"
         let parameters: [String: Any] = ["video_special_id": id, "type": type, "country" : country, "app" : 2 ]
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
             print("Ezt senddata success")
         }).resume()
     }
    
    
    static func sendDataWidget(type : String = "set", widget_id : Int){
        if eztEmpeloyee{
            print("Ezt eztEmpeloyee")
            return
        }
        print("Ezt senddata")
        
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
    
    //MARK: for wallpaper thường
   static func sendLockScreenThemeDataToServer(type : String = "set", id : Int){
       
       if UserDefaults.standard.bool(forKey: "send_lockthemedata_\(id)") == false {
           UserDefaults.standard.setValue(true, forKey: "send_lockthemedata_\(id)")
           print("sendLockScreenThemeDataToServer send from id \(id)")
       }else{
           print("sendLockScreenThemeDataToServer da send from id \(id), khong send nua")
           return
       }
       
       if eztEmpeloyee{
           print("Ezt eztEmpeloyee")
           return
       }
       print("Ezt senddata")
       
        let country = UserDefaults.standard.string(forKey: "user_country") ?? "unknow"
        let parameters: [String: Any] = ["theme_id": id, "type": type, "country" : country, "app" : 2 ]
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
    
}

