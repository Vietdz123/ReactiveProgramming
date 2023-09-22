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
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @AppStorage("exclusive_cost", store: .standard) var exclusiveCost : Int = 4
    
    
    @State var showBuySubAtScreen : Bool = false
    @State var isBuySubWeek : Bool = true
    @State var showMore : Bool = false
    var body: some View {
        
        
        ZStack{
            
            if !viewModel.wallpapers.isEmpty && index < viewModel.wallpapers.count{
                NavigationLink(isActive: $ctrlViewModel.navigateView, destination: {
                    SubcriptionVIew()
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
                
                if showBuySubAtScreen {
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .ignoresSafeArea()
                    
                    if let weekPro = store.weekProduct , let monthPro = store.monthProduct {
                        VStack(spacing : 0){
                            Spacer()
                            
                            
                            ZStack{
                                
                                if showMore {
                                    VStack(spacing : 0){
                                        Text("Give Your Phone A Brand-New Look")
                                            .mfont(20, .bold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .frame(width: 320)
                                        
                                        Text("Choose your subscription plan:")
                                            .mfont(16, .regular)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .frame(width: 320)
                                        .padding(.top, 12)
                                        
                                        
                                        HStack(spacing : 0){
                                            ZStack{
                                                if isBuySubWeek {
                                                    Circle()
                                                        .fill(
                                                            LinearGradient(
                                                            stops: [
                                                            Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                                            Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                                            Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                                            ],
                                                            startPoint: UnitPoint(x: 0.1, y: 1.17),
                                                            endPoint: UnitPoint(x: 1, y: -0.22)
                                                        )
                                                        )
                                                    Image("checkmark")
                                                        .resizable()
                                                        .aspectRatio( contentMode: .fit)
                                                        .frame(width: 24, height: 24)
                                                    
                                                }else{
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: 1)
                                                }
                                                
                                               
                                                
                                            }.frame(width: 24, height: 24)  .padding(.horizontal, 16)
                                            
                                            VStack(spacing : 2){
                                                Text("Best Offer")
                                                    .mfont(16, .bold)
                                                    .foregroundColor(.white)
                                                
                                                Text("\(weekPro.displayPrice)/week")
                                                    .mfont(12, .regular)
                                                  .foregroundColor(.white)
                                                
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("\(weekPro.displayPrice)/week")
                                                .mfont(12, .regular)
                                              .foregroundColor(.white)
                                              .padding(.trailing, 16)
                                                            
                                              
                                        }.frame(maxWidth: .infinity)
                                            .frame(height: 48)
                                            .contentShape(RoundedRectangle(cornerRadius: 12))
                                            .onTapGesture{
                                                withAnimation{
                                                    isBuySubWeek = true
                                                }
                                            }
                                            .overlay(
                                                Text("Sale 30%")
                                                    .mfont(10, .bold)
                                                  .multilineTextAlignment(.center)
                                                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                                  .frame(width: 64, height: 16)
                                                 
                                                  .background(
                                                    Capsule().fill(Color.main)
                                                  )
                                                  .offset(x : -16, y : -8)
                                                ,
                                                alignment: .topTrailing
                                            
                                            )
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(
                                                    
                                                        LinearGradient(
                                                        stops: [
                                                        Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1).opacity(0.2), location: 0.00),
                                                        Gradient.Stop(color: Color(red: 0.82, green: 0.23, blue: 0.89).opacity(0.2), location: 1.00),
                                                        ],
                                                        startPoint: UnitPoint(x: 0, y: 1),
                                                        endPoint: UnitPoint(x: 1, y: 0)
                                                        )
                                                    )
                                                
                                            )
                                        
                                            .padding(.horizontal, 27)
                                            .padding(.top, 32)
                                        
                                        
                                        HStack(spacing : 0){
                                            ZStack{
                                                if !isBuySubWeek {
                                                    Circle()
                                                        .fill(
                                                            LinearGradient(
                                                            stops: [
                                                            Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                                            Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                                            Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                                            ],
                                                            startPoint: UnitPoint(x: 0.1, y: 1.17),
                                                            endPoint: UnitPoint(x: 1, y: -0.22)
                                                        )
                                                        )
                                                    Image("checkmark")
                                                        .resizable()
                                                        .aspectRatio( contentMode: .fit)
                                                        .frame(width: 24, height: 24)
                                                    
                                                }else{
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: 1)
                                                }
                                                
                                               
                                                
                                            }.frame(width: 24, height: 24)  .padding(.horizontal, 16)
                                            
                                            VStack(spacing : 2){
                                                Text("Monthly")
                                                    .mfont(16, .bold)
                                                    .foregroundColor(.white)
                                                
                                                Text("\(monthPro.displayPrice)/month")
                                                    .mfont(12, .regular)
                                                  .foregroundColor(.white)
                                                
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("\(decimaPriceToStr(price: monthPro.price , chia: 4))\(removeDigits(string: monthPro.displayPrice ))/week")
                                                .mfont(12, .regular)
                                              .foregroundColor(.white)
                                              .padding(.trailing, 16)
                                                            
                                              
                                        }.frame(maxWidth: .infinity)
                                            .frame(height: 48)
                                            .contentShape(RoundedRectangle(cornerRadius: 12))
                                            .onTapGesture{
                                                withAnimation{
                                                    isBuySubWeek = false
                                                }
                                            }
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(
                                                    
                                                        LinearGradient(
                                                        stops: [
                                                        Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1).opacity(0.2), location: 0.00),
                                                        Gradient.Stop(color: Color(red: 0.82, green: 0.23, blue: 0.89).opacity(0.2), location: 1.00),
                                                        ],
                                                        startPoint: UnitPoint(x: 0, y: 1),
                                                        endPoint: UnitPoint(x: 1, y: 0)
                                                        )
                                                    )
                                                
                                            )
                                        
                                            .padding(.horizontal, 27)
                                            .padding(.top, 12)
                                        
                                      
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                  
                                    
                                }else{
                                    VStack(spacing : 0){
                                        Text("Give Your Phone A Brand-New Look")
                                            .mfont(16, .bold)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                            .frame(width: 320, alignment: .top)
                                        
                                        Group{
                                            Text("Only 3.99$ per week.")
                                            Text("Auto-renewable. Cancel anytime.")
                                            
                                        }
                                        .mfont(12, .regular)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .frame(width: 320, alignment: .top)
                                    }
                                }
                               
                                
                            }
                            
                          
                            
                            
                            
                            Button(action: {
                                withAnimation(.spring()){
                                    showMore.toggle()
                                }
                            }, label: {
                                HStack(spacing : 8){
                                    Text("More Options")
                                        .mfont(12, .regular)
                                    
                                      .multilineTextAlignment(.center)
                                      .foregroundColor(.white)
                                    
                                    Image(systemName: showMore ?  "chevron.up" : "chevron.down" )
                                        .resizable()
                                        .aspectRatio( contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 16, height: 16)
                                    
                                }.frame(width: 120, height: 24)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white.opacity(0.2))
                                    )
                                    .padding(16)
                            })
                          
                          
                            
                            
                            Button(action: {
                                if store.purchasedIds.isEmpty{
                                
                                    Firebase_log("Sub_click_buy_sub_total")
                                    store.isPurchasing = true
                                    showProgressSubView()
                                    if isBuySubWeek {
                                     
                                        Firebase_log("Sub_click_buy_weekly")
                                        store.purchase(product: weekPro, onBuySuccess: { b in
                                            if b {
                                                DispatchQueue.main.async{
                                                    store.isPurchasing = false
                                                    hideProgressSubView()
                                                    showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                                    withAnimation(.easeInOut){
                                                        showBuySubAtScreen = false
                                                    }
                                                }
                                               
                                            }else{
                                                DispatchQueue.main.async{
                                                    store.isPurchasing = false
                                                    hideProgressSubView()
                                                    showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                                }
                                            }
                                           
                                        })


                                    }else {
                                 
                                        Firebase_log("Sub_click_buy_monthly")
                                        store.purchase(product: monthPro, onBuySuccess: { b in
                                            if b {
                                                DispatchQueue.main.async{
                                                    store.isPurchasing = false
                                                    hideProgressSubView()
                                                    showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                                    withAnimation(.easeInOut){
                                                        showBuySubAtScreen = false
                                                    }
                                                }
                                               
                                            }else{
                                                DispatchQueue.main.async{
                                                    store.isPurchasing = false
                                                    hideProgressSubView()
                                                    showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                                }
                                            }
                                            
                                        })

                                    }
                                }
                               
                            }, label: {
                                HStack{
                                   
                                    
                                    Text("Continue")
                                        .mfont(16, .bold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                        .overlay(
                                            ZStack{
                                                if store.isPurchasing{
                                                    EZProgressView()
                                                }
                                            }.offset(x : -36)
                                            , alignment: .leading
                                        )
                                }
                                
                              
                                    .frame(width: 240, height: 48)
                                    .background(
                                        Capsule()
                                            .foregroundColor(.main)
                                    )
                            })
                            ZStack{
                                HStack(spacing : 32){
                                    Button(action: {
                                        Task{
                                            let b = await store.restore()
                                            if b {
                                                showToastWithContent(image: "checkmark", color: .green, mess: "Restore Successful")
                                            }else{
                                                showToastWithContent(image: "xmark", color: .red, mess: "Cannot restore purchase")
                                            }
                                        }
                                    }, label: {
                                        Text("RESTORE")
                                            .mfont(10, .regular)
                                            .foregroundColor(.white)
                                    })
                                    
                                    Button(action: {
                                        if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                            UIApplication.shared.open(url)
                                        }
                                    }, label: {
                                        Text("EULA")
                                            .mfont(10, .regular)
                                            .foregroundColor(.white)
                                    })
                                    
                                    
                                    Button(action: {
                                        if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
                                            UIApplication.shared.open(url)
                                        }
                                    }, label: {
                                        Text("PRIVACY")
                                            .mfont(10, .regular)
                                            .foregroundColor(.white)
                                    })
                                }
                                
                            }.frame(height: 48)
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .overlay(
                        Button(action: {
                            withAnimation(.easeInOut){
                                showBuySubAtScreen.toggle()
                            }
                        }, label: {
                            Image("close.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .padding(16)
                        }), alignment: .topTrailing
                            
                        )
                    }
                    
                   
                        
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .overlay(
            ZStack(alignment: .bottom){
                if ctrlViewModel.showInfo {
              //      if let wallpaper = viewModel.wallpapers[index] {
                        Color.black.opacity(0.5).ignoresSafeArea()
                            .onTapGesture {
                                ctrlViewModel.showInfo = false
                            }
                        
                        VStack(spacing : 8){
                        
                            
                            Text("Author: \("Unknow")")
                                .foregroundColor(.white)
                                .mfont(16, .regular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Liscense: \(viewModel.wallpapers[index].license ?? "Unknow")")
                                .foregroundColor(.white)
                                .mfont(16, .regular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
                            .overlay(
                                Button(action: {
                                    ctrlViewModel.showInfo = false
                                    
                                }, label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width : 14, height: 14)
                                        .padding(12)
                                    
                                }), alignment: .topTrailing
                            )
                            .background(
                                Color.mblack_bg
                                    .opacity(0.9)
                            )
                            .cornerRadius(16)
                            .padding()
                  //  }
                }
            }
        
        )
        .sheet(isPresented: $ctrlViewModel.showTutorial, content: {
            TutorialContentView()
        })
        
      
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
                Image("crown")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                
                
                Button(action: {
                    ctrlViewModel.showInfo.toggle()
                }, label: {
                    Image( "info")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }).padding(.horizontal, 16)
                
                Button(action: {
                    ctrlViewModel.showTutorial.toggle()
                }, label: {
                    Image( "help")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }).padding(.trailing, 20)
                
                
                
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44  )
            
            
            Spacer()
            
            HStack{
                Button(action: {
                    let wallpaper = viewModel.wallpapers[index]
                    if !favViewModel.isFavorite(id: wallpaper.id) {
                        favViewModel.addFavoriteWLToCoreData(id: wallpaper.id ,
                                                             preview_url: wallpaper.path.first?.path.preview ?? "",
                                                             url: wallpaper.path.first?.path.full ?? "",
                                                             type:  "image",
                                                             contentType: wallpaper.contentType == 1 ? "private" : "cost",
                                                             cost: Int(wallpaper.cost))
                        ServerHelper.sendImageSpecialDataToServer(type: "favorite", id: wallpaper.id)
                    }else{
                        favViewModel.deleteFavWL(id: wallpaper.id)
                    }
                    
                    
                }, label: {
                    Image( favViewModel.isFavorite(id: viewModel.wallpapers[index].id) ? "heart.fill" : "heart")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .frame(width: 48, height: 48)
                        .containerShape(Circle())
                        .background(
                            Circle()
                                .fill(Color.mblack_bg.opacity(0.7))
                                .frame(width: 48, height: 48)
                        )
                })

                Button(action: {
                    
                    getPhotoPermission(status: {
                         b in
                        if b {
                            if store.isPro(){
                                downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].path.first?.path.full ?? ""))
                                ServerHelper.sendImageSpecialDataToServer(type: "download", id: viewModel.wallpapers[index].id)
                            }else{
                                
                                if viewModel.wallpapers[index].specialContentV2ID == 3 {
                                    
                                    if !UserDefaults.standard.bool(forKey: "try_dynamic_island"){
                                        UserDefaults.standard.set(true, forKey: "try_dynamic_island")
                                        downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].path.first?.path.full ?? ""))
                                        ServerHelper.sendImageSpecialDataToServer(type: "download", id: viewModel.wallpapers[index].id)
                                    }else{
                                        DispatchQueue.main.async {
                                            withAnimation(.easeInOut){
                                                showBuySubAtScreen.toggle()
                                            }
                                        }
                                        
                                    }
                                    
                                  
                                }else{
                                    if !UserDefaults.standard.bool(forKey: "try_depth_effec"){
                                        UserDefaults.standard.set(true, forKey: "try_depth_effec")
                                        downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].path.first?.path.full ?? ""))
                                        ServerHelper.sendImageSpecialDataToServer(type: "download", id: viewModel.wallpapers[index].id)
                                    }else{
                                        DispatchQueue.main.async {
                                            withAnimation(.easeInOut){
                                                showBuySubAtScreen.toggle()

                                            }
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
                
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .contentShape(Capsule())
                        .background(
                            Capsule().fill(Color.main)
                        )
                }).padding(.horizontal, 16)
                
                
                Button(action: {
                    withAnimation{
                        ctrlViewModel.showControll = false
                        ctrlViewModel.showPreview = true
                    }
                }, label: {
                    Image("preview")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .frame(width: 48, height: 48)
                        .background(
                            Circle()
                                .fill(Color.mblack_bg.opacity(0.7))
                                .frame(width: 48, height: 48)
                        )
                }) .frame(width: 48, height: 48)
                    .containerShape(Circle())
            }
            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .padding(.bottom, 40)
        }
        
    }
    
    @ViewBuilder
    func Preview() -> some View{
        TabView(selection: $ctrlViewModel.isHome){
            
//            Image("preview_lock")
            Image("lock_preview_hour")
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
                    downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].path.first?.path.full ?? ""))
                    ServerHelper.sendImageDataToServer(type: "set", id: viewModel.wallpapers[index].id)
                }
            }else{
                showToastWithContent(image: "xmark", color: .red, mess: "Ads is not ready!")
            }
        }, clickBuyPro: {
            ctrlViewModel.showDialogRV.toggle()
            ctrlViewModel.navigateView.toggle()
        }).environmentObject(reward)
            .environmentObject(store)
    }
    
    @ViewBuilder
    func DialogGetWLByCoin(urlStr : String) -> some View{
        BuyWithCoinDialog(urlStr: urlStr, coin: exclusiveCost,show: $ctrlViewModel.showDialogBuyCoin, onBuyWithCoin: {
            ctrlViewModel.showDialogBuyCoin.toggle()
            if currentCoin >= exclusiveCost{
                currentCoin = currentCoin - exclusiveCost
                DispatchQueue.main.async{
                   
                    downloadImageToGallery(title: "image\(viewModel.wallpapers[index].id)", urlStr: (viewModel.wallpapers[index].path.first?.path.full ?? "").replacingOccurrences(of: "\"", with: ""))
                    ServerHelper.sendImageDataToServer(type: "set", id: viewModel.wallpapers[index].id)
                }
            }else{
                showToastWithContent(image: "xmark", color: .red, mess: "Not enough coins!")
            }
        }, onBuyPro: {
            ctrlViewModel.showDialogBuyCoin.toggle()
            ctrlViewModel.navigateView.toggle()
        }).environmentObject(store)
            .environmentObject(reward)
    }
    
    
    func downloadImageToGallery(title : String, urlStr : String){
        DispatchQueue.main.async {
            ctrlViewModel.isDownloading = true
        }
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask? = nil
        DispatchQueue.global(qos: .background).async {
            let imgURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageDownloaded")
            print("FILE_MANAGE \(imgURL)")
            if let url = URL(string: urlStr) {
                let filePath = imgURL.appendingPathComponent("\(title).jpg")
                if FileManager.default.fileExists(atPath: filePath.path){
                    DispatchQueue.main.async {
                  
                            ctrlViewModel.isDownloading = false
                      
                        showToastWithContent(image: "xmark", color: .red, mess: "File already exists!")
                    }
                    return
                }
                dataTask = defaultSession.dataTask(with: url, completionHandler: {  data, res, err in
                    DispatchQueue.main.async {
                        do {
                            try data?.write(to: filePath)
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: filePath)
                            }) { completed, error in
                                if completed {
                                    DispatchQueue.main.async {
                                        ctrlViewModel.isDownloading = false
                                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                                        if UserDefaults.standard.bool(forKey: "firsttime_showtuto") == false {
                                            UserDefaults.standard.set(true, forKey: "firsttime_showtuto")
                                            ctrlViewModel.showTutorial = true
                                        }
                                        
                                        let downloadCount = UserDefaults.standard.integer(forKey: "user_download_count")
                                        UserDefaults.standard.set(downloadCount + 1, forKey: "user_download_count")
                                        if !store.isPro() && downloadCount == 1 {
                                            ctrlViewModel.navigateView.toggle()
                                        }else{
                                            showRateView()
                                        }
                                        
                                        
                                    }
                                    
                                } else if let error = error {
                                    DispatchQueue.main.async {
                                        ctrlViewModel.isDownloading = false
                                        showToastWithContent(image: "xmark", color: .red, mess: error.localizedDescription)
                                    }
                                    
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                ctrlViewModel.isDownloading = false
                                showToastWithContent(image: "xmark", color: .red, mess: error.localizedDescription)
                            }
                            
                        }
                    }
                    dataTask = nil
                })
                dataTask?.resume()
            }
        }
        
    }
}

