//
//  ShuffleDetailView.swift
//  WallpaperIOS
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI
import GoogleMobileAds

struct ShuffleDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var store : MyStore = .shared

    @State var currentIndex  = 0
    @State var showMore : Bool = false
    let wallpaper : SpWallpaper
    
    @State var showBuySubAtScreen : Bool = false
    @State var isBuySubWeek : Bool = true
    @State var isDownloading : Bool = false
    
    @State var showContentPremium : Bool = false
    @State var showSub : Bool = false
    @State var showTuto : Bool = false
    @State var showDialogRv : Bool = false
    @State var adStatus : AdStatus = .loading
    
    
    @State var showRateView : Bool = false
    @State var showGifView : Bool = false
    
    
    @State var type : String = "ShufflePack"
    @State var urlForDownloadSuccess :  [URL] = []
    @State var navigateToDownloadSuccessView : Bool = false
    
    var body: some View {
        
        ZStack{
            NavigationLink(
                destination:
                        TutorialShuffleView()
                    ,
                isActive: $showTuto,
                label: {
                    EmptyView()
                })
            
            NavigationLink(isActive: $navigateToDownloadSuccessView, destination: {
                DownloadSuccessView(type: type, url: nil, wallpaper: wallpaper, onClickBackToHome: {
                    navigateToDownloadSuccessView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        dismiss.callAsFunction()
                    })
                   
                }).environmentObject(store)
            }, label: {
                EmptyView()
            })
        
     
                TabView(selection: $currentIndex){
                    ForEach(0..<wallpaper.path.count, id: \.self) {
                        i in
                        let imgStr = wallpaper.path[i].path.preview
                        
                        AsyncImage(url: URL(string: imgStr)){
                            phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: getRect().width, height: getRect().height)
                                    .clipped()

                            } else if phase.error != nil {
                                AsyncImage(url: URL(string: imgStr)){
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
                           .frame(maxWidth : .infinity, maxHeight: .infinity)
                           .ignoresSafeArea()
                          
                        
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                VStack(spacing : 0){
                    Image("lock_preview_shuff")
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()
                }
            
            
            
          
            
            VStack(spacing: 0){
                ControllView()
            }
//            
//            if showBuySubAtScreen {
//             
//               SpecialSubView(onClickClose: {
//                   showBuySubAtScreen = false
//               })
//                    .environmentObject(store)
//                    
//            }
            
            
            if showDialogRv {
                let url  = wallpaper.path.first?.path.small ?? wallpaper.path.first?.path.preview ?? ""
                    WatchRVtoGetWLDialog( urlStr: url, show: $showDialogRv ,onRewarded: {
                        b in
                        showDialogRv = false
                        if b {
                            createAlbum(albumName: "Shuffle \(wallpaper.id)")
                            ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpaper.id)
                        }else{
                            showToastWithContent(image: "xmark", color: .red, mess: "Ads not alaivable!")
                        }
                        
                    }, clickBuyPro: {
                        showDialogRv = false
                        showSub.toggle()
                    })
                
            }
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .addBackground()
            .overlay(
                ZStack{
                    if showContentPremium {
                        let url  = wallpaper.path.first?.path.small ?? wallpaper.path.first?.path.preview ?? ""
                            SpecialContentPremiumDialog(show: $showContentPremium, urlStr: url, onClickBuyPro: {
                                showContentPremium = false
                                showSub.toggle()
                            })
                    }
                }
                
            )
            .overlay{
                if showGifView{
                    GiftView()
                }
            }
            .overlay{
                if showRateView {
                    EztRateView(onClickSubmit5star: {
                        showRateView = false
                        rateApp()
                    }, onClickNoThanksOrlessthan5: {
                        showRateView = false
                    })
                }
            }
            .fullScreenCover(isPresented: $showSub, content: {
                EztSubcriptionView()
                    .environmentObject(store)
            })
          
            .onAppear(perform: {
                if !store.isPro(){
                    InterstitialAdLoader.shared.showAd {
                        
                    }
                }
            })
           
    }
    

    
    
    
    
    
}

extension ShuffleDetailView{
    
 
    @ViewBuilder
    func GiftView(giftSubType : Int = UserDefaults.standard.integer(forKey: "gift_sub_type")  ) -> some View{
        if giftSubType == 0 {
           GiftSub_1_View(show: $showGifView)
        }else if giftSubType == 1{
            GiftSub_2_View(show: $showGifView)
        }else{
            GifSub_3_View(show: $showGifView)
        }
    }
    
    @ViewBuilder
    func ControllView() -> some View {
        VStack(spacing : 0){
            HStack(spacing : 0){
                Button(action: {
                    dismiss.callAsFunction()
                }, label: {
                    Image("back")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .frame(width: 64, height: 44)
                        .contentShape(Rectangle())
                })
                
                
                Spacer()
                ZStack{
                   
                    if !store.isPro() && wallpaper.contentType == 1 {
                        Button(action: {
                            showContentPremium.toggle()
                        }, label: {
                            Image("crown")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                                .frame(width: 60, height: 44)
                        })
                        
                    }
                }
                .frame(width: 60, height: 44)
              
          
            
                
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44  )
            
            Spacer()
            
            Button(action: {
                getPhotoPermissionForCreateAlbum(status: {
                    b in
                    if b {
                        if store.isPro() {
                            createAlbum(albumName: "Shuffle \(wallpaper.id)")
                            ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpaper.id)
                        }else{
                        
                                DispatchQueue.main.async {
                                    withAnimation(.easeInOut){
                                        if wallpaper.contentType == 1 {
                                      //      showBuySubAtScreen.toggle()
                                            showSub.toggle()
                                        }else{
                                            showDialogRv.toggle()
                                        }
                                        
                                        
                                      
                                    }
                                }
                               
                        
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            showToastWithContent(image: "xmark", color: .red, mess: "No permissions to create photo albums!")
                        }
                    }
                })
               
            }, label: {
                Image("detail_download")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .frame(width: 56, height: 56)
                    .background(Color.main)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                

            })
            
            ZStack{
                HStack(spacing : 8){
                    ForEach(0..<wallpaper.path.count, id: \.self, content: {
                        i in
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 8, height: 8)
                            .overlay(
                                ZStack{
                                    if i == currentIndex {
                                        Circle()
                                            .foregroundColor(.white)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                            )
                    })
                }
            }.frame(height: 36)
              
            
            ZStack{
                if store.allowShowBanner(){
                    BannerAdViewMain(adStatus: $adStatus)
                }
            }.frame(height: GADAdSizeBanner.size.height)
            
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func createAlbum(albumName: String) {
        
        DispatchQueue.main.async {
            isDownloading = true
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    
                    if let albumn = getAlbum() {
                        wallpaper.path.forEach({
                            path in
                            downloadImageToGallery(title: path.fileName, urlStr: path.path.full, album: albumn)
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            showToastWithContent(image: "checkmark", color: .green, mess: "Successful")
                            isDownloading = false
                          
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                self.navigateToDownloadSuccessView = true
                            })
                            

                            
                        }
                    }else{
                        isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Error, can't create Albumn")
                    }
                    
                    
                  
                } else {
                    isDownloading = false
                    showToastWithContent(image: "xmark", color: .red, mess: "Error, can't create Albumn")
                }
            }
           
        }
    }

    func downloadImageToGallery(title : String, urlStr : String, album : PHAssetCollection){
      
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            urlImage in
            if let urlImage {
                PHPhotoLibrary.shared().performChanges({
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: UIImage(contentsOfFile: urlImage.path )!)
                                let placeholder = request.placeholderForCreatedAsset
                                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                                let enumeration: NSArray = [placeholder!]
                                albumChangeRequest!.addAssets(enumeration)
                                
                }) { _, _ in
                    
                }

            }
        })
        
        
      
    }

    func getAlbum() -> PHAssetCollection? {
        let albumTitle = "Shuffle \(wallpaper.id)"
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumTitle)
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let album = fetchResult.firstObject {
            return album
        }else{
            return nil
        }
    }
    

    
    func changeSubType() {

        
        let subTypeSave =  UserDefaults.standard.integer(forKey: "gift_sub_type")
      
        
        if subTypeSave == 0 {
                UserDefaults.standard.set(1, forKey: "gift_sub_type")
        }else if subTypeSave == 1 {
                UserDefaults.standard.set(2, forKey: "gift_sub_type")
        }else if subTypeSave == 2{
                UserDefaults.standard.set(0, forKey: "gift_sub_type")
        }
        
       
    }
    
}
