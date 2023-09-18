//
//  FileSaveViewModel.swift
//  WallpaperIOS
//
//  Created by Mac on 08/05/2023.
//

import SwiftUI
import FileProvider

class FileSaveViewModel: ObservableObject {
    
    let fileManager = FileManager.default
    @Published var imageDownloadeds : [URL] = []
    @Published var videoDownloadeds : [URL] = []
    
    @Published var imageDirectory : URL
    @Published var videotDirectory : URL
    
    
    init(){
        self.imageDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageDownloaded")
        self.videotDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VideoDownloaded")
        getListImage()
        getListVideo()
    }
    
    
    func getListImage() {
        do {
            imageDownloadeds = try fileManager.contentsOfDirectory(at: imageDirectory, includingPropertiesForKeys: [.creationDateKey]).sorted(by: {
                if let date1 = try? $0.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate,
                   let date2 = try? $1.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate {
                    return date1 > date2
                }
                return false
            })

        } catch {
            imageDownloadeds = []
           
        }
        
    }
    
    func getListVideo(){
        do {
            videoDownloadeds = try fileManager.contentsOfDirectory(at: videotDirectory, includingPropertiesForKeys: [.creationDateKey]).sorted(by: {
                if let date1 = try? $0.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate,
                   let date2 = try? $1.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate {
                    return date1 > date2
                }
                return false
            })

        } catch {
            videoDownloadeds = []
        }
    }
}

