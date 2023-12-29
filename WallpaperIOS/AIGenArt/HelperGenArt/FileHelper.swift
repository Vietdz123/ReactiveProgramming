//
//  FileHelper.swift
//  WallpaperIOS
//
//  Created by Duc on 18/12/2023.
//

import SwiftUI

extension View{
    func uiImageToUrlSanbox(uiImage : UIImage, onSuccess : @escaping (URL) -> (), onFailure : @escaping () -> ()){
        DispatchQueue.global(qos: .background).async {
            guard let imageData = uiImage.jpegData(compressionQuality: 1.0) else {
                DispatchQueue.main.async {
                    onFailure()
                }
                return
                
            }
            
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
            do {
                try imageData.write(to: fileURL)
                DispatchQueue.main.async {
                  onSuccess(fileURL)
                }
            } catch {
                DispatchQueue.main.async {
                    onFailure()
                }
            }
        }
    }
    
    
    func resizeImageIfNeeded(image: UIImage, onCompleted : @escaping (UIImage) -> ()) {
        let maxWidth: CGFloat = 1500
        let maxHeight: CGFloat = 1500
        
        let size = image.size
        
        if size.width <= maxWidth && size.height <= maxHeight {
            // Trả về ảnh gốc nếu không cần resize
            onCompleted(image)
        }
        
        let scaleFactor = min(maxWidth / size.width, maxHeight / size.height)
        let newWidth = size.width * scaleFactor
        let newHeight = size.height * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let resizedImage = resizedImage {
            return onCompleted(resizedImage)
        } else {
            onCompleted(image)
        }
    }
    
}
