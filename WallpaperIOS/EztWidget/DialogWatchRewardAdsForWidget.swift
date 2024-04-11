//
//  DialogWatchRewardAdsForWidget.swift
//  WallpaperIOS
//
//  Created by Duc on 19/02/2024.
//

import SwiftUI
import Lottie

struct DialogWatchRewardAdsForWidget: View {
    @State var isAnimating : Bool = false
    let urlStr : String
    @Binding var show : Bool
    let width : CGFloat = UIScreen.main.bounds.width - 56
   
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
            VStack(spacing : 0){
                HStack{
                    Spacer()
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
                }
               
                ZStack{
                    if let url = URL(string: urlStr ){
                        LottieView {
                            await LottieAnimation.loadedFrom(url: url )
                        }
                            .looping()
                            .resizable()
                            .scaledToFill()
                            .frame(width: width - 32, height: ( width - 32 ) / 2.2 )
                            .overlay{
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.4), lineWidth : 1)
                            }
                        
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                    }else{
                        Color.red
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                    }
                }.frame(width: width - 32, height: ( width - 32 ) / 2.2 )
                    .padding(.bottom, 24)
                    .padding(.top, 12)
                
               
                
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
                          
                            Text("to save this widget")
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
                .padding(.top, 16)
                
                
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
                })   .padding(.top, 16)
                    .padding(.bottom, 32)
                
            }
            .frame(width: width)
            .background(Color(red: 0.13, green: 0.14, blue: 0.13).opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            
            
            
            
        }
    }
}

#Preview {
    ZStack{
        Color.blue.ignoresSafeArea()
        DialogWatchRewardAdsForWidget(urlStr: "", show: .constant(true), onRewarded: {_ in 
            
        }, clickBuyPro: {
            
        })
        
    }
   
}
