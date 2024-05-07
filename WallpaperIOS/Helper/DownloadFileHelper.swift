//
//  DownloadFileHelper.swift
//  WallpaperIOS
//
//  Created by Duc on 28/09/2023.
//

import SwiftUI
import Photos

class DownloadFileHelper {
  static  func downloadFromUrlToSanbox(fileName: String ,urlImage : URL? ,onCompleted : @escaping (URL?) -> () ) {
        guard let url = urlImage else{
            print("DownloadFileHelper invalidate URL Image")
            onCompleted(nil)
            return
        }
        
        let folderImage  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageDownloaded")
      
     
      
        let filePath = folderImage.appendingPathComponent("\(fileName).jpg")
        if FileManager.default.fileExists(atPath: filePath.path){
            print("DownloadFileHelper has file \(filePath)")
            onCompleted( filePath )
            return
        }
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask? = nil
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: {  data, res, err in
            
            if let err {
                DispatchQueue.main.async {
                    print("DownloadFileHelper error download \(err.localizedDescription)")
                    onCompleted( nil)
                }
               
            }
            
            if let  data{
                do {
                    try data.write(to: filePath)
                    DispatchQueue.main.async {
                        print("DownloadFileHelper download file success \(filePath.absoluteString)")
                        onCompleted( filePath )
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("DownloadFileHelper can't write file")
                        onCompleted( nil )
                    }
                }
            }else{
                DispatchQueue.main.async {
                    print("DownloadFileHelper data Validate")
                    onCompleted( nil )
                }
            }

            dataTask = nil
        })
        
        dataTask?.resume()
    }
    
   static func saveImageToLibFromURLSanbox(url : URL, onComplete : @escaping (Bool) -> () ){
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
        }) { completed, error in
            if completed {
                DispatchQueue.main.async {
                    print("DownloadFileHelper save to photo success")
                    onComplete(true)
                    
                }
                
            } else if let err = error {
                DispatchQueue.main.async {
                    print("DownloadFileHelper save to photo error \(err.localizedDescription)")
                    onComplete(false)
                }
            }else{
                DispatchQueue.main.async {
                    print("DownloadFileHelper save to photo error unknow")
                    onComplete(false)
                }
            }
        }
    }
    
    
    static func saveVideoLiveToLibSanbox(fileName: String , videoURL : URL? , onCompleted : @escaping (URL?) -> () ){
        guard let url = videoURL else{
            print("DownloadFileHelper invalidate URL Video")
            onCompleted(nil)
            return
        }
        
        let folderVideo  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VideoDownloaded")
        let filePath = folderVideo.appendingPathComponent("\(fileName).mp4")
        if FileManager.default.fileExists(atPath: filePath.path){
            onCompleted( filePath )
            return
        }
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask? = nil
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: {  data, res, err in
            
            if let  err {
                DispatchQueue.main.async {
                    print("DownloadFileHelper error download \(err.localizedDescription)")
                    onCompleted( nil)
                }
               
            }
            
            if let  data{
                do {
                    try data.write(to: filePath)
                    DispatchQueue.main.async {
                        print("DownloadFileHelper download file success \(filePath.absoluteString)")
                        onCompleted( filePath )
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("DownloadFileHelper can't write file")
                        onCompleted( nil )
                    }
                }
            }else{
                DispatchQueue.main.async {
                    print("DownloadFileHelper data Validate")
                    onCompleted( nil )
                }
            }

            dataTask = nil
        })
        
        dataTask?.resume()
    }
    
}


//func downloadImageToGallery(title : String, urlStr : String){
//
//    DispatchQueue.main.async {
//        ctrlViewModel.isDownloading = true
//    }
//
//    let defaultSession = URLSession(configuration: .default)
//    var dataTask: URLSessionDataTask? = nil
//    DispatchQueue.global(qos: .background).async {
//        let imgURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageDownloaded")
//        print("FILE_MANAGE \(imgURL)")
//        if let url = URL(string: urlStr) {
//            let filePath = imgURL.appendingPathComponent("\(title).jpg")
//            if FileManager.default.fileExists(atPath: filePath.path){
//                DispatchQueue.main.async {
//                    ctrlViewModel.isDownloading = false
//                    showToastWithContent(image: "xmark", color: .red, mess: "File already exists!")
//                }
//                return
//            }
//            dataTask = defaultSession.dataTask(with: url, completionHandler: {  data, res, err in
//                DispatchQueue.main.async {
//                    do {
//                        try data?.write(to: filePath)
//                        PHPhotoLibrary.shared().performChanges({
//                            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: filePath)
//                        }) { completed, error in
//                            if completed {
//                                DispatchQueue.main.async {
//                                    ctrlViewModel.isDownloading = false
//                                    showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
//                                    if UserDefaults.standard.bool(forKey: "firsttime_showtuto") == false {
//                                        UserDefaults.standard.set(true, forKey: "firsttime_showtuto")
//                                        ctrlViewModel.showTutorial = true
//                                    }
//
//                                    let downloadCount = UserDefaults.standard.integer(forKey: "user_download_count")
//                                    UserDefaults.standard.set(downloadCount + 1, forKey: "user_download_count")
//                                    if !store.isPro() && downloadCount == 1 {
//                                        ctrlViewModel.navigateView.toggle()
//                                    }else{
//                                        showRateView()
//                                    }
//
//
//                                }
//
//                            } else if let error = error {
//                                DispatchQueue.main.async {
//                                    ctrlViewModel.isDownloading = false
//                                    showToastWithContent(image: "xmark", color: .red, mess: error.localizedDescription)
//                                }
//
//                            }
//                        }
//                    } catch {
//                        DispatchQueue.main.async {
//                            ctrlViewModel.isDownloading = false
//                            showToastWithContent(image: "xmark", color: .red, mess: error.localizedDescription)
//                        }
//
//                    }
//                }
//                dataTask = nil
//            })
//            dataTask?.resume()
//        }
//    }
//}
