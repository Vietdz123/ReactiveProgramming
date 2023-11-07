//
//  SplashScreenView.swift
//  WallpaperIOS
//
//  Created by Mac on 24/05/2023.
//

import SwiftUI
import AVKit

struct SplashScreenView: View {
    @State var player : AVPlayer?
    
    var body: some View {
        ZStack{
            if let player {
                MyVideoPlayer(player: player)
                    .ignoresSafeArea()
            }
            
            VStack(spacing : 24){
                Image("logo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.main, lineWidth: 2)
                    )
                
                Image("wallive")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 115, height: 67)
                
            TextTypingAnimView(text: "Starting your wonderful journey...",color : .white ,fontSize: 17, weight: .italic)
             
                    .padding(.top ,93)
                            
               
               
            }
            
        }
//        .overlay(

//            
//            , alignment: .bottom
//        )
        .onAppear(perform: {
                player = AVPlayer(url:  Bundle.main.url(forResource: "bg", withExtension: "mp4")!)
                player!.play()
            })
            .onDisappear(perform: {
                player!.pause()
                player = nil
            })
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
