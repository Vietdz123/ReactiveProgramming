//
//  DailyGiftDialog.swift
//  WallpaperIOS
//
//  Created by Mac on 13/06/2023.
//

import SwiftUI
import Photos

struct DailyGiftDialog: View {
    let wallpaper : Wallpaper
    @Binding var show : Bool
    @Binding var getGift : Bool
    
    init(wallpaper: Wallpaper, show: Binding<Bool>, getGift: Binding<Bool>) {
        let saveWLToday : String = UserDefaults.standard.string(forKey: "wl_today") ?? ""
        if saveWLToday == Date().toString(format: "dd/MM/yyyy"){
           
            if let saveWL = UserDefaults.standard.object(forKey: "SavedWL") as? Data {
                let decoder = JSONDecoder()
                if let wl = try? decoder.decode(Wallpaper.self, from: saveWL) {
                    print("DailyGiftDialog \(wl.id)")
                    self.wallpaper = wl
                }else{
                    self.wallpaper = wallpaper
                }
            }else{
                self.wallpaper = wallpaper
            }
            
        }else{
           
            self.wallpaper = wallpaper
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(wallpaper) {
                UserDefaults.standard.set(encoded, forKey: "SavedWL")
                UserDefaults.standard.set(Date().toString(format: "dd/MM/yyyy"), forKey: "wl_today")
            }
        }
        self._show = show
        self._getGift = getGift
    }
    
    var body: some View {
        VStack(spacing : 0){
            HStack{
                Button(action: {
                    withAnimation{
                        show = false
                    }
                }, label: {
                    Image("close.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(16)
                })
                
                
            }.frame(maxWidth: .infinity, alignment: .trailing)
            
            Text("DAILY Gift!")
                .mfont(24, .bold)
                .foregroundColor(.main)
            
            GeometryReader{
                proxy in
                let size = proxy.size
                ZStack(alignment: .topLeading){
                    
                    
                    
                    AsyncImage(url: URL(string: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))){
                        phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .clipped()
                            
                        } else if phase.error != nil {
                            AsyncImage(url: URL(string: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))){
                                phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: size.width, height: size.height)
                                        .clipped()
                                }
                            }
                            
                        } else {
                            ResizableLottieView(filename: "placeholder_anim")
                                .frame(width: 200, height: 200)
                                .frame(width: size.width, height: size.height)
                        }
                        
                        
                    }.cornerRadius(8)
                    
                    HStack(spacing : 0){
                        Image("coin")
                            .resizable()
                            .frame(width: 12, height: 12)
                        Text(" \(wallpaper.cost ?? 0)")
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                        
                    }.frame(width: 36, height: 18)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.7))
                        )
                        .padding(8)
                    
                }
                
            }
            .padding(.top, 16)
            .padding(.bottom, 24)
            .padding(.horizontal, 48)
            
            Button(action: {
                getPhotoPermission(status: {
                    b in
                    if b {
                        downloadImageToGallery(title: "image\(wallpaper.id)", urlStr: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
                    }
                })
              
            }, label: {
                HStack(spacing : 0){
                    Image("download")
                        .resizable()
                        .frame(width: 26.67, height: 26.67)
                        .padding(.horizontal, 26.67)
                    
                    Text("Get Now Free")
                        .mfont(17, .bold)
                        .foregroundColor(.white)
                        .padding(.leading, 13.33)
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 48)
                    .background(
                        ZStack{
                            Capsule()
                                .fill(Color.black.opacity(0.4))
                            
                            Capsule()
                                .stroke( Color.white , lineWidth: 1)
                        }
                    )
                    .padding(.horizontal, 48)
                    .padding(.bottom, 100)
            })
            
//            Text("OR")
//                .padding(.vertical, 4)
//                .mfont(24, .bold)
//                .foregroundColor(.white)
//
//            Button(action: {
//                let currentCoin = UserDefaults.standard.integer(forKey: "current_coin")
//                UserDefaults.standard.set(Date().toString(format: "dd/MM/yyyy") , forKey: "date_get_gift" )
//                UserDefaults.standard.set(currentCoin + 1, forKey: "current_coin")
//                showToastWithContent(image: "checkmark", color: .green, mess: "You have received 1 Ecoin!")
//                withAnimation{
//                    show = false
//                    getGift = true
//                }
//            }, label: {
//                HStack(spacing : 0){
//                    Image("coin")
//                        .resizable()
//                        .frame(width: 26.67, height: 26.67)
//                        .padding(.horizontal, 26.67)
//
//                    Text("Get 1 Ecoin for Free")
//                        .mfont(17, .bold)
//                        .foregroundColor(.white)
//
//                }.frame(maxWidth: .infinity, alignment: .leading)
//                    .frame(height: 48)
//                    .background(
//                        ZStack{
//                            Capsule()
//                                .fill(Color.black.opacity(0.4))
//                            Capsule()
//                                .stroke( Color.white , lineWidth: 1)
//                        }
//                    )
//                    .padding(.horizontal, 48)
//
//            })
//            .padding(.bottom, 32)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity ,alignment: .top)
            .background(
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .ignoresSafeArea()
            )

    }
    
    func downloadImageToGallery(title : String, urlStr : String){
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask? = nil
        DispatchQueue.global(qos: .background).async {
            let imgURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageDownloaded")
            print("FILE_MANAGE \(imgURL)")
            if let url = URL(string: urlStr) {
                let filePath = imgURL.appendingPathComponent("\(title).jpg")
                if FileManager.default.fileExists(atPath: filePath.path){
                    DispatchQueue.main.async {
                        showToastWithContent(image: "xmark", color: .red, mess: "File already exists!")
                    }
                    
                    return
                }
                dataTask = defaultSession.dataTask(with: url, completionHandler: {  data, res, err in
                    DispatchQueue.main.async {
                        do {
                            try data?.write(to: filePath)
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: filePath)
                            }) { completed, error in
                                if completed {
                                    DispatchQueue.main.async {
                                        UserDefaults.standard.set("date_get_gift", forKey: Date().toString(format: "dd/MM/yyyy"))
                                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                                        withAnimation{
                                            show = false
                                            getGift = true
                                        }
                                        
                                        
                                    }
                                    
                                } else if let error = error {
                                    DispatchQueue.main.async {
                                        showToastWithContent(image: "xmark", color: .red, mess: error.localizedDescription)
                                    }
                                    
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                showToastWithContent(image: "xmark", color: .red, mess: error.localizedDescription)
                            }
                            
                        }
                    }
                    dataTask = nil
                })
                dataTask?.resume()
            }
        }
        
    }
    
}

