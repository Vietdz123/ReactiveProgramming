//
//  LockThemeDetailView.swift
//  WallpaperIOS
//
//  Created by Duc on 07/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import GoogleMobileAds
import Lottie

struct LockThemeDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var index : Int
    
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @StateObject var viewModel : LockThemeViewModel
    @StateObject var store = MyStore.shared
    @State var showBuySubAtScreen : Bool = false
    @State var isBuySubWeek : Bool = true
    @State var showMore : Bool = false
    @State var showContentPremium : Bool = false
    @State var showSub : Bool = false
    @State var showDialogRv : Bool = false
    @State var showTuto : Bool = false
    @State var showDownloadView : Bool = false
    
    
    @State var type : String = "LockScreenTheme"
    @State var urlForDownloadSuccess :  URL?
    @State var navigateToDownloadSuccessView : Bool = false
    
    var body: some View {
        ZStack{
            
            if !viewModel.wallpapers.isEmpty && index < viewModel.wallpapers.count{
                NavigationLink(isActive: $ctrlViewModel.navigateView, destination: {
                    EztSubcriptionView()
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                    
                }, label: {
                    EmptyView()
                })
                
                
                NavigationLink(isActive: $navigateToDownloadSuccessView, destination: {
                    DownloadSuccessView(type: type, url: urlForDownloadSuccess, onClickBackToHome: {
                        navigateToDownloadSuccessView = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            dismiss.callAsFunction()
                        })
                        
                    })
                }, label: {
                    EmptyView()
                })
                
                
                TabView(selection: $index, content: {
                    ForEach(0..<viewModel.wallpapers.count, id: \.self){ i in
                        let wallpaper = viewModel.wallpapers[i]
                        let urlStr = wallpaper.thumbnail.first?.url.full ?? ""
                        ZStack{
                            if  urlStr.contains(".json"){
                                if let url = URL(string: urlStr){
                                    
                                    LottieView {
                                        await LottieAnimation.loadedFrom(url:  url )
                                    } .looping()
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: getRect().width, height: getRect().height)
                                    
                                    
                                }
                                
                            }else{
                                AsyncImage(url: URL(string:  urlStr  )){
                                    phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: getRect().width, height: getRect().height)
                                            .clipped()
                                        
                                        
                                    } else if phase.error != nil {
                                        AsyncImage(url: URL(string: urlStr )){
                                            phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: getRect().width, height: getRect().height)
                                                    .clipped()
                                            }
                                        }
                                        
                                    } else {
                                        ResizableLottieView(filename: "placeholder_anim")
                                            .frame(width: 200, height: 200)
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                        
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear(perform: {
                            if i == (viewModel.wallpapers.count - 3){
                                viewModel.getWallpapers()
                            }
                            
                        })
                    }
                })
                .background(
                    placeHolderImage()
                        .ignoresSafeArea()
                )
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    ctrlViewModel.showControll.toggle()
                })
                
                if ctrlViewModel.showControll{
                    ControllView()
                }
                
                
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .overlay(
            ZStack{
                if showContentPremium {
                    let url  = viewModel.wallpapers[index].thumbnail.first?.url.preview ?? ""
                    SpecialContentPremiumDialog(show: $showContentPremium, urlStr: url, onClickBuyPro: {
                        showContentPremium = false
                        showSub.toggle()
                    })
                }
            }
            
        )
        
        .overlay{
            if ctrlViewModel.showRateView {
                EztRateView(onClickSubmit5star: {
                    ctrlViewModel.showRateView = false
                    rateApp()
                }, onClickNoThanksOrlessthan5: {
                    ctrlViewModel.showRateView = false
                })
            }
        }
        .fullScreenCover(isPresented: $showBuySubAtScreen, content: {
            EztSubcriptionView()
            
        })
        .fullScreenCover(isPresented: $showSub, content: {
            EztSubcriptionView()
            
        })
        
    }
}

extension LockThemeDetailView{
    
    
    
    
    //  @State var indexGif : Int = 0
    func ThemeDownloadView() -> some View{
        
        VStack(spacing : 0){
            let wallpaper = viewModel.wallpapers[index]
            let content = wallpaper.content
            let wallpaperContent : LockContent? = findObjectByName(list: content, nameType1: "wallpaper", nameType2: "wallpaperrrr")
            let inlineContent : LockContent? = findObjectByName(list: content, nameType1: "inline", nameType2: "inline222")
            let rectangleContent : LockContent? = findObjectByName(list: content, nameType1: "rectangle_image", nameType2: "rectangle_gif")
            let square_1_Content : LockContent? = findObjectByName(list: content, nameType1: "square_1_image", nameType2: "square_1_gif")
            let square_2_Content : LockContent? = findObjectByName(list: content, nameType1: "square_2_image", nameType2: "square_2_gif")
            let isContentGif = (rectangleContent?.type ?? "").contains("gif")
            let delayAnimation : Double = Double(rectangleContent?.data?.delayAnimation ?? Int(1000.0) ) / 1000.0
            let listRectangle : [String] = ( rectangleContent?.data?.images ?? [] ).map{
                $0.url.full
            }
            let listSquare1 : [String] = ( square_1_Content?.data?.images ?? [] ).map{
                $0.url.full
            }
            let listSquare2 : [String] = ( square_2_Content?.data?.images ?? [] ).map{
                $0.url.full
            }
            
            
            
            
            HStack(spacing : 0){
                ZStack{
                    if !store.isPro() && wallpaper.private == 1 {
                        Image("crown")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    
                }  .frame(width: 20, height: 20)
                
                Spacer()
                Text("Theme Item")
                    .mfont(17, .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    showDownloadView = false
                }, label: {
                    Image("close.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                })
                
            }.padding(.horizontal, 16)
                .padding(.top, 20)
            HStack(spacing : 0){
                Text("Wallpaper")
                    .mfont(17, .bold)
                    .foregroundColor(.white)
                Spacer()
                
                
                Button(action: {
                    getPhotoPermission(status: {
                        b in
                        if b {
                            
                            
                            if store.isPro(){
                                if let wallpaperContent{
                                    downloadImageToGallery(title: "lockcreenwallpaper_\(wallpaper.id)", urlStr: wallpaperContent.data?.images?.first?.url.full ?? "")
                                    ServerHelper.sendLockScreenThemeDataToServer(id: wallpaper.id)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                        showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                            ctrlViewModel.showRateView = true
                                        }, onShowGifView: {
                                            ctrlViewModel.showGifView.toggle()
                                            ctrlViewModel.changeSubType()
                                        })
                                    })
                                }
                                
                                
                                
                                
                            }else{
                                if wallpaper.private == 1 {
                                    showBuySubAtScreen.toggle()
                                    
                                } else {
                                    
                                    RewardAd.shared.presentRewardedVideo(onCommit: {
                                        _ in
                                        if let wallpaperContent{
                                            downloadImageToGallery(title: "lockcreenwallpaper_\(wallpaper.id)", urlStr: wallpaperContent.data?.images?.first?.url.full ?? "")
                                            ServerHelper.sendLockScreenThemeDataToServer(id: wallpaper.id)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                                showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                                    ctrlViewModel.showRateView = true
                                                }, onShowGifView: {
                                                    ctrlViewModel.showGifView.toggle()
                                                    ctrlViewModel.changeSubType()
                                                })
                                            })
                                        }
                                        
                                        
                                        
                                    })
                                    
                                }
                            }
                            
                            
                        }
                    })
                    
                    
                }, label: {
                    VStack(spacing : -4){
                        Text("Save")
                            .mfont(16, .bold)
                            .multilineTextAlignment(.center)
                        if !store.isPro() && wallpaper.private == 0 {
                            HStack(spacing : 4){
                                Text("Watch an ad")
                                    .mfont(10, .regular)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                Image("ad")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                            }
                        }
                        
                    }
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .frame(width: 120, height: 36)
                    .background(Color(red: 1, green: 0.87, blue: 0.19))
                    .clipShape(Capsule())
                })
                
                
                
                
            }.frame(height: 32)
                .padding(.horizontal, 16)
                .padding(.top, 36)
            
            HStack(spacing : 0){
                Text("LockScreen Inline")
                    .mfont(17, .bold)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    
                    if store.isPro(){
                        if let inlineContent {
                            downloadContentInline(inlineContent: inlineContent)
                            ServerHelper.sendLockScreenThemeDataToServer(id: wallpaper.id)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                    ctrlViewModel.showRateView = true
                                }, onShowGifView: {
                                    ctrlViewModel.showGifView.toggle()
                                    ctrlViewModel.changeSubType()
                                })
                            })
                        }
                        
                        
                        
                        
                    }else{
                        if wallpaper.private == 1 {
                            showBuySubAtScreen.toggle()
                        }else{
                            
                            RewardAd.shared.presentRewardedVideo(onCommit: {
                                _ in
                                if let inlineContent {
                                    downloadContentInline(inlineContent: inlineContent)
                                    ServerHelper.sendLockScreenThemeDataToServer(id: wallpaper.id)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                        showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                            ctrlViewModel.showRateView = true
                                        }, onShowGifView: {
                                            ctrlViewModel.showGifView.toggle()
                                            ctrlViewModel.changeSubType()
                                        })
                                    })
                                }
                                
                                
                                
                            })
                            
                        }
                    }
                    
                    
                    
                    
                    
                }, label: {
                    VStack(spacing : -4){
                        Text("Save")
                            .mfont(16, .bold)
                            .multilineTextAlignment(.center)
                        if !store.isPro() && wallpaper.private == 0 {
                            HStack(spacing : 4){
                                Text("Watch an ad")
                                    .mfont(10, .regular)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                Image("ad")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                            }
                        }
                        
                    }
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .frame(width: 120, height: 36)
                    .background(Color(red: 1, green: 0.87, blue: 0.19))
                    .clipShape(Capsule())
                })
                
                
                
                
            }.frame(height: 32)
                .padding(.horizontal, 16)
                .padding(.top, 32)
            
            
            ZStack{
                if let inlineContent {
                    Image("lockcreen_time")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .overlay(alignment: .top, content: {
                            HStack(spacing : 5){
                                Text(Date().toString(format: "EEE dd"))
                                    .mfont(17, .regular)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                                Text(inlineContent.data?.contentInline ?? "")
                                    .foregroundColor(.white)
                            }
                            
                            .padding(.top, 16)
                        })
                }
                
            }.frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            if let square_1_Content ,
               let square_2_Content ,
               let rectangleContent
            {
                
                
                HStack(spacing : 0){
                    Text("LockScreen Widget")
                        .mfont(17, .bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        
                        if store.isPro(){
                            downloadContentWidget(square_1_Content: square_1_Content, square_2_Content: square_2_Content, rectangleContent: rectangleContent)
                            ServerHelper.sendLockScreenThemeDataToServer(id: wallpaper.id)
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                    ctrlViewModel.showRateView = true
                                }, onShowGifView: {
                                    ctrlViewModel.showGifView.toggle()
                                    ctrlViewModel.changeSubType()
                                })
                            })
                            
                            
                        }else{
                            if wallpaper.private == 1 {
                                showBuySubAtScreen.toggle()
                            }else{
                                
                                RewardAd.shared.presentRewardedVideo(onCommit: {
                                    _ in
                                    downloadContentWidget(square_1_Content: square_1_Content, square_2_Content: square_2_Content, rectangleContent: rectangleContent)
                                    ServerHelper.sendLockScreenThemeDataToServer(id: wallpaper.id)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                        showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                            ctrlViewModel.showRateView = true
                                        }, onShowGifView: {
                                            ctrlViewModel.showGifView.toggle()
                                            ctrlViewModel.changeSubType()
                                        })
                                    })
                                    
                                })
                                
                            }
                        }
                        
                        
                    }, label: {
                        VStack(spacing : -4){
                            Text("Save")
                                .mfont(16, .bold)
                                .multilineTextAlignment(.center)
                            if !store.isPro() && wallpaper.private == 0 {
                                HStack(spacing : 4){
                                    Text("Watch an ad")
                                        .mfont(10, .regular)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    Image("ad")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 10)
                                }
                            }
                            
                        }.foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .frame(width: 120, height: 36)
                            .background(Color(red: 1, green: 0.87, blue: 0.19))
                            .clipShape(Capsule())
                    })
                    
                    
                    
                    
                }.frame(height: 32)
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                if !listRectangle.isEmpty && !listSquare1.isEmpty && !listSquare2.isEmpty{
                    
                    HorizotalGifWidgetView(listRectangle: listRectangle, listSquare1: listSquare1, listSquare2: listSquare2, isContentGif: isContentGif, delayAnimation: delayAnimation, indexGifRectangle: 0, indexGifSquare1: 0, indexGifSquare2: 0)
                    
                    
                }
            }
            
            Button(action: {
                getPhotoPermission(status: {
                    b in
                    if b {
                        if store.isPro(){
                            if let wallpaperContent{
                                downloadImageToGallery(title: "lockcreenwallpaper_\(wallpaper.id)", urlStr: wallpaperContent.data?.images?.first?.url.full ?? "")
                            }
                            if let inlineContent{
                                downloadContentInline(inlineContent: inlineContent)
                            }
                            if let square_1_Content,
                               let square_2_Content,
                               let rectangleContent
                            {
                                downloadContentWidget(square_1_Content: square_1_Content, square_2_Content: square_2_Content, rectangleContent: rectangleContent)
                            }
                            
                            
                            ServerHelper.sendLockScreenThemeDataToServer(id: wallpaper.id)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                    ctrlViewModel.showRateView = true
                                }, onShowGifView: {
                                    ctrlViewModel.showGifView.toggle()
                                    ctrlViewModel.changeSubType()
                                })
                            })
                            
                            
                        }else{
                            if wallpaper.private == 1 {
                                showBuySubAtScreen.toggle()
                            }else{
                                
                                RewardAd.shared.presentRewardedVideo(onCommit: {
                                    _ in
                                    if let wallpaperContent{
                                        downloadImageToGallery(title: "lockcreenwallpaper_\(wallpaper.id)", urlStr: wallpaperContent.data?.images?.first?.url.full ?? "")
                                    }
                                    if let inlineContent{
                                        downloadContentInline(inlineContent: inlineContent)
                                    }
                                    if let square_1_Content,
                                       let square_2_Content,
                                       let rectangleContent
                                    {
                                        downloadContentWidget(square_1_Content: square_1_Content, square_2_Content: square_2_Content, rectangleContent: rectangleContent)
                                    }
                                    
                                    
                                    ServerHelper.sendLockScreenThemeDataToServer(id: wallpaper.id)
                                    
                                    
                                    //MARK: ALL
                                    //                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                    //                                                    showActionAfterDownload(isUserPro: store.isPro(), onShowRate: {
                                    //                                                        ctrlViewModel.showRateView = true
                                    //                                                    }, onShowGifView: {
                                    //                                                        ctrlViewModel.showGifView.toggle()
                                    //                                                        ctrlViewModel.changeSubType()
                                    //                                                    })
                                    //                                                })
                                    
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        let urlPreview = wallpaper.thumbnail.first?.url.full ?? ""
                                        self.urlForDownloadSuccess = URL(string: urlPreview)
                                        self.navigateToDownloadSuccessView = true
                                    })
                                    
                                    
                                })
                                
                                
                            }
                        }
                    }
                })
            }, label: {
                VStack(spacing : -2){
                    Text("Save")
                        .mfont(16, .bold)
                        .multilineTextAlignment(.center)
                    if !store.isPro() && wallpaper.private == 0 {
                        HStack(spacing : 4){
                            Text("Watch an ad")
                                .mfont(11, .regular)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                            Image("ad")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                        }
                    }
                    
                }
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(maxWidth: .infinity)
                .frame( height: 48)
                .background(Color(red: 1, green: 0.87, blue: 0.19))
                .clipShape(Capsule())
                .padding(.horizontal, 67)
                .padding(.top, 40)
                .padding(.bottom, 24)
            })
            
            
            
            
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(red: 0.13, green: 0.14, blue: 0.13).opacity(0.7)
                .cornerRadius(20)
                .edgesIgnoringSafeArea(.bottom)
        )
        
        
        
    }
    
    func downloadContentInline(inlineContent : LockContent) {
        CoreDataService.shared.downloadInlineCoreData(inline: inlineContent) {
            DispatchQueue.main.async(execute: {
                showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
            })
        }
    }
    
    func downloadContentWidget(square_1_Content: LockContent, square_2_Content : LockContent, rectangleContent : LockContent ){
        if square_1_Content.type == "square_1_gif" {
            ///download gif
            CoreDataService.shared.downloadGifCoreData(idTheme: viewModel.wallpapers[self.index].id, lockModel: square_1_Content, index: 1, familyLock: .square) {
                DispatchQueue.main.async(execute: {
                    showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                })
            }
            
        } else {
            ///download icon
            CoreDataService.shared.downloadIconCoreData(idTheme: viewModel.wallpapers[self.index].id,iconModel: square_1_Content, index: 1, familyLock: .square) {
                DispatchQueue.main.async(execute: {
                    showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                })
            }
        }
        
        
        if square_2_Content.type == "square_2_gif" {
            ///download gif
            CoreDataService.shared.downloadGifCoreData(idTheme: viewModel.wallpapers[self.index].id,lockModel: square_2_Content, index: 2, familyLock: .square) {
                DispatchQueue.main.async(execute: {
                    showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                })
            }
            
        } else {
            ///download icon
            CoreDataService.shared.downloadIconCoreData(idTheme: viewModel.wallpapers[self.index].id,iconModel: square_2_Content, index: 2, familyLock: .square) {
                DispatchQueue.main.async(execute: {
                    showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                })
            }
        }
        
        if rectangleContent.type == "rectangle_gif"  {
            ///download gif
            CoreDataService.shared.downloadGifCoreData(idTheme: viewModel.wallpapers[self.index].id,lockModel: rectangleContent, index: -2, familyLock: .rectangle) {
                DispatchQueue.main.async(execute: {
                    showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                })
            }
            
        } else {
            ///download icon
            CoreDataService.shared.downloadIconCoreData(idTheme: viewModel.wallpapers[self.index].id, iconModel: rectangleContent, index: -1, familyLock: .rectangle) {
                DispatchQueue.main.async(execute: {
                    showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                })
            }
        }
    }
    
    
    
}


