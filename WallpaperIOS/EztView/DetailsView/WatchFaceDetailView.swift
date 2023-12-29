//
//  WatchFaceDetailView.swift
//  WallpaperIOS
//
//  Created by Duc on 24/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct WatchFaceDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    let wallpaper : SpWallpaper
    @State var showBuySubAtScreen : Bool = false
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @State var showTuto : Bool = false
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
                        shareLinkApp()
                    }, label: {
                        Image("share2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    })
                    if !store.isPro(){
                        Image("crown")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .frame(width: 56, height: 24)
                    }
                    
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
                            .overlay(alignment: .trailing){
                                VStack(alignment: .trailing, spacing : 0){
                                    Text("TUE 16")
                                    .mfont(11, .bold, line: 1)
                                      .multilineTextAlignment(.trailing)
                                      .foregroundColor(.white)
                                      .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                                    
                                    Text("10:09")
                                        .mfont(32, .regular, line: 1)
                                      .multilineTextAlignment(.trailing)
                                      .foregroundColor(.white)
                                      .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                                      .offset(y : -8)
                                    
                                    
                                }.padding(.trailing, 8)
                                    .padding(.bottom, 72)
                            }
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
                    if store.isPro(){
                        downloadImageToGallery(title: "Watch_\(wallpaper.id)", urlStr: wallpaper.path.first?.path.full ?? "")
                        ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpaper.id)
                    }else{
                        showBuySubAtScreen.toggle()
                    }
                  
                    
                    
                   
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
            
            if showBuySubAtScreen {
                SpecialSubView( onClickClose: {
                    showBuySubAtScreen = false
                })
                .environmentObject(store)
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .addBackground()
        .edgesIgnoringSafeArea(.bottom)
        .onAppear(perform: {
            if !store.isPro(){
                interAd.showAd {
                    
                }
            }
        })
        .fullScreenCover(isPresented: $showTuto, content: {
            WatchFaceTutorialView()
        })
        
     
       
    }
    
    func downloadImageToGallery(title : String, urlStr : String){
        ctrlViewModel.isDownloading = true
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url {
                DownloadFileHelper.saveImageToLibFromURLSanbox(url: url, onComplete: {
                    success in
                    if success{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                        if UserDefaults.standard.bool(forKey: "firsttime_showtuto_watchface") == false {
                            UserDefaults.standard.set(true, forKey: "firsttime_showtuto")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                showTuto.toggle()
                            })
                        }
                        
                     
                    }else{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
                    }
                })
            }
            else{
                ctrlViewModel.isDownloading = false
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
            }
        })
        
     
        
    }
}


