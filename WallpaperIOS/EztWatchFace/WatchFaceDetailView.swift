//
//  WatchFaceDetailView.swift
//  WallpaperIOS
//
//  Created by Duc on 24/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct WatchFaceDetailView: View {
    let wallpaper : SpWallpaper
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        
        ZStack(alignment: .bottom){
            VStack(spacing : 0){
                HStack(spacing : 0){
                    Image("menu")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        .frame(width: 48, height: 48, alignment: .center)
                        .containerShape(Rectangle())
                    Spacer()
                    Text("Watch Face".toLocalize())
                        .mfont(20, .bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.main)
                    Spacer()
                    Image("search")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        .frame(width: 48, height: 48, alignment: .center)
                }.frame(maxWidth: .infinity)
                    .frame(height: 48)
                Spacer()
                
            }
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
                .opacity(0.9)
            
            VStack(spacing : 0){
             
                HStack{
                    Button(action: {
                    
                    }, label: {
                        Image("share2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    }).padding(.trailing, 24)
                    
                    NavigationLink(destination: {
                    WatchFaceTutorialView()
                    }, label: {
                        Image("help")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    })
                    Spacer()
                 
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("close.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    })
                }.padding(.horizontal, 16)
                    .overlay(
                        Text("Preview".toLocalize())
                            .mfont(17, .bold)
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                    )
                
                
                GeometryReader{
                    proxy in
                    
                    ZStack{
                        WebImage(url: URL(string:  wallpaper.path.first?.path.full ?? ""))
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight : .infinity)
                            .padding(.leading, 14)
                            .padding(.trailing, 21)
                        Image("watchface_mockup")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight : .infinity)
                    }
                    
                   
                }.frame(width: 163, height: 276)
                    .padding(.vertical, 24)
             
                Button(action: {
                    
                  
                    downloadImageToGallery(title: "Watch_\(wallpaper.id)", urlStr: wallpaper.path.first?.path.full ?? "")
                    
                   
                }, label: {
                    Text("Save".toLocalize())
                        .mfont(16, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                      .frame(width: 240, height: 48)
                      .background(
                        Capsule()
                            .fill(Color.main)
                      )
                })
                .padding(.bottom, 40)
                
            }.padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
                .background(
                    Image("bg_watchface")
                        .resizable()
                        .scaledToFill()
                        .clipped()
                )
                .cornerRadius(16)
            
          
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .addBackground()
        .edgesIgnoringSafeArea(.bottom)
        
     
       
    }
    
    func downloadImageToGallery(title : String, urlStr : String){
       
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url {
                DownloadFileHelper.saveImageToLibFromURLSanbox(url: url, onComplete: {
                    success in
                    if success{
                      //  ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
//                        if UserDefaults.standard.bool(forKey: "firsttime_showtuto") == false {
//                            UserDefaults.standard.set(true, forKey: "firsttime_showtuto")
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                               // ctrlViewModel.showTutorial = true
//                            })
//                        }
                        
//                        let downloadCount = UserDefaults.standard.integer(forKey: "user_download_count")
//                        UserDefaults.standard.set(downloadCount + 1, forKey: "user_download_count")
//                        if !store.isPro() && downloadCount == 1 {
//                           // ctrlViewModel.navigateView.toggle()
//                        }else{
//                            showRateView()
//                        }
                    }else{
                      //  ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
                    }
                })
            }
//            else{
//                ctrlViewModel.isDownloading = false
//                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
//            }
        })
        
     
        
    }
}


