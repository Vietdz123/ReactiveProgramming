//
//  WLView.swift
//  WallpaperIOS
//
//  Created by Mac on 09/05/2023.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI
import GoogleMobileAds



enum DetailWallpaperAction : String, CaseIterable{
    case NONE = "detail_none"
    case LOCK = "detail_lock"
    case HOME = "detail_home"
}

class ControllViewModel : ObservableObject {
    @Published var showControll : Bool = true
    @Published var showPreview : Bool = false
    @Published var isHome : Bool = true
    @Published var showDetailWallpaper : Bool = false
   // @Published var showTutorial : Bool = false
    //@Published var showInfo : Bool = false
    @Published var showDialogRV : Bool = false
    @Published var showDialogBuyCoin : Bool = false
    @Published var navigateView : Bool = false
    @Published var isDownloading : Bool = false
    @Published var showContentPremium : Bool = false
    
    
    @Published var showGifView : Bool = false
    
    
    @Published var adStatus : AdStatus = .loading
    @Published var actionSelected : DetailWallpaperAction = .LOCK
    
    
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


struct WLView: View {
    @Environment(\.dismiss) var dismiss
    @State var index : Int
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @EnvironmentObject var viewModel : CommandViewModel
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var store : MyStore
 
    @EnvironmentObject var interAd : InterstitialAdLoader
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @AppStorage("exclusive_cost", store: .standard) var exclusiveCost : Int = 4
    
    
    var body: some View {
        
        
        ZStack{
            if !viewModel.wallpapers.isEmpty && index < viewModel.wallpapers.count{
                NavigationLink(isActive: $ctrlViewModel.navigateView, destination: {
                    EztSubcriptionView()
                        .environmentObject(store)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                }, label: {
                    EmptyView()
                })
                
                
                TabView(selection: $index, content: {
                    ForEach(0..<viewModel.wallpapers.count, id: \.self){ i in
                        let wallpaper = viewModel.wallpapers[i]
                        AsyncImage(url: URL(string: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))){
                            phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: getRect().width, height: getRect().height)
                                    .clipped()
                                
                            } else if phase.error != nil {
                                AsyncImage(url: URL(string: (wallpaper.variations.adapted.url).replacingOccurrences(of: "\"", with: ""))){
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        
                        .onAppear(perform: {
                            if i == (viewModel.wallpapers.count - 3){
                                viewModel.getWallpapers()
                            }
                            if !store.isPro(){
                                interAd.showAd(onCommit: {})
                            }
                            
                        })
                    }
                })
                .background(
                    Image("BGIMG")
                        .resizable()
                        .ignoresSafeArea()
                        
                )
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation{
                        ctrlViewModel.showControll.toggle()
                    }
                }
               
             
                    Preview()
              
               
                
                if ctrlViewModel.showControll{
                    ControllView()
                }
                
               
                
                if ctrlViewModel.showDialogRV{
                    DialogGetWL(urlStr: viewModel.wallpapers[index].variations.preview_small.url.replacingOccurrences(of: "\"", with: ""))
                }
                
                if ctrlViewModel.showDialogBuyCoin{
                    SpecialSubView(onClickClose: {
                        ctrlViewModel.showDialogBuyCoin = false
                    })
                    
                    
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .overlay(
            ZStack{
                if ctrlViewModel.showContentPremium {
                    let url  = (viewModel.wallpapers[index].variations.adapted.url).replacingOccurrences(of: "\"", with: "")
                        SpecialContentPremiumDialog(show: $ctrlViewModel.showContentPremium, urlStr: url, onClickBuyPro: {
                            ctrlViewModel.showContentPremium = false
                            ctrlViewModel.showDialogBuyCoin = true
                        })
                }
            }

        )
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
    func ControllView() -> some View{
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
                        if !store.isPro() && viewModel.wallpapers[index].content_type == "private" {
                            Button(action: {
                                ctrlViewModel.showContentPremium = true
                            }, label: {
                                Image("crown")
                                    .resizable()
                                    .frame(width: 18, height: 18, alignment: .center)
                                    .frame(width: 50, height: 44)
                            })
                           

                        }
                        
                    }

            }
            .frame(maxWidth: .infinity)
            .frame(height: 44  )
           
            
            Spacer()
         
            HStack(alignment: .bottom, spacing:  0, content: {
                
                VStack(spacing : 6){
                    ForEach(DetailWallpaperAction.allCases, id : \.rawValue){
                        action in
                        Image(action.rawValue)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .frame(width: 32, height: 44)
                            .opacity(ctrlViewModel.actionSelected == action ? 1.0 : 0.4)
                            .contentShape(Rectangle())
                            .onTapGesture(perform: {
                                ctrlViewModel.actionSelected = action
                            })
                    }
                    
                }
                .background(Color.black.opacity(0.4))
                .clipShape(Capsule())
                .padding(.leading, 16)
                
                Spacer()
                
                Button(action: {
                    
                    getPhotoPermission(status: {
                        b in
                        if b {
                            if store.isPro()  {
                                downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
                                ServerHelper.sendImageDataToServer(type: "set", id: viewModel.wallpapers[index].id)
                            }else{
                          
                                let wallpaper = viewModel.wallpapers[index]
                                if wallpaper.content_type == "free" {
                                    
                                    if  UserDefaults.standard.bool(forKey: "allow_download_free") == true {
                                        downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
                                        ServerHelper.sendImageDataToServer(type: "set", id: viewModel.wallpapers[index].id)
                                    }else{
                                        DispatchQueue.main.async {
                                            withAnimation{
                                                ctrlViewModel.showDialogRV.toggle()
                                            }
                                        }
                                    }
                                    
                                 
                                }else{
                                   
                                    
                                    DispatchQueue.main.async {
                                        withAnimation{
                                            ctrlViewModel.showDialogBuyCoin.toggle()
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                    })
                    
                }, label: {
                    Image("detail_download")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .frame(width: 56, height: 56)
                        .background(Circle().fill(Color.main))

                }).disabled(ctrlViewModel.isDownloading)
                    .padding(.trailing, 16)
            }).padding(.bottom, 24)
            
            ZStack{
                if store.allowShowBanner(){
                    BannerAdViewMain(adStatus: $ctrlViewModel.adStatus)
                }
            }.frame(height: GADAdSizeBanner.size.height)
            
               
                
                
           
            
        }
        
    }
    
    @ViewBuilder
    func Preview() -> some View{
    
        ZStack(alignment: .top){
            if ctrlViewModel.actionSelected == .HOME {
                
                VStack{
                    Image("home_sc")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 44)
                       
                    
                    Spacer()
                }
               

            }else if ctrlViewModel.actionSelected == .LOCK{
                VStack{
                    Image("lock_sc")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 28)
                    Spacer()
                }
                
                  
            }
        }
        
    }
    
    @ViewBuilder
    func DialogGetWL(urlStr : String) -> some View{
        WatchRVtoGetWLDialog( urlStr: urlStr, show: $ctrlViewModel.showDialogRV, onRewarded: {
            rewardSuccess in
            ctrlViewModel.showDialogRV = false
            if rewardSuccess {
                DispatchQueue.main.async{
                    downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].variations.adapted.url).replacingOccurrences(of: "\"", with: ""))
                    ServerHelper.sendImageDataToServer(type: "set", id: viewModel.wallpapers[index].id)
                }
            }else{
                DispatchQueue.main.async{
                    showToastWithContent(image: "xmark", color: .red, mess: "Ads is not ready!")
                }
            }
        }, clickBuyPro: {
            ctrlViewModel.showDialogRV.toggle()
            ctrlViewModel.navigateView.toggle()
        }).environmentObject(reward)
            .environmentObject(store)
    }

    
    
    func downloadImageToGallery(title : String, urlStr : String){
        
        DispatchQueue.main.async {
            ctrlViewModel.isDownloading = true
        }
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url{
                DownloadFileHelper.saveImageToLibFromURLSanbox(url: url, onComplete: {
                    success in
                    if success{
                        ctrlViewModel.isDownloading = false
                       
                       
                        
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
                        
                        DispatchQueue.main.async {
                            showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                        }

                    }else{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure")
                    }
                })
            }else{
                ctrlViewModel.isDownloading = false
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure")
            }
        })
        
        
        
    }
    

    
}



