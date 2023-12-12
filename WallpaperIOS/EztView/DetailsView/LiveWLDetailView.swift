//
//  LiveWLView.swift
//  WallpaperIOS
//
//  Created by Mac on 07/06/2023.
//

import SwiftUI
import Photos
import PhotosUI
import AVKit

struct LiveWLView: View {
    let generator = UINotificationFeedbackGenerator()
    @EnvironmentObject var viewModel  : LiveWallpaperViewModel
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var inter : InterstitialAdLoader
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("current_coin", store: .standard) var currentCoin = 0
    //@AppStorage("first_time_video_wl", store: .standard) var firsttimeliveWL : Bool = true
    @State var firsttimeliveWL : Bool = false
    
    @State var currentIndex : Int = 0
    @StateObject var ctrlViewModel : VideoControllViewModel = .init()
    
    @AppStorage("remoteCf_live_using_coin", store: .standard) var remoteCf_live_using_coin : Bool = false
    
    
    
    var body: some View {
        GeometryReader{
            proxy in
            let size = proxy.size
            
            ZStack{
                NavigationLink(isActive: $ctrlViewModel.navigateView, destination: {
                    EztSubcriptionView()
                        .environmentObject(store)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                }, label: {
                    EmptyView()
                })
                
                if !viewModel.liveWallpapers.isEmpty{
                    TabView(selection: $currentIndex){
                        ForEach(0..<viewModel.liveWallpapers.count, id: \.self){
                            i in
                            let livewallpaper = viewModel.liveWallpapers[i]
                            ReelsPlayer( i: i, liveWL: livewallpaper, currentIndex: $currentIndex)
                                .frame(width: size.width)
                                .rotationEffect(.init(degrees: -90))
                                .ignoresSafeArea(.all)
                                .tag(i)
                                .onAppear(perform: {
                                    print("LIVE WL url :\(livewallpaper.video_variations.adapted.url)")
                                    
                                    generator.notificationOccurred(.success)
                                    
                                    if viewModel.shouldLoadData(id: i){
                                        viewModel.getDataByPage()
                                    }
                                    
                                    if !store.isPro(){
                                        inter.showAd(onCommit: {})
                                    }
                                })
                            
                            
                        }
                        
                    }
                    .rotationEffect(.init(degrees: 90))
                    .frame(width: size.height)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(width: size.width)
                    .background(Color.black)
                    .onTapGesture {
                        ctrlViewModel.showControll.toggle()
                    }
                    
                    if ctrlViewModel.showControll{
                        VStack(spacing : 0){
                            HStack(spacing : 0){
                                
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image("back")
                                        .resizable()
                                        .frame(width: 24, height: 24, alignment: .center)
                                        .frame(width: 64, height: 24)
                                        .foregroundColor(.white)
                                        .contentShape(Rectangle())
                                })
                                
                                Spacer()
                                
                                HStack(spacing : 0){
                                    //                                    ZStack{
                                    //                                        if !store.isPro() && viewModel.wallpapers[currentIndex].content_type == "private" {
                                    //                                            Button(action: {
                                    //                                                ctrlViewModel.showContentPremium = true
                                    //                                            }, label: {
                                    //                                                Image("crown")
                                    //                                                    .resizable()
                                    //                                                    .frame(width: 18, height: 18, alignment: .center)
                                    //                                                    .frame(width: 50, height: 44)
                                    //                                            })
                                    //
                                    //
                                    //                                        }
                                    //
                                    //                                    }
                                    //
                                    Button(action: {
                                        ctrlViewModel.showPreview.toggle()
                                        ctrlViewModel.showControll.toggle()
                                    }, label: {
                                        Image("preview")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                            .padding(.trailing, 16)
                                            .padding(.leading, 8)
                                    })
                                    
                                }
                                
                                
                                
                                
                                
                                
                            }.frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .padding(.top, getSafeArea().top)
                            Spacer()
                            
                            
                            
                            
                            
                            Button(action: {
                                
                                
                                
                                getPhotoPermission(status: {
                                    b in
                                    if b {
                                        if store.isPro()  {
                                            downloadVideoToGallery( title : "video\(  viewModel.liveWallpapers[currentIndex].id)" ,
                                                                    urlVideoStr:  viewModel.liveWallpapers[currentIndex].video_variations.adapted.url,
                                                                    urlImageStr: viewModel.liveWallpapers[currentIndex].image_variations.adapted.url.replacingOccurrences(of: "\"", with: ""))
                                            ServerHelper.sendVideoDataToServer(type: "set", id: viewModel.liveWallpapers[currentIndex].id)
                                            
                                            
                                        }else{
                                            
                                            if  UserDefaults.standard.bool(forKey: "allow_download_free") == true {
                                                downloadVideoToGallery( title : "video\(  viewModel.liveWallpapers[currentIndex].id)" ,
                                                                        urlVideoStr:  viewModel.liveWallpapers[currentIndex].video_variations.adapted.url,
                                                                        urlImageStr: viewModel.liveWallpapers[currentIndex].image_variations.adapted.url.replacingOccurrences(of: "\"", with: ""))
                                                ServerHelper.sendVideoDataToServer(type: "set", id: viewModel.liveWallpapers[currentIndex].id)
                                            }else{
                                                
                                                
                                                DispatchQueue.main.async {
                                                    withAnimation{
                                                        ctrlViewModel.showDialogDownload.toggle()
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                })
                                //
                                
                                
                                
                            }, label: {
                                HStack{
                                    
                                    
                                    Text("Save")
                                        .mfont(16, .bold)
                                        .foregroundColor(.mblack_fg)
                                        .overlay(
                                            ZStack{
                                                if ctrlViewModel.isDownloading{
                                                    EZProgressView()
                                                }
                                            }.offset(x : -36)
                                            , alignment: .leading
                                        )
                                }
                                
                                .frame(maxWidth: .infinity)
                                
                                .frame(width: 240 , height: 48)
                                .contentShape(Rectangle())
                                .background(
                                    Capsule().fill(Color.main)
                                )
                            }) .padding(.bottom, 48)
                            
                            
                            
                            
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        
                    }
                    
                    
                    if ctrlViewModel.showPreview{
                        TabView(selection: $ctrlViewModel.isHome){
                            
                            Image("lock_preview_hour")
                                .resizable()
                                .scaledToFill()
                            
                                .onTapGesture {
                                    withAnimation{
                                        ctrlViewModel.showPreview = false
                                        
                                        
                                    }
                                    
                                }.tag(true)
                            
                            
                            Image("preview_home")
                                .resizable()
                                .scaledToFill()
                                .onTapGesture {
                                    withAnimation{
                                        ctrlViewModel.showPreview = false
                                        
                                        
                                    }
                                    
                                }.tag(false)
                            
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .background{
                            Color.clear
                        }
                        .ignoresSafeArea()
                    }
                    
                    if firsttimeliveWL {
                        
                        ResizableLottieView(filename: "viewmore")
                            .frame(width: getRect().width - 60)
                            .onAppear(perform: {
                                ctrlViewModel.showControll = false
                                
                                
                            })
                            .onDisappear(perform: {
                                ctrlViewModel.showControll = true
                                
                            })
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded({ value in
                                    
                                    if value.translation.height < 0 {
                                        firsttimeliveWL = false
                                    }
                                    
                                    if value.translation.height > 0 {
                                        firsttimeliveWL = false
                                    }
                                }))
                        
                    }
                    
                    
                    
                }
            }
            .onAppear(perform: {
                let firstTime = UserDefaults.standard.bool(forKey: "first_time_video_wl")
                if !firstTime {
                    UserDefaults.standard.set(true, forKey:  "first_time_video_wl")
                    firsttimeliveWL = true
                }
            })
            
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        
        .sheet(isPresented: $ctrlViewModel.showTuto, content: {
            TutorialContentView()
            
        })
        .overlay{
            if ctrlViewModel.showDialogDownload{
                
                Dialog(liveWL: viewModel.liveWallpapers[currentIndex])
                
            }
            
        }
        .overlay{
            if ctrlViewModel.showGifView{
                GiftView()
            }
        }
        
        
        
        
    }
    
    @ViewBuilder
    func GiftView(giftSubType : Int = UserDefaults.standard.integer(forKey: "gift_sub_type")  ) -> some View{
        if giftSubType == 0 {
            GiftSub_1_View(show: $ctrlViewModel.showGifView)
        }else if giftSubType == 1{
            GiftSub_2_View(show: $ctrlViewModel.showGifView)
        }else{
            GifSub_3_View(show: $ctrlViewModel.showGifView)
        }
    }
    
    @ViewBuilder
    func Dialog(liveWL : LiveWallpaper) -> some View{
        
        if remoteCf_live_using_coin {
            
            SpecialSubView(onClickClose: {
                ctrlViewModel.showDialogDownload = false
            })
            
        }else{
            WatchRVtoGetWLDialog(urlStr: liveWL.image_variations.preview_small.url, show:  $ctrlViewModel.showDialogDownload, onRewarded: { b in
                if b{
                    ctrlViewModel.showDialogDownload.toggle()
                    downloadVideoToGallery( title : "video\(  viewModel.liveWallpapers[currentIndex].id)" ,
                                            urlVideoStr:  viewModel.liveWallpapers[currentIndex].video_variations.adapted.url,
                                            urlImageStr: viewModel.liveWallpapers[currentIndex].image_variations.adapted.url.replacingOccurrences(of: "\"", with: ""))
                    ServerHelper.sendVideoDataToServer(type: "set", id: viewModel.liveWallpapers[currentIndex].id)
                }else{
                    DispatchQueue.main.async {
                        showToastWithContent(image: "xmark", color: .red, mess: "Ads is not ready!")
                    }
                }
                
            }, clickBuyPro: {
                ctrlViewModel.showDialogDownload.toggle()
                ctrlViewModel.navigateView.toggle()
            }).environmentObject(store)
                .environmentObject(reward)
        }
        
        
        
        
    }
    
    
    func downloadVideoToGallery(title : String, urlVideoStr : String, urlImageStr : String){
        
        print("LIVE URL SERVER video ", urlVideoStr)
        print("LIVE URL SERVER image ", urlImageStr)
        
        DispatchQueue.main.async {
            ctrlViewModel.isDownloading = true
        }
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlImageStr), onCompleted: {
            urlImage in
            if let urlImage {
                print("LIVE URL IMAGE in Sanbox: ", urlImage.absoluteString)
                DownloadFileHelper.saveVideoLiveToLibSanbox(fileName: title, videoURL: URL(string: urlVideoStr), onCompleted: {
                    urlVideo in
                    if let urlVideo{
                        print("LIVE URL VIDEO in Sanbox: ", urlVideo.absoluteString)
                        
                        
                        
                        
                        LivePhoto.generate(from: urlImage, videoURL: urlVideo, progress: {
                            _ in
                        }, completion: {_,resources in
                            if let resources{
                                
                                print("LIVE RESOURCE video : \(resources.pairedVideo.absoluteString)")
                                print("LIVE RESOURCE image : \(resources.pairedImage.absoluteString)")
                                
                                LivePhoto.saveToLibrary(resources, completion: {
                                    b in
                                    if b{
                                        DispatchQueue.main.async {
                                            ctrlViewModel.isDownloading = false
                                            showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                                            
                                            //                                                                    if UserDefaults.standard.bool(forKey: "firsttime_showtuto") == false {
                                            //                                                                        UserDefaults.standard.set(true, forKey: "firsttime_showtuto")
                                            //                                                                        ctrlViewModel.showTuto = true
                                            //                                                                    }
                                            
                                            let downloadCount = UserDefaults.standard.integer(forKey: "user_download_count")
                                            UserDefaults.standard.set(downloadCount + 1, forKey: "user_download_count")
                                            
                                            if downloadCount == 1 {
                                                showRateView()
                                            }else{
                                                if !store.isPro()  {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                                        ctrlViewModel.showGifView.toggle()
                                                        ctrlViewModel.changeSubType()
                                                    })
                                                }
                                            }
                                            
                                            
                                        }
                                    }else{
                                        DispatchQueue.main.async {
                                            ctrlViewModel.isDownloading = false
                                            showToastWithContent(image: "xmark", color: .red, mess:"Download Failure")
                                        }
                                    }
                                })
                            }else{
                                DispatchQueue.main.async {
                                    ctrlViewModel.isDownloading = false
                                    showToastWithContent(image: "xmark", color: .red, mess:"Download Failure")
                                }
                            }
                            
                        })
                        
                    }else{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess:"Download Failure")
                    }
                })
            }else{
                ctrlViewModel.isDownloading = true
                showToastWithContent(image: "xmark", color: .red, mess:"Download Failure")
            }
        })
    }
    
}
