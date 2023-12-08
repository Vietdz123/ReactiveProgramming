//
//  WLView.swift
//  WallpaperIOS
//
//  Created by Mac on 09/05/2023.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI


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
                    placeHolderImage()
                        .ignoresSafeArea()
                )
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation{
                        ctrlViewModel.showControll.toggle()
                    }
                }
                
                
                if ctrlViewModel.showControll{
                    ControllView()
                }
                
                if ctrlViewModel.showPreview {
                    Preview()
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
                    .frame(width: 240 ,height: 48)
                    .contentShape(Rectangle())
                    .background(
                        Capsule().fill(Color.main)
                    )
                })
                .padding(.bottom, 48)
                
                
//                Button(action: {
//                    withAnimation{
//                        ctrlViewModel.showControll = false
//                        ctrlViewModel.showPreview = true
//                    }
//                }, label: {
//                    Image("preview")
//                        .resizable()
//                        .foregroundColor(.white)
//                        .aspectRatio( contentMode: .fit)
//                        .frame(width: 24, height: 24)
//                        .frame(width: 48, height: 48)
//                        .background(
//                            Circle()
//                                .fill(Color.mblack_bg.opacity(0.7))
//                                .frame(width: 48, height: 48)
//                        )
//                }) .frame(width: 48, height: 48)
//                    .containerShape(Circle())
   //         }
           
           
            
        }
        
    }
    
    @ViewBuilder
    func Preview() -> some View{
        TabView(selection: $ctrlViewModel.isHome){
            
            Image("dynamic")
                .resizable()
                .scaledToFill()
            
                .onTapGesture {
                    withAnimation{
                        ctrlViewModel.showPreview = false
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        withAnimation{
                            ctrlViewModel.showControll = true
                        }
                    })
                }.tag(true)
            
            
            Image("preview_home")
                .resizable()
                .scaledToFill()
                .onTapGesture {
                    withAnimation{
                        ctrlViewModel.showPreview = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        withAnimation{
                            ctrlViewModel.showControll = true
                        }
                    })
                }.tag(false)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background{
            Color.clear
        }
        .ignoresSafeArea()
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
                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
 //                       if UserDefaults.standard.bool(forKey: "firsttime_showtuto") == false {
//                            UserDefaults.standard.set(true, forKey: "firsttime_showtuto")
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                                ctrlViewModel.showTutorial = true
//                            })
                            
//                        }
                        
                        let downloadCount = UserDefaults.standard.integer(forKey: "user_download_count")
                        UserDefaults.standard.set(downloadCount + 1, forKey: "user_download_count")
                        if !store.isPro() && downloadCount == 1 {
                            ctrlViewModel.navigateView.toggle()
                        }else{
                            showRateView()
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



