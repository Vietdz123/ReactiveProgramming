//
//  FavoritedWallpaperView.swift
//  WallpaperIOS
//
//  Created by Mac on 27/04/2023.
//

import SwiftUI
import PhotosUI
import AVKit

struct FavoritedWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritedWallpaperView()
    }
}

struct FavoritedWallpaperView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    var body: some View {
        VStack(spacing: 0){
            Text("Favorited")
                .foregroundColor(.yellow)
                .mfont(17, .bold)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .overlay(
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image( "back")
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .frame(width: 64, height: 44)
                            .contentShape(Rectangle())
                    }), alignment: .leading
                )
            if !favViewModel.listFavWL.isEmpty {
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: [GridItem(spacing: 8),GridItem(spacing: 8), GridItem(spacing: 0)], content: {
                        ForEach(favViewModel.listFavWL, id: \.wl_id){
                            wallpaper in
                            NavigationLink(destination: {
                                if wallpaper.type == "image" {
                                    FavWallpaperDetailView( wallpaper: wallpaper)
                                        .environmentObject(store)
                                        .environmentObject(favViewModel)
                                        .environmentObject(reward)
                                        .environmentObject(interAd)
                                }else{
                                    FavLiveWallpaperDetailView(wallpaper: wallpaper)
                                        .environmentObject(store)
                                        .environmentObject(favViewModel)
                                        .environmentObject(reward)
                                        .navigationBarTitle("", displayMode: .inline)
                                        .navigationBarHidden(true)
                                }
                            }, label: {
                                AsyncImage(url: URL(string: wallpaper.preview_url ?? "")){
                                    phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
                                            .clipped()
                                    } else if phase.error != nil {
                                        Color.red
                                    } else {
                                        Color.blue
                                    }
                                    
                                    
                                }
                                .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
                                .overlay(
                                    ZStack{
                                        if !store.isPro() && wallpaper.content_type == "private"{
                                            HStack(spacing : 2){
                                                Image("coin")
                                                    .resizable()
                                                    .frame(width: 10, height: 10, alignment: .center)
                                                Text("\(wallpaper.cost )")
                                                    .mfont(10, .regular)
                                                    .foregroundColor(.white)
                                                    .offset(y : -1)
                                            }.frame(width: 28, height: 16, alignment: .center)
                                                .background(
                                                    Capsule()
                                                        .fill(Color.black.opacity(0.7))
                                                )
                                                .padding(8)
                                            
                                        }
                                    }
                                    
                                    , alignment: .topTrailing
                                )
                                .overlay(
                                    ZStack{
                                        if wallpaper.type == "video"{
                                            Image(systemName : "play.circle")
                                                .resizable()
                                                .foregroundColor(.white)
                                                .frame(width: 32, height: 32, alignment: .center)
                                        }
                                    }
                                )
                            })
                            .cornerRadius(2)
                        }
                    })
                    .padding(16)
                }
            }
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .addBackground()
            .onAppear(perform: {
                if !store.isPro(){
                    interAd.showAd(onCommit: {})
                }
            })
    }
}


struct FavWallpaperDetailView: View {
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @EnvironmentObject  var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    
    @Environment(\.dismiss) var dismiss
    let wallpaper : FavoriteWallpaper
    var body: some View {
        ZStack(alignment: .top){
            AsyncImage(url: URL(string: wallpaper.url ?? "")){
                phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: getRect().width, height: getRect().height)
                        .clipped()

                } else if phase.error != nil {
                    AsyncImage(url: URL(string: wallpaper.url ?? "")){
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
                        .frame(width: 80, height: 80)
                }


            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all )
            
            .onTapGesture {
                ctrlViewModel.showControll.toggle()
            }
            
            if ctrlViewModel.showControll{
                ControllView()
            }
            
            if ctrlViewModel.showPreview {
                Preview()
            }
            
            if ctrlViewModel.showDialogRV{
                if let urlStr = wallpaper.preview_url{
                   DialogGetWL(urlStr: urlStr)
                }
                
            }
            
            if ctrlViewModel.showDialogBuyCoin{
                if let urlStr = wallpaper.preview_url{
                  DialogGetWLByCoin(urlStr: urlStr)
                }
               
            }
           
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("", displayMode: .inline)
         .navigationBarHidden(true)
         .sheet(isPresented: $ctrlViewModel.showTutorial, content: {
             TutorialContentView()
         })
         .onAppear(perform: {
             if !store.isPro(){
                 interAd.showAd(onCommit: {})
             }
         })
    }
    
    
    @ViewBuilder
    func ControllView() -> some View{
        VStack(spacing : 0){
            HStack{
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
                    if !store.isPro() && wallpaper.content_type == "private" {
                        HStack(spacing : 0){
                            Image("coin")
                                .resizable()
                                .frame(width: 13, height: 13)
                            Text(" \(wallpaper.cost )")
                                .mfont(13, .regular)
                                .foregroundColor(.white)

                        }.frame(width: 38, height: 20)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.7))
                            )
                          
                    }
                }.frame(width: 28, height: 16)
               
                
                Button(action: {
                    ctrlViewModel.showTutorial.toggle()
                }, label: {
                    Image( "help")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .frame(width: 64, height: 44)
                        .contentShape(Rectangle())
                })
                
                
                
             
                
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44 )
          
          
            

            
            Spacer()
            
            HStack{
                Button(action: {
                   
                    if !favViewModel.isFavorite(id: Int(wallpaper.wl_id)) {
                      
                        favViewModel.addFavoriteWLToCoreData(id: Int(wallpaper.wl_id ) ,
                                                             preview_url: wallpaper.preview_url ?? "",
                                                             url: wallpaper.url ?? "",
                                                             type:  "image",
                                                             contentType: wallpaper.content_type ?? "",
                                                             cost: Int(wallpaper.cost))
                    }else{
                        favViewModel.deleteFavWL(id: Int(wallpaper.wl_id))
                    }
                    
                    
                }, label: {
                    Image( favViewModel.isFavorite(id: Int(wallpaper.wl_id)) ? "heart.fill" : "heart")
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
                        .containerShape(Circle())
                }) .frame(width: 48, height: 48)
                
                
                Button(action: {
                  
                    
                    if store.isPro(){
                        downloadImageToGallery(title: "image\(wallpaper.id)", urlStr: wallpaper.url ?? "")
                        ServerHelper.sendImageDataToServer(type: "set", id: Int(wallpaper.wl_id))
                    }else{
                        
                  
                        
                        if wallpaper.content_type == "free" {
                            withAnimation{
                                ctrlViewModel.showDialogRV.toggle()
                            }
                        }else{
                            withAnimation{
                                ctrlViewModel.showDialogBuyCoin.toggle()
                            }
                        }
                    }
                 
                    
                   
                
                    
                 
                }, label: {
                    Text("Save")
                        .mfont(16, .bold)
                        .foregroundColor(.mblack_fg)
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
        .padding(.top, getSafeArea().top)
        .padding(.bottom, getSafeArea().bottom)
    }
    
    @ViewBuilder
    func Preview() -> some View{
        TabView(selection: $ctrlViewModel.isHome){

            Image("preview_lock")
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
                    downloadImageToGallery(title: "image\(wallpaper.wl_id)", urlStr: wallpaper.url ?? "")
                    ServerHelper.sendImageDataToServer(type: "set", id: Int(wallpaper.wl_id))
           
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
        BuyWithCoinDialog(urlStr: urlStr, coin: Int(wallpaper.cost) ,show: $ctrlViewModel.showDialogBuyCoin, onBuyWithCoin: {
            ctrlViewModel.showDialogBuyCoin.toggle()
            if currentCoin >= Int(( wallpaper.cost  )){
                currentCoin = currentCoin - Int(( wallpaper.cost  ))
                DispatchQueue.main.async{
                    downloadImageToGallery(title: "image\(wallpaper.id)", urlStr: wallpaper.url ?? "")
              
                    ServerHelper.sendImageDataToServer(type: "set", id: Int(wallpaper.wl_id))
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
        
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url {
                DownloadFileHelper.saveImageToLibFromURLSanbox(url: url, onComplete: {
                    success in
                    if success{
                        showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                    }else{
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure")
                    }
                })
            }else{
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure")
            }
        })
        
      
    }
  
   
}


struct FavLiveWallpaperDetailView : View{
    @StateObject var ctrlViewModel : ControllViewModel = .init()
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var reward : RewardAd
    @Environment(\.presentationMode)var presentationMode
    let wallpaper : FavoriteWallpaper
    @State var player : AVPlayer?
    @AppStorage("current_coin", store: .standard) var currentCoin = 0
    var body: some View{
        
        ZStack{
            if player != nil{
                MyVideoPlayer(player: player!)
                    .ignoresSafeArea()
                    .onTapGesture {
                        ctrlViewModel.showControll.toggle()
                    }
                    
            }
            
            
            if ctrlViewModel.showControll{
                VStack(spacing : 0){
                    HStack(spacing : 0){
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("back")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .frame(width: 64, height: 44)
                                .contentShape(Rectangle())
                        })
                       
                        
                        Spacer()
                        Button(action: {
                            ctrlViewModel.showTutorial.toggle()
                        }, label: {
                            Image("help")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .frame(width: 64, height: 44)
                                .containerShape(Rectangle())
                        })
                            HStack(spacing : 0){
                                Image("coin")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                Text(" \(wallpaper.cost)")
                                    .mfont(10, .regular)
                                    .foregroundColor(.white)
                                  
                                
                                
                                
                            }.frame(width: 28, height: 16)
                            
                                .background(
                                    Capsule()
                                        .fill(Color.black.opacity(0.7))
                                )
                                .padding(.horizontal, 16)
                      
                    }.frame(maxWidth: .infinity)
                        .frame(height: 44)
                       
                        
                    Spacer()
                     
                    HStack{
                        Button(action: {
                         
                            if favViewModel.isFavorite(id: Int(wallpaper.wl_id)) {
                                favViewModel.deleteFavWL(id: Int(wallpaper.wl_id))
                                }else{
                                    favViewModel.addFavoriteWLToCoreData(id: Int(wallpaper.wl_id),
                                                                         preview_url: wallpaper.preview_url ?? "",
                                                                         url: wallpaper.url ?? "",
                                                                         type: "video",
                                                                         contentType: "private",
                                                                         cost: Int(wallpaper.cost))
                                }
                          
                        }, label: {
                            Image( favViewModel.isFavorite(id: Int(wallpaper.wl_id)) ? "heart.fill" : "heart")
                                .resizable()
                                .foregroundColor(.white)
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .containerShape(Circle())
                                .background(
                                    Circle()
                                        .fill(Color.mblack_bg.opacity(0.7))
                                        .frame(width: 48, height: 48)
                                )
                              
                        }) .frame(width: 48, height: 48)
                            
                        
                        
                        Button(action: {
                            if store.isPro(){
                                downloadVideoToGallery( title : "video\(wallpaper.wl_id)" , urlVideoStr: wallpaper.url ?? "" , urlImageStr: wallpaper.preview_url ?? "")
                                
                            
                            }else{
                                withAnimation{
                                    ctrlViewModel.showDialogBuyCoin.toggle()
                                }
                            }
                          
                            
                           
                        }, label: {
                            Text("Save")
                                .mfont(16, .bold)
                                .foregroundColor(.mblack_fg)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
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
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                   
                    
            }

            if ctrlViewModel.showPreview{
                TabView(selection: $ctrlViewModel.isHome){
                    
                    Image("preview_lock")
                        .resizable()
                        .scaledToFill()
                    
                        .onTapGesture {
                            withAnimation{
                                ctrlViewModel.showPreview = false
                            
                                
                            }
                            
                        }.tag(true)
                    
                    
                    Image("preview_home")
                        .resizable()
                        .scaledToFill()
                        .onTapGesture {
                            withAnimation{
                                ctrlViewModel.showPreview = false
                             
                                
                            }
                            
                        }.tag(false)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .background{
                    Color.clear
                }
                .ignoresSafeArea()
            }
            
        }.onAppear(perform: {
            player = AVPlayer(url: URL(string: wallpaper.url ?? "")!)
            if player != nil {
                player!.play()
            }
        })
        .onDisappear(perform: {
            if player != nil{
                player!.pause()
                player!.cancelPendingPrerolls()
                player = nil
                
            }
        })
        
    }
    
    func downloadVideoToGallery(title : String, urlVideoStr : String, urlImageStr : String){
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask? = nil
        DispatchQueue.global(qos: .background).async {
            let imgURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageDownloaded")
            if let url = URL(string: urlImageStr) {
                let filePath = imgURL.appendingPathComponent("\(title).jpg")
                dataTask = defaultSession.dataTask(with: url, completionHandler: {  data, res, err in
                    DispatchQueue.main.async {
                        do {
                            try data?.write(to: filePath)
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: filePath)
                            }) { completed, error in
                                if completed {
                                    //MARK : download image successfull, download image
                                    downloadVideo(title: title, urlVideoStr: urlVideoStr, urlFilePathImage: filePath)
                                    
                                } else if let error = error {
                                    print(error.localizedDescription)
                                    
                                }
                            }
                        } catch {
                            
                            print(error.localizedDescription)
                        }
                    }
                    dataTask = nil
                })
                dataTask?.resume()
            }
        }
    }
    
    func downloadVideo(title : String, urlVideoStr : String, urlFilePathImage : URL){
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask? = nil
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlVideoStr) {
                let videoDirectoryURL  =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("VideoDownloaded")
                let filePath = videoDirectoryURL.appendingPathComponent("\(title).mov")
                dataTask = defaultSession.dataTask(with: url, completionHandler: {  data, res, err in
                    DispatchQueue.main.async {
                        do {
                            try data?.write(to: filePath)
                            
                            LivePhoto.generate(from: urlFilePathImage, videoURL: filePath, progress: {
                                _ in
                            }, completion: {_,resources in
                                if resources != nil{
                                    LivePhoto.saveToLibrary(resources!, completion: {
                                        b in
                                        if b{
                                            DispatchQueue.main.async {
                                                showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                                            }
                                        }else{
                                            showToastWithContent(image: "xmark", color: .red, mess:"failure")
                                        }
                                    })
                                }
                                
                            })
                            
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
}
