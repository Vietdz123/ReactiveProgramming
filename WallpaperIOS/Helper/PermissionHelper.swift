//
//  PermissionHelper.swift
//  WallpaperIOS
//
//  Created by Mac on 23/08/2023.
//

import SwiftUI
import Photos


extension View{
    
    func getPhotoPermission(status : @escaping (Bool) -> () ){
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { statusss in
            switch statusss {
            case .authorized:
                DispatchQueue.main.async {
                    status(true)
                }
               
            case .denied, .restricted:
                DispatchQueue.main.async {
                    status(false)
                }
               
                print("Photo library access denied")
                
            case .notDetermined:
                DispatchQueue.main.async {
                    status(false)
                }
                print("Photo library access not determined")
                
            case .limited:
                DispatchQueue.main.async {
                    status(false)
                }
                print("Photo library access not limit")
            @unknown default:
                DispatchQueue.main.async {
                    status(false)
                }
                break
            }
        }
    }
    
    func getPhotoPermissionForCreateAlbum(status : @escaping (Bool) -> () ){
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { statusss in
            switch statusss {
            case .authorized:
                DispatchQueue.main.async {
                    status(true)
                }
               
            case .denied, .restricted:
                DispatchQueue.main.async {
                    status(false)
                }
               
                print("Photo library access denied")
                
            case .notDetermined:
                DispatchQueue.main.async {
                    status(false)
                }
                print("Photo library access not determined")
                
            case .limited:
                DispatchQueue.main.async {
                    status(false)
                }
                print("Photo library access not limit")
            @unknown default:
                DispatchQueue.main.async {
                    status(false)
                }
                break
            }
        }
    }
    
}
