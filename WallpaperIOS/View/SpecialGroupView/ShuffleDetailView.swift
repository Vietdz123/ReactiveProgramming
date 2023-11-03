//
//  ShuffleDetailView.swift
//  WallpaperIOS
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI

struct ShuffleDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var reward : RewardAd
   
 
    @EnvironmentObject var interAd : InterstitialAdLoader
    @State var currentIndex  = 0
    @State var showMore : Bool = false
    let wallpaper : SpWallpaper
    
    @State var showBuySubAtScreen : Bool = false
    @State var isBuySubWeek : Bool = true
    @State var isDownloading : Bool = false
    
    @State var showContentPremium : Bool = false
    @State var showSub : Bool = false
    @State var showTuto : Bool = false
    
    var body: some View {
        
        ZStack{
            
     
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
            
            if showBuySubAtScreen {
              //SubInScreen()
               SpecialSubView(onClickClose: {
                   showBuySubAtScreen = false
               })
                    .environmentObject(store)
                    
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
            .fullScreenCover(isPresented: $showSub, content: {
                EztSubcriptionView()
                    .environmentObject(store)
            })
            .onAppear(perform: {
                if !store.isPro(){
                    interAd.showAd {
                        
                    }
                }
            })
           
    }
    

    
    
    
    
    
}

extension ShuffleDetailView{
    
    @ViewBuilder
    func SubInScreen() -> some View{
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            if let weekPro = store.weekProduct , let monthPro = store.monthProduct, let yearV2 = store.yearlyOriginalProduct , let weekNotSale = store.weekProductNotSale {
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
                                    
                                
                                 
                                            HStack{
                                                VStack(spacing : 2){
                                                    Text("Annually")
                                                        .mfont(16, .bold)
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    Text("\(yearV2.displayPrice)/year")
                                                        .mfont(12, .regular)
                                                      .foregroundColor(.white)
                                                      .frame(maxWidth: .infinity, alignment: .leading)
                                                }.frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Spacer()
                                                
                                                Text("\(decimaPriceToStr(price: yearV2.price ,chia:51))\(removeDigits(string:yearV2.displayPrice))/week")
                                                    .mfont(12, .regular)
                                                  .foregroundColor(.white)
                                                  .padding(.trailing, 16)
                                            }
                                            
                                          
                                   
                                    
                                  
                                                    
                                      
                                }.frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .contentShape(RoundedRectangle(cornerRadius: 12))
                                    .onTapGesture{
                                        withAnimation{
                                            isBuySubWeek = true
                                        }
                                    }
                                    .overlay(
                                        Text("BEST VALUE")
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
                                    
                        
                                            HStack{
                                                VStack(spacing : 2){
                                                    Text("Weekly")
                                                        .mfont(16, .bold)
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    
                                                    Text("\(weekNotSale.displayPrice)/week")
                                                        .mfont(12, .regular)
                                                      .foregroundColor(.white)
                                                      .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Spacer()
                                                Text("\(weekNotSale.displayPrice)/week")
                                                    .mfont(12, .regular)
                                                  .foregroundColor(.white)
                                                  .padding(.trailing, 16)
                                            }
                                            
                                           
                                 
                                      
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
                                 
                                        Text("Only \(yearV2.displayPrice) per year.")
                                   
                                    
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
                                
                                let product =  yearV2
                           //     let log =
                                
                                
                                store.purchase(product: product, onBuySuccess: { b in
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
                                let product = weekNotSale
                                
                                store.purchase(product: product, onBuySuccess: { b in
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
                            .contentShape(Rectangle())
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
                                        store.fetchProducts()
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
                if !store.isPro(){
                    
                    Button(action: {
                        showContentPremium.toggle()
                    }, label: {
                        Image("crown")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .frame(width: 40, height: 44, alignment: .center)
                    })
                    
                  
                }
              
                Button(action: {
                    showTuto.toggle()
                }, label: {
                    Image( "help")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .frame(width: 44, height: 44)
                    
                        .contentShape(Rectangle())
                }).padding(.trailing, 10)
                
                
                NavigationLink(
                    destination: TutorialShuffleView(),
                    isActive: $showTuto,
                    label: {
                        EmptyView()
                    })
                
            
                
                
                
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
                            if !UserDefaults.standard.bool(forKey: "try_shuffle_pack"){
                                UserDefaults.standard.set(true, forKey: "try_shuffle_pack")
                                createAlbum(albumName: "Shuffle \(wallpaper.id)")
                                ServerHelper.sendImageSpecialDataToServer(type: "download", id: wallpaper.id)
                            }else{
                                DispatchQueue.main.async {
                                    withAnimation(.easeInOut){
                                        showBuySubAtScreen.toggle()
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
                HStack{
                    Text("Save Packs")
                        .mfont(16, .bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .overlay(
                            ZStack{
                                if isDownloading{
                                    EZProgressView()
                                }
                            }.offset(x : -36)
                            , alignment: .leading
                        )
                }.frame(width: 240, height: 48)
                    .contentShape(Rectangle())
                    .background(
                        Capsule()
                            .foregroundColor(.main)
                    )
            })
            
            ZStack{
                HStack(spacing : 8){
                    ForEach(0..<wallpaper.path.count, content: {
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
            }.frame(height: 48)
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
                            showTutorialFirst()
                            
                            
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
    
    func showTutorialFirst() {
        let showTutoshuffle = UserDefaults.standard.bool(forKey: "show_tuto_shuffleee")
        if showTutoshuffle == false{
            UserDefaults.standard.set(true, forKey: "show_tuto_shuffleee")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                showTuto.toggle()
            })
        }
    }
    
}
