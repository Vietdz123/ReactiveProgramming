//
//  BuyCoinView.swift
//  WallpaperIOS
//
//  Created by Mac on 19/06/2023.
//

import SwiftUI

struct BuyCoinView: View {
    
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var reward : RewardAd
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    
    @AppStorage("pack_1_coin", store: .standard) var pack1Coin : Int = 20
    @AppStorage("pack_2_coin", store: .standard) var pack2Coin : Int = 50
    @AppStorage("pack_3_coin", store: .standard) var pack3Coin : Int = 150
    var body: some View {
        VStack{
            HStack(spacing : 0){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("close.circle.fill")
                        .resizable()
                        .foregroundColor(.black.opacity(0.7))
                        .frame(width: 24, height: 24)
                })
                
                Spacer()
                HStack(spacing : 6){
                    Image("coin")
                        .resizable()
                        .frame(width: 13.33, height: 13.33)
                    Text("\(currentCoin)")
                        .mfont(13, .bold)
                        .foregroundColor(.white)
                    
                    
                }.frame(width: 42, height: 20)
                    .background(
                        Capsule().fill(Color.white.opacity(0.3))
                    )
                    .overlay(
                        Circle()
                            .fill(Color.main)
                            .frame(width: 4, height: 4), alignment: .topTrailing
                    )
                  
                
            }.frame(height: 40)
                .padding(.horizontal, 16)
            
            VStack(spacing : 0){
                    Text("Ecoin unlock Premium content.")
                    .mfont(15, .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Buy them or see below for ways to get for FREE by watching ads.")
                    .mfont(15, .regular)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
            }.frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .frame(height: 95)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.white.opacity(0.1))
                )
                .padding(.horizontal, 16)

            
            Text("FREE ECOIN")
                .mfont(13, .regular)
                .foregroundColor(.white)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            HStack(spacing : 0) {
                VStack(spacing : 2){
                    Text("Simply watch ads to")
                        .mfont(15, .bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("get 1 Ecoin")
                        .mfont(15, .bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                
                Button(action: {
                    reward.presentRewardedVideo(onCommit: { b in
                        if b {
                            currentCoin = currentCoin + 1
                           
                            showToastWithContent(image: "checkmark", color: .green, mess: "You have received 1 Ecoin!")
                            
                        }else{
                        
                            showToastWithContent(image: "xmark", color: .red, mess: "Ads is not ready!")
                        }
                    })
                    
               
                }, label: {
                    Text("Watch")
                        .mfont(17, .bold)
                        .foregroundColor(.black)
                        .frame(width: 80, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.main)
                        )
                })
                
            }.frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .frame(height: 64)
                .background(
                    RoundedRectangle(cornerRadius:  16, style: .continuous)
                        .stroke(Color.white, lineWidth: 1)
                
                ) .padding(.horizontal, 16)
            
            
            
            Text("BUY ECOIN")
                .mfont(13, .regular)
                .foregroundColor(.white)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            if let pack1 = store.coin_product_1 {
                Button(action: {
                    
               
                    Firebase_log("Sub_click_buy_coin_pack_1")
                   
                        store.purchase(product: pack1, onBuySuccess: { b in
                            if b {
                                DispatchQueue.main.async{
                                    showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                    
                                }
                               
                            }else{
                                DispatchQueue.main.async{
                                    showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                }
                            }
                            
                        })
                   
                   
                }, label: {
                    HStack(spacing : 0){
                        VStack(spacing : 0){
                            Text("\(pack1Coin)")
                                .foregroundColor(.white)
                                .mfont(20, .bold)
                            Text("Ecoin")
                                .foregroundColor(.white)
                                .mfont(13, .bold)
                        }.padding(.leading, 16)
                            .padding(.trailing, 32)
                        HStack{
                            Image("coin")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pack1.displayPrice)")
                            .mfont(15, .bold)
                            .foregroundColor(.white)
                            .frame(width: 96, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("green"))
                            )
                            .padding(.trailing, 16)
                    }
                
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 64)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(colors: [Color("g1"), Color("g2"), Color("g3")], startPoint: .leading, endPoint: .trailing)
                        )
                )
                .padding(.horizontal, 16)
            }
            
         
            
            
            ///////////////
            if let pack2 = store.coin_product_2 {
                
                Button(action: {
                 
                    Firebase_log("Sub_click_buy_coin_pack_2")
                   
                        store.purchase(product: pack2, onBuySuccess: { b in
                            if b {
                                DispatchQueue.main.async{
                                    showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                    
                                }
                               
                            }else{
                                DispatchQueue.main.async{
                                    showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                }
                            }
                            
                        })
                   
                   
                }, label: {
                    HStack(spacing : 0){
                        VStack(spacing : 0){
                            Text("\(pack2Coin)")
                                .foregroundColor(.white)
                                .mfont(20, .bold)
                            Text("Ecoin")
                                .foregroundColor(.white)
                                .mfont(13, .bold)
                        }.padding(.leading, 16)
                            .padding(.trailing, 32)
                        HStack{
                            Image("coin")
                                .resizable()
                                .frame(width: 28, height: 28)
                            
                            Image("gold")
                                .resizable()
                                .frame(width: 34, height: 28)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pack2.displayPrice)")
                            .mfont(15, .bold)
                            .foregroundColor(.white)
                            .frame(width: 96, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("green"))
                            )
                            .padding(.trailing, 16)
                    }
                
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 64)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(colors: [Color("g1"), Color("g2"), Color("g3")], startPoint: .leading, endPoint: .trailing)
                        )
                )
                .padding(.horizontal, 16).padding(.top, 8)
            }
         
            
            if let pack3 = store.coin_product_3 {
                Button(action: {
               
                    Firebase_log("Sub_click_buy_coin_pack_3")
                 
                        store.purchase(product: pack3, onBuySuccess: { b in
                            if b {
                                DispatchQueue.main.async{
                                    showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                  
                                }
                               
                            }else{
                                DispatchQueue.main.async{
                                    showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                }
                            }
                            
                        })
                  
                   
                }, label: {
                    HStack(spacing : 0){
                        VStack(spacing : 0){
                            Text("\(pack3Coin)")
                                .foregroundColor(.white)
                                .mfont(20, .bold)
                            Text("Ecoin")
                                .foregroundColor(.white)
                                .mfont(13, .bold)
                            
                            
                        }.padding(.leading, 16)
                            .padding(.trailing, 32)
                        HStack{
                            Image("coin")
                                .resizable()
                                .frame(width: 28, height: 28)
                            
                            Image("gold2")
                                .resizable()
                                .frame(width: 49, height: 30)
                            
                            Image("gold")
                                .resizable()
                                .frame(width: 34, height: 28)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pack3.displayPrice)")
                            .mfont(15, .bold)
                            .foregroundColor(.white)
                            .frame(width: 96, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("green"))
                            )
                            .padding(.trailing, 16)
                    }
                
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 64)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(colors: [Color("g1"), Color("g2"), Color("g3")], startPoint: .leading, endPoint: .trailing)
                        )
                )
                .padding(.horizontal, 16).padding(.top, 8)
            }
            
     
            
            
            Text("BECOME WALLIVE PRO")
                .mfont(13, .regular)
                .foregroundColor(.white)
                .padding(.top, 16)
                .padding(.bottom, 8)
            
            
            NavigationLink(destination: {
                SubcriptionVIew()
                    .environmentObject(store)
            }, label: {
                HStack(spacing : 0) {
                 ResizableLottieView(filename: "star")
                        .frame(width: 28, height: 28)
                    
                    Text("Unlock all Features")
                        .mfont(20, .bold)
                        .foregroundColor(.black)
                        .padding(.leading, 24)
                        
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .frame(height: 64)
                    .background(
                        RoundedRectangle(cornerRadius:  16, style: .continuous)
                            .fill(Color.main)
                    
                    ) .padding(.horizontal, 16)
            })
           
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .addBackground()
            .onAppear(perform: {
             
                Firebase_log("Buy_coin_view_show_total")
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if store.showBanner {
                        store.showBanner = false
                    }
                    
                })
                
            })
            .onDisappear(perform: {
                if !store.showBanner {
                    store.showBanner = true
                }
            })
    }
}

struct BuyCoinView_Previews: PreviewProvider {
    static var previews: some View {
        BuyCoinView()
    }
}
