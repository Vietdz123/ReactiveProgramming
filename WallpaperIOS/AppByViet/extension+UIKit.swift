//
//  extensionUIKit.swift
//  eWidget
//
//  Created by MAC on 06/12/2023.
//

import SwiftUI

import GoogleMobileAds
import UIKit
import Photos
import AVFoundation


extension UIDevice {
    var is_iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension CMTime {
    func getTimeString() -> String? {
        let totalSeconds = CMTimeGetSeconds(self)
        guard !(totalSeconds.isNaN || totalSeconds.isInfinite) else {
            return nil
        }
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i",arguments: [hours, minutes, seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes, seconds])
        }
    }
}



extension UIViewController {
    
    var heightAdaptiveBannerAds: CGFloat {
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(widthDevice).size.height
    }
    
    var insetBottom: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            return bottomPadding
        }
        return 0
    }
    
    func printPathRealm() {
        print("DEBUG: \(String(describing: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first))")
    }
    
//    func showToastSuccess(){
//        showToastWithContent(image: "checkmark", color: .green, mess: "Save Successfully")
//    }
//    
//    func showToastWithContent(image : String, color : Color, mess : String){
//        DispatchQueue.main.async {
//            
//            guard let window = UIApplication.shared.keyWindow else { return }
//            if window.subviews.contains(where: {
//                view in
//                return view.tag == 1008
//            }){
//                return
//            }
//            
//            let rootview = ToastView(image: image, mess: mess, color: color)
//            
//            let toastViewController = UIHostingController(rootView: rootview)
//            let size  = toastViewController.view.intrinsicContentSize
//            toastViewController.view.frame.size = size
//            toastViewController.view.backgroundColor = .clear
//            toastViewController.view.frame.origin = CGPoint(x: ( getRect().width - size.width ) / 2 , y: getRect().height - 150)
//            toastViewController.view.tag = 1008
//            toastViewController.view.layer.zPosition = 1.0
//            print("showToastWithContent")
//            
//            window.addSubview(toastViewController.view)
//            
//            
//        }
//    }
}

extension UIView {
    
    func pinToEdges(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: view.leftAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func applyBlurBackground(style: UIBlurEffect.Style,
                             alpha: CGFloat = 1,
                             top: CGFloat = 0,
                             bottom: CGFloat = 0) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = alpha
        addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: rightAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom),
        ])
    }
    
    func applyGradient(colours: [UIColor])  {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func generateThumbnail(path: URL, identifier: String,
                           completion: @escaping (_ thumbnail: UIImage?, _ identifier: String) -> Void) {
        
        let asset = AVURLAsset(url: path, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        
        imgGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: .zero)]) { _, image, _, _, _ in
            if let image = image {
                DispatchQueue.main.async {
                    completion(UIImage(cgImage: image), identifier)
                }
            }
        }
    }
    

    
    func dropShadow() {
        clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }
    
    func fadeIn(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        } completion: { _ in
            onCompletion?()
        }
    }
    
    func fadeOut(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
            onCompletion?()
        }
    }
}


extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}




extension UICollectionViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension URL {
    static func cache() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func document() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first else {return nil}
        let folderURL = documentDirectory.appendingPathComponent(folderName)
        
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                
                try fileManager.createDirectory(atPath: folderURL.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return folderURL
    }
    
    static func downloadFolder() -> URL? {
        return self.createFolder(folderName: "Download")
    }
    
    static func importFolder() -> URL? {
        return self.createFolder(folderName: "Import")
    }
    
    static func zipItemFolder() -> URL? {
        return self.createFolder(folderName: "ZipItem")
    }
    
    static func getFolderSize(urls: [URL]) -> String {
        var totalSize: UInt64 = 0
        for url in urls {
            totalSize += url.fileSize
        }
        return ByteCountFormatter.string(fromByteCount: Int64(totalSize), countStyle: .file)
    }
    
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}

/// Get folder size
extension URL {
    /// check if the URL is a directory and if it is reachable
    func isDirectoryAndReachable() throws -> Bool {
        guard try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true else {
            return false
        }
        return try checkResourceIsReachable()
    }
    
    /// returns total allocated size of a the directory including its subFolders or not
    func directoryTotalAllocatedSize(includingSubfolders: Bool = true) throws -> Int? {
        guard try isDirectoryAndReachable() else { return nil }
        if includingSubfolders {
            guard
                let urls = FileManager.default.enumerator(at: self, includingPropertiesForKeys: nil)?.allObjects as? [URL] else { return nil }
            return try urls.lazy.reduce(0) {
                (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0) + $0
            }
        }
        return try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil).lazy.reduce(0) {
            (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey])
                .totalFileAllocatedSize ?? 0) + $0
        }
    }
    
    /// returns the directory total size on disk
    func sizeOnDisk() throws -> String? {
        guard let size = try directoryTotalAllocatedSize() else { return nil }
        return ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
    }
}



extension PHAsset {
    
    var getImageMaxSize : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        imageManager.requestImage(for: self, targetSize: CGSize.init(width: 720, height: 1080), contentMode: .aspectFit, options: option, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
    
    
    var getImageThumb : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        
        imageManager.requestImage(for: self, targetSize: CGSize.init(width: 400, height: 400), contentMode: .aspectFit, options: option, resultHandler: { image, _ in
            guard let image = image else {return}
            thumbnail = image
        })
        return thumbnail
    }
    
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
    var originalName: String? {
        let str = PHAssetResource.assetResources(for: self).first?.originalFilename.dropLast(4)
        return "\(str ?? "Video")"
    }
    
    func getDuration(videoAsset: PHAsset?) -> String {
        guard let asset = videoAsset else { return "00:00" }
        let duration: TimeInterval = asset.duration
        let s: Int = Int(duration) % 60
        let m: Int = Int(duration) / 60
        let formattedDuration = String(format: "%02d:%02d", m, s)
        return formattedDuration
    }
}


extension UIViewController {
    
    func getRootViewController() -> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    func showAlert() {
        
    }
    
}
