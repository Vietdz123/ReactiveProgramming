//
//  SpWLDetailView.swift
//  WallpaperIOS
//
//  Created by Mac on 09/08/2023.
//

import SwiftUI
import PhotosUI
import Photos
import GoogleMobileAds
import SDWebImageSwiftUI

struct SpWLDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var index : Int
    @StateObject var viewModel : SpViewModel
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    
    @StateObject var store = MyStore.shared
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @AppStorage("exclusive_cost", store: .standard) var exclusiveCost : Int = 4
    
    @State var showBuySubAtScreen : Bool = false
    @State var isBuySubWeek : Bool = true
    @State var showMore : Bool = false
    @State var showContentPremium : Bool = false
    @State var showSub : Bool = false
    @State var showDialogRv : Bool = false
    @State var showTuto : Bool = false
    
    @State var type : String = "Wallpaper"
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
                        let urlStr = wallpaper.specialContentV2ID == 6 ? wallpaper.thumbnail?.path.full : wallpaper.path.first?.path.preview
                        AsyncImage(url: URL(string:  urlStr ?? "")){ phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: getRect().width, height: getRect().height)
                                    .opacity((wallpaper.specialContentV2ID == 2 && ctrlViewModel.actionSelected == .LOCK) ? 0.0 : 1.0)
                                    .clipped()
                                    .overlay{
                                        if ctrlViewModel.actionSelected == .LOCK && viewModel.wallpapers[index].specialContentV2ID == 2 {
                                            AsyncImage(url: URL(string:  viewModel.wallpapers[index].thumbnail?.path.preview ?? ""  )){
                                                phase in
                                                if let image = phase.image {
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: getRect().width, height: getRect().height)
                                                        .clipped()
                                                    
                                                } else if phase.error != nil {
                                                    AsyncImage(url: URL(string: viewModel.wallpapers[index].thumbnail?.path.preview ?? "")){
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
                                
                            } else if phase.error != nil {
                                AsyncImage(url: URL(string: urlStr ?? "")){
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
                
                
                Preview()
                
                if ctrlViewModel.showControll{
                    ControllView()
                }

                if showDialogRv {
                    let url  = viewModel.wallpapers[index].path.first?.path.small ?? viewModel.wallpapers[index].path.first?.path.preview ?? ""
                    WatchRVtoGetWLDialog( urlStr: url, show: $showDialogRv ,onRewarded: {
                        b in
                        showDialogRv = false
                        if b {
                            downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].path.first?.path.full ?? ""))
                        }else{
                            showToastWithContent(image: "xmark", color: .red, mess: "Ads not alaivable!")
                        }
                        
                    }, clickBuyPro: {
                        showDialogRv = false
                        showSub.toggle()
                    })
                    
                }
                
                
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .overlay(
            ZStack{
                if showContentPremium {
                    let url  = viewModel.wallpapers[index].path.first?.path.small ?? viewModel.wallpapers[index].path.first?.path.preview ?? ""
                    SpecialContentPremiumDialog(show: $showContentPremium, urlStr: url, onClickBuyPro: {
                        showContentPremium = false
                        showSub.toggle()
                    })
                }
            }
            
        )
        .fullScreenCover(isPresented: $showBuySubAtScreen, content: {
            EztSubcriptionView()
                .environmentObject(store)
        })
        .fullScreenCover(isPresented: $showSub, content: {
            EztSubcriptionView()
                .environmentObject(store)
        })
        
    }
    
    
}


extension SpWLDetailView{
        
    @ViewBuilder
    func Preview() -> some View{
        
        ZStack(alignment: .top){
            if ctrlViewModel.actionSelected == .HOME {
                VStack(spacing : 0){
                    Image("home_sc")
                        .resizable()
                        .scaledToFit()
                        .opacity( viewModel.wallpapers[index].specialContentV2ID == 6 ? 0 : 1.0)
                        .padding(.top, 44)
                    Spacer()
                }
                
            } else if ctrlViewModel.actionSelected == .LOCK{
                VStack(spacing : 0){
                    Image("lock_sc")
                        .resizable()
                        .scaledToFit()
                        .opacity(viewModel.wallpapers[index].specialContentV2ID == 2 || viewModel.wallpapers[index].specialContentV2ID == 6 ? 0 : 1.0)
                        .padding(.top, 28)
                    Spacer()
                }
            }
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

                ZStack {
                    if !store.isPro() && viewModel.wallpapers[index].contentType == 1 {
                        Button(action: {
                            showContentPremium.toggle()
                        }, label: {
                            Image("crown")
                                .resizable()
                                .scaledToFit()
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
            
            ZStack{
                if viewModel.wallpapers[index].specialContentV2ID == 6 {
                    VStack(spacing : 0){
                        Spacer()
                        Button(action: {
                            getPhotoPermission(status: { b in
                                if b {
                                    if store.isPro(){
                                        downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].path.first?.path.full ?? ""))
                                        ServerHelper.sendImageSpecialDataToServer(type: "download", id: viewModel.wallpapers[index].id)
                                        
                                    } else {
                                        DispatchQueue.main.async {
                                            withAnimation(.easeInOut){
                                                if viewModel.wallpapers[index].contentType == 1 {
                                                    showBuySubAtScreen.toggle()
                                                    
                                                } else {
                                                    showDialogRv.toggle()
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
                        })
                        .padding(.bottom, 64)
                    }
                    
                } else {
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
                            getPhotoPermission(status: { b in
                                if b {
                                    if store.isPro(){
                                        downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].path.first?.path.full ?? ""))
                                        ServerHelper.sendImageSpecialDataToServer(type: "download", id: viewModel.wallpapers[index].id)
                                    }else{
                                        DispatchQueue.main.async {
                                            withAnimation(.easeInOut){
                                                if viewModel.wallpapers[index].contentType == 1 {
                                                    //     showBuySubAtScreen.toggle()
                                                    showSub.toggle()
                                                }else{
                                                    showDialogRv.toggle()
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
                            
                        })
                        .disabled(ctrlViewModel.isDownloading)
                        .padding(.trailing, 16)
                        
                    })
                }
            }
            .padding(.bottom, 24)
            
            ZStack {
                if store.allowShowBanner(){
                    BannerAdViewMain(adStatus: $ctrlViewModel.adStatus)
                }
            }
            .frame(height: GADAdSizeBanner.size.height)
            .offset(y : viewModel.wallpapers[index].specialContentV2ID == 6 ?  16 : 0)

        }
        
    }
    
    func downloadImageToGallery(title : String, urlStr : String){
        DispatchQueue.main.async {
            ctrlViewModel.isDownloading = true
        }
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url {
                DownloadFileHelper.saveImageToLibFromURLSanbox(url: url, onComplete: {
                    success in
                    if success{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            let urlPreview = viewModel.wallpapers[index].thumbnail?.path.full ??  viewModel.wallpapers[index].path.first?.path.full ?? ""
                            self.urlForDownloadSuccess = URL(string: urlPreview)
                            self.navigateToDownloadSuccessView = true
                        })
                        
                        
                    } else {
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
                    }
                })
                
            } else {
                ctrlViewModel.isDownloading = false
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
            }
        })
        
        
        
    }
    
    
    
    
}
