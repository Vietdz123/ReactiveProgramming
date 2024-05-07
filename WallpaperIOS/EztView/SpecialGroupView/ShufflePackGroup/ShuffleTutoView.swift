//
//  ShuffleTutoView.swift
//  WallpaperIOS
//
//  Created by Mac on 11/08/2023.
//

import SwiftUI
import AVKit

struct ShuffleTutoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var avPlayer : AVPlayer = AVPlayer(url:  Bundle.main.url(forResource: "shuffle_tuto", withExtension: "mp4")!)
    
    var body: some View {
        VStack(spacing : 0){
            HStack(spacing : 0){
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("back")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .containerShape(Rectangle())
                })
                Text("Shuffle Lockscreen")
                    .foregroundColor(.white)
                    .mfont(20, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
                
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            ZStack{
                VideoPlayerView(player: $avPlayer)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .addBackground()
            .onAppear(perform: {
                
             
                
                avPlayer.play()
                avPlayer.isMuted = true
            })
            .onDisappear(perform : {
                avPlayer.pause()
                UserDefaults.standard.set(true, forKey: "shuffle_tuto")
            })
    }
}



struct VideoPlayerView: UIViewControllerRepresentable {
    @Binding var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        player.isMuted = true
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
      
    }
}
