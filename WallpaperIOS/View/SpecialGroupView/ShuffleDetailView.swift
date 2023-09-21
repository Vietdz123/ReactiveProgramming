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
                        }).disabled(store.isPurchasing)
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
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .addBackground()
            .onAppear(perform: {
                store.showBanner = false
                if !store.isPro(){
                    interAd.showAd {
                        
                    }
                }
                
            })
            .onDisappear(perform: {
                store.showBanner = true
            })
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
                    Image("crown")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                }
              
                
                
                NavigationLink(destination: {
                    TutorialShuffleView()
                }, label: {
                    Image( "help")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                    
                        .contentShape(Rectangle())
                }).padding(.horizontal, 20)
                
                
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44  )
            
            Spacer()
            
            Button(action: {
                getPhotoPermission(status: {
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
                }
             
                    .frame(width: 240, height: 48)
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
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        }) { success, error in
            if success {
                wallpaper.path.forEach({
                    path in
                    downloadImageToGallery(title: path.fileName, urlStr: path.path.full)
                })
                DispatchQueue.main.async {
                    isDownloading = false
                }
            } else {
                DispatchQueue.main.async {
                    isDownloading = false
                }
                showToastWithContent(image: "xmark", color: .red, mess: "Error, can't create Albumn")
            }
        }
    }
    
    
   
    
    func downloadImageToGallery(title : String, urlStr : String){
        DispatchQueue.main.async {
            isDownloading = true
        }
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask? = nil
        DispatchQueue.global(qos: .background).async {
            let imgURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageDownloaded")
            print("FILE_MANAGE \(imgURL)")
            if let url = URL(string: urlStr) {
                let filePath = imgURL.appendingPathComponent("\(title).jpg")

                dataTask = defaultSession.dataTask(with: url, completionHandler: {  data, res, err in
                    DispatchQueue.main.async {
                        do {
                            try data?.write(to: filePath)
                            PHPhotoLibrary.shared().performChanges({
                               // PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: filePath)
                         
                                let request = PHAssetChangeRequest.creationRequestForAsset(from: UIImage(contentsOfFile: filePath.path)!)
                                            let placeholder = request.placeholderForCreatedAsset
                                            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.getAlbum()!)
                                            let enumeration: NSArray = [placeholder!]
                                            albumChangeRequest!.addAssets(enumeration)
                                            
                                
                            }) { completed, error in
                                if completed {
                                    DispatchQueue.main.async {
                                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                                    }
                                    
                                } else if let error = error {
                                    DispatchQueue.main.async {
                                        showToastWithContent(image: "xmark", color: .red, mess: error.localizedDescription)
                                    }
                                    
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
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
    
}
