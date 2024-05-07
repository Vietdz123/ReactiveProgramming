//
//  LockThemeDetailView.swift
//  WallpaperIOS
//
//  Created by Duc on 07/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import GoogleMobileAds
struct LockThemeDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var index : Int
    
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @EnvironmentObject var viewModel : LockThemeViewModel
//    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var store : MyStore
 //   @EnvironmentObject var interAd : InterstitialAdLoader
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @AppStorage("exclusive_cost", store: .standard) var exclusiveCost : Int = 4
    
    
    @State var showBuySubAtScreen : Bool = false
    @State var isBuySubWeek : Bool = true
    @State var showMore : Bool = false
    @State var showContentPremium : Bool = false
    @State var showSub : Bool = false
    @State var showDialogRv : Bool = false
    @State var showTuto : Bool = false
    @State var showDownloadView : Bool = false
    
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
                        let urlStr = wallpaper.thumbnail.first?.url.full ?? ""
                        AsyncImage(url: URL(string:  urlStr ?? ""  )){
                            phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: getRect().width, height: getRect().height)
                                    .clipped()
                                
                                
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
//                            if !store.isPro(){
//                                interAd.showAd(onCommit: {})
//                            }
//                            
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
                
                
                if showBuySubAtScreen {
                    SpecialSubView( onClickClose: {
                        showBuySubAtScreen = false
                    })
                    .environmentObject(store)
                }
                
                if showDialogRv {
                    let url  = viewModel.wallpapers[index].thumbnail.first?.url.full ?? ""
                        WatchRVtoGetWLDialog( urlStr: url, show: $showDialogRv ,onRewarded: {
                            b in
                            showDialogRv = false
                            if b {
                                downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: url)
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
                    let url  = viewModel.wallpapers[index].thumbnail.first?.url.preview ?? ""
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

#Preview {
    LockThemeDetailView(index: 0)
        .environmentObject(MyStore())
        .environmentObject(LockThemeViewModel())
}

extension LockThemeDetailView{
    
 

   
    
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
                   
                    if !store.isPro() { //&& viewModel.wallpapers[index] == 1 {
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
               
                    VStack(spacing : 0){
                        Spacer()
                        Button(action: {
                            showDownloadView.toggle()
//                            getPhotoPermission(status: {
//                                b in
//                                if b {
//                                    if store.isPro(){
//                                        downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].thumbnail.first?.url.full ?? ""))
//                                        ServerHelper.sendImageSpecialDataToServer(type: "download", id: viewModel.wallpapers[index].id)
//                                    }else{
//                                        DispatchQueue.main.async {
//                                            withAnimation(.easeInOut){
////                                                if viewModel.wallpapers[index].contentType == 1 {
////                                                    showBuySubAtScreen.toggle()
////                                                }else{
////                                                    showDialogRv.toggle()
////                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            })
//                            
                            
                            
                            
                            
                            
                        }, label: {
                            Image("detail_download")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .frame(width: 56, height: 56)
                                .background(Circle().fill(Color.main))
                        })
                       
                    }
             
            }
           
            
            .padding(.bottom, 24)
            
            ZStack{
              
            }.frame(height: GADAdSizeBanner.size.height)

        }.overlay(alignment: .bottom){
            if showDownloadView {
                ZStack(alignment: .bottom){
                    VisualEffectView(effect: UIBlurEffect(style: .dark)).ignoresSafeArea()
                    ThemeDownloadView()
                }
              
           
           
            }
        }.overlay(alignment: .bottom, content: {
            ZStack{
                if store.allowShowBanner(){
                    BannerAdViewMain(adStatus: $ctrlViewModel.adStatus)
                }
            }.frame(height: GADAdSizeBanner.size.height)
        })
        
    }
    
    
    func ThemeDownloadView() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Image("crown")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Spacer()
                Text("Theme Item")
                  .font(
                    Font.custom("SVN-Avo", size: 17)
                      .weight(.bold)
                  )
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
                  .font(
                    Font.custom("SVN-Avo", size: 17)
                      .weight(.bold)
                  )
                  .foregroundColor(.white)
                Spacer()
                
                Text("Save")
                  .font(
                    Font.custom("SVN-Avo", size: 16)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(width: 120, height: 32)
                  .background(Color(red: 1, green: 0.87, blue: 0.19))
                  .clipShape(Capsule())

                 
                
            }.frame(height: 32)
                .padding(.horizontal, 16)
                .padding(.top, 36)
            
            HStack(spacing : 0){
                Text("LockScreen Inline")
                  .font(
                    Font.custom("SVN-Avo", size: 17)
                      .weight(.bold)
                  )
                  .foregroundColor(.white)
                Spacer()
                
                Text("Save")
                  .font(
                    Font.custom("SVN-Avo", size: 16)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(width: 120, height: 32)
                  .background(Color(red: 1, green: 0.87, blue: 0.19))
                  .clipShape(Capsule())

                 
                
            }.frame(height: 32)
                .padding(.horizontal, 16)
                .padding(.top, 32)
            
            
            ZStack{
                Color.gray
            }.frame(maxWidth: .infinity)
                .frame(height: 94)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            
            HStack(spacing : 0){
                Text("LockScreen Widget")
                  .font(
                    Font.custom("SVN-Avo", size: 17)
                      .weight(.bold)
                  )
                  .foregroundColor(.white)
                Spacer()
                
                Text("Save")
                  .font(
                    Font.custom("SVN-Avo", size: 16)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(width: 120, height: 32)
                  .background(Color(red: 1, green: 0.87, blue: 0.19))
                  .clipShape(Capsule())

                 
                
            }.frame(height: 32)
                .padding(.horizontal, 16)
                .padding(.top, 32)
            
            let width =  (getRect().width - 52) / 4
            HStack(spacing : 10){
               Rectangle()
                    .fill(Color.red)
                    .frame(width: width * 2)
                
                Rectangle()
                     .fill(Color.red)
                     .frame(width: width )
                
                Rectangle()
                     .fill(Color.red)
                     .frame(width: width )
                
            }.frame(maxWidth: .infinity)
                .frame(height: width)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            
            Text("Save All")
              .font(
                Font.custom("SVN-Avo", size: 16)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
              .frame(maxWidth: .infinity)
              .frame( height: 48)
              .background(Color(red: 1, green: 0.87, blue: 0.19))
              .clipShape(Capsule())
              .padding(.horizontal, 67)
              .padding(.top, 40)
              .padding(.bottom, 24)
             
            ZStack{
              
            }.frame(height: GADAdSizeBanner.size.height)
            
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(red: 0.13, green: 0.14, blue: 0.13).opacity(0.7)
                .cornerRadius(20)
                .edgesIgnoringSafeArea(.bottom)
        )
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

                  //    showTuto1stTime()
                        
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
//    
//    func showTuto1stTime() {
//        if viewModel.wallpapers[index].specialContentV2ID == 6 {
//            let show = UserDefaults.standard.bool(forKey: "showTuto_poster_contact_1st")
//            if show == false{
//                UserDefaults.standard.set(true, forKey: "showTuto_poster_contact_1st")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//                    showTuto.toggle()
//                })
//            }
//        }
//      
//        
//    }
    
  
}
