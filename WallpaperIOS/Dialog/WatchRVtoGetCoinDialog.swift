//
//  WatchRVDialog.swift
//  WallpaperIOS
//
//  Created by Mac on 23/05/2023.
//

import SwiftUI



struct WatchRVtoGetCoinDialog: View {
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var reward : RewardAd
    @Binding var show : Bool
    @Binding var showDialog2 : Bool
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            
            VStack(spacing : 0){
                Text("Ecoin unlock Premium content.")
                    .mfont(17, .bold)
                    .foregroundColor(.white)
                Text("Buy them or get for FREE by")
                    .mfont(15, .regular)
                    .foregroundColor(.white)
                    .padding(.top, 4)
                Text("watching ads.")
                    .mfont(15, .regular)
                    .foregroundColor(.white)
                
                
                HStack(spacing : 16){
                    Button(action: {
   
                        reward.presentRewardedVideo(onCommit: { b in 
                            if b {
                                currentCoin = currentCoin + 1
                                show = false
                                showToastWithContent(image: "checkmark", color: .green, mess: "You have received 1 Ecoin!")
                                showDialog2 = true
                            }else{
                                show = false
                                showToastWithContent(image: "xmark", color: .red, mess: "Ads is not ready!")
                            }
                        })
                        
                    
                        
                    }, label: {
                        VStack{
                            Text("Watch ad")
                                .mfont(17, .bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    Capsule().fill(Color.main)

                                )
                            
                            HStack(spacing : 2){
                                Text("Get")
                                    .mfont(15, .bold)
                                    .foregroundColor(.white)
                                Image("coin")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text("1.")
                                    .mfont(15, .bold)
                                    .foregroundColor(.white)
                            }
                        }
                       
                    })
                    
                    NavigationLink(destination: {
                        BuyCoinView()
                            .environmentObject(store)
                            .environmentObject(reward)
                            
                    }, label: {
                        VStack{
                            
                            Text("Buy Ecoin")
                                .mfont(17, .bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    Capsule().fill(
                                        LinearGradient(colors: [Color("g1"), Color("g2"), Color("g3")], startPoint: .leading, endPoint: .trailing)
                                    )
                                )
                            HStack(spacing : 2){
                                Text("Get")
                                    .mfont(15, .bold)
                                    .foregroundColor(.white)
                                Image("coin")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text("1.")
                                    .mfont(15, .bold)
                                    .foregroundColor(.white)
                            }.opacity(0)
                        }
                    })
                }
                .padding(.top, 24)
                
            }.frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.1))
                )
                .overlay(
                Button(action: {
                    withAnimation{
                        show = false
                    }
                }, label: {
                    Image("close.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .opacity(0.7)
                    
                })
                .offset(x : 8, y: -8 )
                , alignment: .topTrailing
                )
                .padding(.horizontal, 38)
             
        }
        
      
        
    }
}
