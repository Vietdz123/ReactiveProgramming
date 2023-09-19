//
//  GetWallpaperDialog.swift
//  WallpaperIOS
//
//  Created by Mac on 23/05/2023.
//

import SwiftUI

struct WatchRVtoGetWLDialog: View {
    @State var isAnimating : Bool = false
    let urlStr : String
    @Binding var show : Bool
    let width : CGFloat = UIScreen.main.bounds.width - 56
    let height : CGFloat =  UIScreen.main.bounds.width * 1.2
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    var onRewarded :  (Bool) -> ()
    var clickBuyPro : () -> ()
    
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                   
                    withAnimation{
                       
                        show.toggle()
                    }
                }
            AsyncImage(url: URL(string: urlStr)){
                phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipped()
                } else if phase.error != nil {
                    Color.red
                } else {
                    Color.blue
                }
            }
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                VStack(spacing : 16){
                    Button(action: {
                        
                        reward.presentRewardedVideo(onCommit: onRewarded)
                       
                    }, label: {
                        HStack{
                            VStack(spacing : 0){
                                Image("play")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 26.67, height: 26.67)
                            }
                           
                            
                            VStack{
                                Text("Watch a short video")
                                    .mfont(17, .bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                              
                                Text("to save this wallpaper")
                                    .mfont(13, .regular)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 14.67)
                              
                          
                           
                        }.frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 0, leading: 26.67, bottom: 0, trailing: 0))
                            .frame(height: 56)
                            .background(
                                ZStack{
                                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                                        .clipShape(Capsule())
//                                    Capsule()
//                                        .fill(Color.black.opacity(0.4))
                                    Capsule()
                                     .stroke(Color.white, lineWidth: 1)
                                }
                              
                            )
                            .padding(.horizontal, 20)
                    })
                    
                    
                    
                    Button(action: {
                        
                        clickBuyPro()
                    }, label: {
                        HStack{
                            
                            ResizableLottieView(filename: "star")
                                .frame(width: 32, height: 32)
                            
                            Text("Unlock all Features")
                                .mfont(16, .bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 14.67)
                            
                            
                            
                        }.frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 0, leading: 26.67, bottom: 0, trailing: 0))
                            .frame(height: 56)
                            .background(
                                ZStack{
                                   
                                    LinearGradient(gradient: Gradient(colors:[  Color.colorOrange , Color.main]),
                                                   startPoint: isAnimating ? .trailing : .leading,
                                                   endPoint: .leading)
                                    .frame(height: 56)
                                
                                    .onAppear() {
                                        DispatchQueue.main.async{
                                            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)){
                                                isAnimating.toggle()
                                            }
                                        }
                                    }
                                }.frame(height: 56)
                                    .clipShape(Capsule())
                            )
                            .padding(.horizontal, 20)
                    })
                    .padding(.bottom , 24)
                }, alignment: .bottom
            )
            .overlay(
                Button(action: {
                    
                    withAnimation{
                        show.toggle()
                    }
                    
                }, label: {
                    Image("close.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                .padding(.all, 8)
                , alignment: .topTrailing
            )
            
            
            
        }
    }
}
