//
//  WatchRVGetCoindAndBuySubDialog.swift
//  WallpaperIOS
//
//  Created by Mac on 12/06/2023.
//

import SwiftUI

struct WatchRVGetCoindAndBuySubDialog: View {
    
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    let reward : RewardAd
    @State var isAnimating : Bool = false
    @Binding var show : Bool
    var clickBuyPro : () -> ()
    
    @State private var timeRemaining = UserDefaults.standard.integer(forKey: "delay_reward")
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            
            VStack(spacing : 0){
                
                HStack{
                    Button(action: {
                        show.toggle()
                    }, label: {
                        Image("close.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            
                    })
                }.frame(maxWidth: .infinity, alignment: .trailing)
                    .padding([.top, .trailing], 8)
                
                Text("Become PRO to download wallpapers without Ecoins and ADs!")
                    .multilineTextAlignment(.center)
                    .mfont(17, .bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
               
                VStack(spacing : 16){
                    Button(action: {
                        reward.presentRewardedVideo(onCommit: { b in
                            if b {
                                currentCoin = currentCoin + 1
                                showToastWithContent(image: "checkmark", color: .green, mess: "You have received 1 Ecoin!")
                                show = true
                                timeRemaining = UserDefaults.standard.integer(forKey: "delay_reward")
                            }else{
                                show = false
                                showToastWithContent(image: "xmark", color: .red, mess: "Ads is not ready!")
                            }
                        })
                        Flurry_log("Watch_RV_get_coin")
                    }, label: {
                        HStack{
                           ZStack{
                               if timeRemaining > 0 {
                                   Text("\(timeRemaining)")
                                       .mfont(16, .bold)
                                       .foregroundColor(.white)
                               }else{
                                   Image("play")
                                       .resizable()
                                       .foregroundColor(.white)
                                       .frame(width: 26.67, height: 26.67)
                               }
                            }
                           .frame(width: 26.67, height: 26.67)
                           .onReceive(timer) { time in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                }
                            }
                           
                            
                            VStack{
                                Text("Continue to watch ads")
                                    .mfont(17, .bold)
                                    .foregroundColor(timeRemaining > 0 ? .gray : .white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                HStack(spacing : 0){
                                    Text("to get 1 Ecoin.")
                                        .mfont(13, .regular)
                                        .foregroundColor(timeRemaining > 0 ? .gray : .white)
//
                                }
                               
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
                                    Capsule()
                                     .stroke(  timeRemaining > 0 ? .gray : .white, lineWidth: 1)
                                }
                              
                            )
                            .padding(.horizontal, 20)
                    })
                    .disabled( timeRemaining != 0 )
                    
                    
                    Button(action: {
                        Flurry_log("Sub_click_in_dialog_get_coin")
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
                    
                    
                    HStack(spacing : 0){
                        Text("Your Ecoins: ")
                            .mfont(15,  .regular)
                            .foregroundColor(.white)
                        Image("coin")
                            .resizable()
                            .frame(width: 13.33, height: 13.33)
                        Text(" \(UserDefaults.standard.integer(forKey: "current_coin"))")
                            .mfont(15,  .bold)
                            .foregroundColor(.white)
                        
                    }.padding(.bottom , 24)
                    
                    
                }
                .padding(.top, 24)
                
            }.frame(maxWidth: .infinity)
              
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                )
                .padding(.horizontal, 38)
        }
        
      
        
    }
}

//struct WatchRVGetCoindAndBuySubDialog_Previews: PreviewProvider {
//    static var previews: some View {
//        WatchRVGetCoindAndBuySubDialog( show: .constant(true))
//    }
//}
