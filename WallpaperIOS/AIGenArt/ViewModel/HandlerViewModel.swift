//
//  HandlerViewModel.swift
//  EztGenArt
//
//  Created by Duc on 14/12/2023.
//

import SwiftUI

class HandlerViewModel: ObservableObject {
    
    func sendImageDataToServer( token : String, idModel : Int , prompt : String? ,fileURL : URL , onSuccess : @escaping (Int) -> (), onFailure: @escaping () -> () )  {
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 30 * 1024 * 1024, diskPath: nil)
        let session = URLSession(configuration: configuration)
        
      
        var parameters: [String: Any] = ["model" : idModel]
        if let prompt{
            parameters = ["model" : idModel, "prompt" : prompt ]
        }
        
        let boundary = UUID().uuidString
        guard let url = URL(string: GenArtConfig.sendImageToServerURL) else {
            onFailure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "AuthorizationApi")
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
       
        var body = Data()
        if let fileData = try? Data(contentsOf: fileURL) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let sendImageTask =  session.dataTask(with: request, completionHandler: {
            data, response, error in
            if let err = error {
                print("ImageHandlerViewModel sendImage err \(err.localizedDescription)")
                onFailure()
                return
            }
            
            
            
            
            if let httpResponse = response as? HTTPURLResponse {
                print("ImageHandlerViewModel \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 422 {
                    onFailure()
                    return
                }
                
            }
            
            
            
            if let data{
                do{
                    
                    let eztResponse = try JSONDecoder().decode(EztSendResponse.self, from: data)
                    
                    let id = eztResponse.data.id
                    onSuccess(id)
                }catch{
                    print(error.localizedDescription)
                }
                
                
                
                
                
            }else{
                print("ImageHandlerViewModel sendImage no result 4")
                onFailure()
            }
            
            
        })
        
        sendImageTask.resume()
        
    }
    
    
    func sendPromptDataToServer(token : String, idModel : Int ,prompt : String,onSuccess : @escaping (Int) -> (), onFailure: @escaping () -> () )  {
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 30 * 1024 * 1024, diskPath: nil)
        let session = URLSession(configuration: configuration)
        
        
        let parameters: [String: Any] = ["model" : idModel,  "prompt" : prompt.trimmingCharacters(in: .whitespacesAndNewlines)]
        let boundary = UUID().uuidString
        guard let url = URL(string: GenArtConfig.sendPromptToServerURL) else {
            onFailure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "AuthorizationApi")
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var body = Data()

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let sendImageTask =  session.dataTask(with: request, completionHandler: {
            data, response, error in
            if let err = error {
                print("ImageHandlerViewModel sendImage err \(err.localizedDescription)")
                onFailure()
                return
            }
            
            
            
            if let httpResponse = response as? HTTPURLResponse {
                print("ImageHandlerViewModel \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 422 {
                    onFailure()
                    return
                }
                
            }
            
            
            
            if let data{
                do{
                    let eztResponse = try JSONDecoder().decode(EztSendResponse.self, from: data)
                    let id = eztResponse.data.id
                    onSuccess(id)
                }catch{
                    print(error.localizedDescription)
                }
                
                
                
                
                
            }else{
                print("ImageHandlerViewModel sendImage no result 4")
                onFailure()
            }
            
            
        })
        
        sendImageTask.resume()
        
    }
    
    func getImageFromServer(genFree : Bool = false ,token : String, id : Int, onSuccess : @escaping (EztValue) -> (), onFailure : @escaping () -> () ){
        
        guard let url = URL(string: "\(GenArtConfig.getImageServerURL)\(id)") else{
            onFailure()
            return
        }
        
        print(url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "AuthorizationApi")
        
       
        
       let  getImageTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    onFailure()
                }
                return
            }
            
            if let data {
                if let itemsCurrentLoad = try? JSONDecoder().decode(EztGetResponse.self, from: data){
                   
                    let statusCode = itemsCurrentLoad.data.status
                    print(statusCode)
//                    0: Chờ
//                    1: Đang xử lý
//                    2: Thành công
//                    3: Lỗi
                    if statusCode == 0 || statusCode == 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                            self.getImageFromServer(token : token ,id: id, onSuccess: onSuccess, onFailure: onFailure)
                        })
                    }else if statusCode == 2 {
                        DispatchQueue.main.async {

                            
                            if let eztValue = itemsCurrentLoad.data.value{
                                if !genFree {
                                    GenArtLimitHelper.increaseLimitGenArt()
                                }
                                onSuccess(eztValue)
                            }else{
                                onFailure()
                            }
                          
                        }
                    }else if statusCode == 3{
                        DispatchQueue.main.async {
                            onFailure()
                        }
                    }


                }else{
                    DispatchQueue.main.async {
                        onFailure()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    onFailure()
                }
            }
            
            
        }
 
            getImageTask.resume()
    }
    
}
