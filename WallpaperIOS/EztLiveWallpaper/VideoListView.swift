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
    @Published var showGifView : Bool = false
    @Published var showSpeciaSub : Bool = false
    @Published var showControll : Bool = true
    @Published var showTuto : Bool = false
    @Published var showInfo : Bool = false
    @Published var showDialogDownload : Bool = false
    @Published var showPreview : Bool = false
    @Published var isHome : Bool = true
    @Published var showContentPremium : Bool = false
    @Published var isDownloading : Bool = false
    @Published var actionSelected : DetailWallpaperAction = .LOCK
    @Published var showRateView : Bool = false
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



struct ReelsPlayerVertical : View{
    
    let i : Int
    let liveWL : SpLiveWallpaper
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
            self.player =  AVPlayer(url: URL(string: liveWL.path.first?.url.full ?? "")!)
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


struct ReelsPlayerHorizontal : View{
    
    let i : Int
    let liveWL : SpLiveWallpaper
    @Binding var currentIndex : Int
    @State var player : AVPlayer?
    
    var body: some View{
        ZStack{
            
            if  player != nil {
                MyVideoPlayer(player: player!)
                
                
                GeometryReader{
                    proxy -> Color in
                    
                    let minX  = proxy.frame(in: .global).minX
                    let size = proxy.size
                    
                    DispatchQueue.main.async {
                        if -minX < ( size.width / 2 ) && minX < (size.width / 2) && i == currentIndex {
                            print("Video play: \(i)")
                            player?.play()
                        }else{
                            print("Video pause: \(i)")
                            player?.pause()
                           
                            
                        }
                    }
                    
                    return Color.clear
                }
                
            }
            
        }.onAppear(perform: {
            self.player =  AVPlayer(url: URL(string: liveWL.path.first?.url.full ?? "")!)
        })
        .onDisappear(perform: {
         
                self.player?.pause()
                self.player?.cancelPendingPrerolls()
                self.player = nil
         
            
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
