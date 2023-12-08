//
//  VideoListView.swift
//  WallpaperIOS
//
//  Created by Mac on 22/05/2023.


import SwiftUI
import AVKit
import AVFoundation
import Photos
import PhotosUI

class VideoControllViewModel : ObservableObject {
    @Published var navigateView : Bool = false
    
    @Published var showControll : Bool = true
    @Published var showTuto : Bool = false
    @Published var showInfo : Bool = false
    @Published var showDialogDownload : Bool = false
    @Published var showPreview : Bool = false
    @Published var isHome : Bool = true
    
    @Published var isDownloading : Bool = false
}

struct VideoListView: View {
    let generator = UINotificationFeedbackGenerator()
    @EnvironmentObject var viewModel  : LiveWallpaperViewModel
    @EnvironmentObject var store : MyStore
  
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var inter : InterstitialAdLoader
    @AppStorage("current_coin", store: .standard) var currentCoin = 0
    //@AppStorage("first_time_video_wl", store: .standard) var firsttimeliveWL : Bool = true
    @State var firsttimeliveWL : Bool = false
    @State var currentIndex : Int = 0
    @StateObject var ctrlViewModel : VideoControllViewModel = .init()
    
    
    @Binding var showBottomBar : Bool
    
    var body: some View {
        GeometryReader{
            proxy in
            let size = proxy.size
            
            
            
            ZStack{
                NavigationLink(isActive: $ctrlViewModel.navigateView, destination: {
                    EztSubcriptionView()
                        .environmentObject(store)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                }, label: {
                    EmptyView()
                })
                
                if !viewModel.liveWallpapers.isEmpty{
                 
                        TabView(selection: $currentIndex){
                            
                            ForEach(0..<viewModel.liveWallpapers.count, id: \.self){
                                i in
                                let livewallpaper = viewModel.liveWallpapers[i]
                                ReelsPlayer( i: i, liveWL: livewallpaper, currentIndex: $currentIndex)
                                    .frame(width: size.width)
                                    .rotationEffect(.init(degrees: -90))
                                    .ignoresSafeArea(.all, edges: .top)
                                    .tag(i)
                                    .onAppear(perform: {
                                        
                                        
                                        generator.notificationOccurred(.success)
                                        
                                        if viewModel.shouldLoadData(id: i){
                                            viewModel.getDataByPage()
                                        }
                                        
                                        if !store.isPro(){
                                            inter.showAd(onCommit: {})
                                        }
                                        
                                    })
                                
                                
                            }
                            
                        }
                        .rotationEffect(.init(degrees: 90))
                        .frame(width: size.height)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(width: size.width)
                        .onTapGesture {
                            ctrlViewModel.showControll.toggle()
                        }

                    if ctrlViewModel.showControll{
                        VStack(spacing : 0){
                            HStack(spacing : 0){
                              
                                Button(action: {
                                    ctrlViewModel.showTuto.toggle()
                                }, label: {
                                    Image("help")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .containerShape(Rectangle())
                                })
                                .padding(.leading, 16)
                            
                                Spacer()
                           
//                                if !store.isPro() {
//                                //    if let liveWL = viewModel.liveWallpapers[currentIndex] {
//                                        HStack(spacing : 0){
//                                            Image("coin")
//                                                .resizable()
//                                                .frame(width: 13, height: 13)
//                                            Text(" \(viewModel.liveWallpapers[currentIndex].cost ?? 0)")
//                                                .coinfont(13, .regular)
//                                                .foregroundColor(.white)
//                                            
//                                            
//                                            
//                                            
//                                        }.frame(width: 38, height: 20)
//                                        
//                                            .background(
//                                                Capsule()
//                                                    .fill(Color.black.opacity(0.7))
//                                            )
//                                            .padding(.trailing, 16)
//                                  //  }
//                                }
                             
                            }.frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .padding(.top, getSafeArea().top)
                            Spacer()
                            
                            HStack{
                                Button(action: {
                                    let wallpaper = viewModel.liveWallpapers[currentIndex]
                                   
                                    
                                }, label: {
                                    Image( "heart")
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
                                    
                                }) .frame(width: 48, height: 48)
                                
                                
                                
                                Button(action: {
                                    if store.isPro(){
                                        downloadVideoToGallery( title : "video\(  viewModel.liveWallpapers[currentIndex].id)" ,
                                                                urlVideoStr:  viewModel.liveWallpapers[currentIndex].video_variations.adapted.url,
                                                                urlImageStr: viewModel.liveWallpapers[currentIndex].image_variations.adapted.url.replacingOccurrences(of: "\"", with: ""))
                                        ServerHelper.sendVideoDataToServer(type: "set", id: viewModel.liveWallpapers[currentIndex].id)
                                      
                                        
                                    }else{
                                     
                                            withAnimation{
                                                ctrlViewModel.showDialogDownload.toggle()
                                            }
                                        
                                      
                                    }
                                    
                                    
                                    
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
                                        .background(
                                            Capsule().fill(Color.main)
                                        )
                                        .contentShape(Rectangle())
                                }).padding(.horizontal, 16)
                                
                                
                                Button(action: {
                                    withAnimation{
                                        showBottomBar = false
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
                            .padding(.bottom, ( store.isPro() ? 96 : 152 )  - getSafeArea().bottom)
                            
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
                                        showBottomBar = true
                                        
                                    }
                                    
                                }.tag(true)
                            
                            
                            Image("preview_home")
                                .resizable()
                                .scaledToFill()
                                .onTapGesture {
                                    withAnimation{
                                        ctrlViewModel.showPreview = false
                                        showBottomBar = true
                                        
                                    }
                                    
                                }.tag(false)
                            
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .background{
                            Color.clear
                        }
                        .ignoresSafeArea()
                    }
                    
                    if firsttimeliveWL {
       
                        ResizableLottieView(filename: "viewmore")
                            .frame(width: getRect().width - 60)
                            .onAppear(perform: {
                                ctrlViewModel.showControll = false
                                
                                
                            })
                            .onDisappear(perform: {
                                ctrlViewModel.showControll = true
                                
                            })
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded({ value in
                                    
                                    if value.translation.height < 0 {
                                        firsttimeliveWL = false
                                    }
                                    
                                    if value.translation.height > 0 {
                                        firsttimeliveWL = false
                                    }
                                }))
                        
                    }
                    
                    
                    
                }
            }
            .onAppear(perform: {
                let firstTime = UserDefaults.standard.bool(forKey: "first_time_video_wl")
                if !firstTime {
                    UserDefaults.standard.set(true, forKey:  "first_time_video_wl")
                    firsttimeliveWL = true
                }
            })
            
            
            
            
        }.ignoresSafeArea(.all, edges: .top)
            .sheet(isPresented: $ctrlViewModel.showTuto, content: {
                TutorialContentView()
            })
//            .overlay{
//                if ctrlViewModel.showDialogDownload{
//                //    if let liveWL = viewModel.liveWallpapers[currentIndex] {
//                        BuyWithCoinDialog(urlStr: viewModel.liveWallpapers[currentIndex].image_variations.preview_small.url, coin: viewModel.liveWallpapers[currentIndex].cost ?? 0,
//                                          show: $ctrlViewModel.showDialogDownload,
//                                          onBuyWithCoin: {
//                            ctrlViewModel.showDialogDownload.toggle()
//                            if currentCoin >= ( viewModel.liveWallpapers[currentIndex].cost ?? 0  ){
//                                currentCoin = currentCoin - ( viewModel.liveWallpapers[currentIndex].cost ?? 0  )
//                              
//                                downloadVideoToGallery( title : "video\(  viewModel.liveWallpapers[currentIndex].id)" ,
//                                                        urlVideoStr:  viewModel.liveWallpapers[currentIndex].video_variations.adapted.url,
//                                                        urlImageStr: viewModel.liveWallpapers[currentIndex].image_variations.adapted.url.replacingOccurrences(of: "\"", with: ""))
//                             
//                                ServerHelper.sendVideoDataToServer(type: "set", id: viewModel.liveWallpapers[currentIndex].id)
//                                
//                            }else{
//                                showToastWithContent(image: "xmark", color: .red, mess: "Not enough coins!")
//                            }
//                        }, onBuyPro: {
//                            ctrlViewModel.showDialogDownload.toggle()
//                            ctrlViewModel.navigateView.toggle()
//                        }).environmentObject(store)
//                            .environmentObject(reward)
//                 //   }
//                    
//                }
//                
//            }
            .onChange(of: ctrlViewModel.showControll, perform: {
                newValue in
                showBottomBar = newValue
            })
            
        
    }
    
    func downloadVideoToGallery(title : String, urlVideoStr : String, urlImageStr : String){
        
        DispatchQueue.main.async {
            ctrlViewModel.isDownloading = true
        }
        
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
                            DispatchQueue.main.async {
                                ctrlViewModel.isDownloading = false
                            }
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
                            
//                            LivePhoto.generate(from: urlFilePathImage, videoURL: filePath, progress: {
//                                _ in
//                            }, completion: {_,resources in
//                                if resources != nil{
//                                    LivePhoto.saveToLibrary(resources!, completion: {
//                                        b in
//                                        if b{
//                                            DispatchQueue.main.async {
//                                            
//                                                    ctrlViewModel.isDownloading = false
//                                                
//                                                showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
//                                                
//                                                if UserDefaults.standard.bool(forKey: "firsttime_showtuto") == false {
//                                                    UserDefaults.standard.set(true, forKey: "firsttime_showtuto")
//                                                    ctrlViewModel.showTuto = true
//                                                }
//                                                
//                                                let downloadCount = UserDefaults.standard.integer(forKey: "user_download_count")
//                                                UserDefaults.standard.set(downloadCount + 1, forKey: "user_download_count")
//                                                if !store.isPro() && downloadCount == 1 {
//                                                    ctrlViewModel.navigateView.toggle()
//                                                }else{
//                                                    showRateView()
//                                                }
//                                                
//                                            }
//                                        }else{
//                                            DispatchQueue.main.async {
//                                                ctrlViewModel.isDownloading = false
//                                                showToastWithContent(image: "xmark", color: .red, mess:"failure")
//                                            }
//                                           
//                                        }
//                                    })
//                                }
//                                
//                            })
                            
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

struct ReelsPlayer : View{
    
    let i : Int
    let liveWL : LiveWallpaper
    @Binding var currentIndex : Int
    @State var player : AVPlayer?
    
    var body: some View{
        ZStack{
            
            if  player != nil {
                MyVideoPlayer(player: player!)
                
                
                GeometryReader{
                    proxy -> Color in
                    
                    let minY  = proxy.frame(in: .global).minY
                    let size = proxy.size
                    
                    DispatchQueue.main.async {
                        if -minY < ( size.height / 2 ) && minY < (size.height / 2) && i == currentIndex {
                            if player != nil {
                                
                                player!.play()
                            }
                        }else{
                            if player != nil {
                                player!.pause()
                            }
                            
                        }
                    }
                    
                    return Color.clear
                }
                
            }
            
        }.onAppear(perform: {
            self.player =  AVPlayer(url: URL(string: liveWL.video_variations.adapted.url)!)
        })
        .onDisappear(perform: {
            if player != nil{
                self.player!.pause()
                self.player!.cancelPendingPrerolls()
                self.player = nil
            }
            
        })
        
    }
    
    
    
}

struct MyVideoPlayer : UIViewControllerRepresentable {
    var player : AVPlayer
    var aspect : AVLayerVideoGravity = .resizeAspectFill
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller  = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        player.isMuted  = true
       
        controller.videoGravity = aspect
        controller.disableGestureRecognition()
        controller.view.isUserInteractionEnabled = false
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(context.coordinator, selector: #selector(context.coordinator.restartPlayback), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
    class Coordinator : NSObject {
        var parent : MyVideoPlayer
        
        init(parent: MyVideoPlayer) {
            self.parent = parent
        }
        
        @objc func restartPlayback(){
            parent.player.seek(to: .zero)
        }
    }
}
extension AVPlayerViewController {
    func disableGestureRecognition() {
        let contentView = view.value(forKey: "contentView") as? UIView
        contentView?.gestureRecognizers = contentView?.gestureRecognizers?.filter { $0 is UITapGestureRecognizer }
    }
}
