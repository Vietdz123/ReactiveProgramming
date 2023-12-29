//
//  SpWLDetailView.swift
//  WallpaperIOS
//
//  Created by Mac on 09/08/2023.
//

import SwiftUI
import PhotosUI
import Photos

struct SpWLDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var index : Int
    
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @EnvironmentObject var viewModel : SpViewModel
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var store : MyStore
    
    @EnvironmentObject var interAd : InterstitialAdLoader
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @AppStorage("exclusive_cost", store: .standard) var exclusiveCost : Int = 4
    
    
    @State var showBuySubAtScreen : Bool = false
    @State var isBuySubWeek : Bool = true
    @State var showMore : Bool = false
    @State var showContentPremium : Bool = false
    @State var showSub : Bool = false
    @State var showDialogRv : Bool = false
    @State var showTuto : Bool = false
    
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
                        AsyncImage(url: URL(string: wallpaper.thumbnail?.path.preview ?? ( wallpaper.path.first?.path.preview ?? ""  ))){
                            phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: getRect().width, height: getRect().height)
                                    .clipped()
                                
                            } else if phase.error != nil {
                                AsyncImage(url: URL(string: wallpaper.path.first?.path.full ?? "")){
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
                        .overlay(
                            ZStack{
                                if viewModel.wallpapers[index].specialContentV2ID == 3{
                                    Image("dynamic")
                                        .resizable()
                                }
                                
                                
                                
                            }
                        )
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
                
                
                
                if ctrlViewModel.showControll{
                    ControllView()
                }
                
                
                if showBuySubAtScreen {
                    SpecialSubView( onClickClose: {
                        showBuySubAtScreen = false
                    })
                    .environmentObject(store)
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
        .fullScreenCover(isPresented: $showTuto , content: {
            PosterContactTutoView()
        })
        .fullScreenCover(isPresented: $showSub, content: {
            EztSubcriptionView()
                .environmentObject(store)
        })

        
    }
    
    
}


extension SpWLDetailView{

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
                   
                    if !store.isPro() && viewModel.wallpapers[index].contentType == 1 {
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
                
                getPhotoPermission(status: {
                    b in
                    if b {
                        if store.isPro(){
                            downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].path.first?.path.full ?? ""))
                            ServerHelper.sendImageSpecialDataToServer(type: "download", id: viewModel.wallpapers[index].id)
                        }else{
                                DispatchQueue.main.async {
                                    withAnimation(.easeInOut){
                                        if viewModel.wallpapers[index].contentType == 1 {
                                            showBuySubAtScreen.toggle()
                                        }else{
                                            showDialogRv.toggle()
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
                .frame(width: 240, height: 48)
                .contentShape(Rectangle())
                .background(
                    Capsule().fill(Color.main)
                )
            })
//            .padding(.horizontal, 16)
//                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
//                .frame(maxWidth: .infinity)
//                .frame(height: 48)
                .padding(.bottom, 48 - ( viewModel.wallpapers[index].specialContentV2ID == 6 ? 64 : 0 ))
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

                      showTuto1stTime()
                        
                        let downloadCount = UserDefaults.standard.integer(forKey: "user_download_count")
                        UserDefaults.standard.set(downloadCount + 1, forKey: "user_download_count")
                        if downloadCount == 2 {
                            showRateView()
                        }
                    }else{
                        ctrlViewModel.isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
                    }
                })
            }else{
                ctrlViewModel.isDownloading = false
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure!")
            }
        })
        
        
        
    }
    
    func showTuto1stTime() {
        if viewModel.wallpapers[index].specialContentV2ID == 6 {
            let show = UserDefaults.standard.bool(forKey: "showTuto_poster_contact_1st")
            if show == false{
                UserDefaults.standard.set(true, forKey: "showTuto_poster_contact_1st")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    showTuto.toggle()
                })
            }
        }
      
        
    }
    
  
}
