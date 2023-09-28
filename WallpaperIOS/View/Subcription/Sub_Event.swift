//
//  Sub_Event.swift
//  WallpaperIOS
//
//  Created by Duc on 25/09/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct Sub_Event: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store : MyStore
    
    
    @State private var showBtnClose : Bool = false
    
    var body: some View {
            VStack(spacing : 0){
                HStack{
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        ZStack{
                            if showBtnClose{
                                Image("close.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(0.7)
                            }
                        } .frame(width: 24, height: 24)
                    })
                    
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                Spacer()
                
                if store.isVer1(){
                    if let product = store.weekProduct{
                        
                   
                    
                        Text("ONLY \(decimaPriceToStr(price: product.price , chia: 7))\(removeDigits(string: product.displayPrice ))/Day.")
                        .mfont(24, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                      .padding(.top, 28)
                    
                        HStack(spacing : 0){
                            Text("Total \(product.displayPrice)/week ")
                                .mfont(17, .bold)
                                .foregroundColor(.black)
                            Text("(\(decimaPriceToStr(price: product.price , chia: 0.5))\(removeDigits(string: product.displayPrice ))/week)")
                                .mfont(17, .bold)
                                .foregroundColor(.black)
                                .overlay(
                                    Rectangle()
                                        .fill(Color.black.opacity(0.8))
                                        .frame(height: 1)

                                )
                        }
                      .padding(.top, 8)
                    
                    
                    Button(action: {
                        store.isPurchasing = true
                        store.purchase(product: product, onBuySuccess: {
                            b in
                               if b {
                                   DispatchQueue.main.async{
                                       store.isPurchasing = false
                                       presentationMode.wrappedValue.dismiss()
                                       showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                   }
                               }else{
                                   DispatchQueue.main.async{
                                       store.isPurchasing = false
                                       showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                   }
                               }
                        })
                    }, label: {
                        Capsule()
                            .fill(
                                Color.white
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 64)
                        
                            .overlay(
                                HStack{
                                  
                                    Text("Seize Now")
                                        .mfont(20, .bold)
                                      .multilineTextAlignment(.center)
                                      .foregroundColor(.black)
                                      .overlay(
                                          ZStack{
                                              if store.isPurchasing{
                                                  ResizableLottieView(filename: "progress_white")
                                                       .frame(width: 36, height: 36)
                                              }
                                          }.offset(x : -36)
                                          , alignment: .leading
                                      )
                                }
                                
                            )
                            .overlay(
                               Image("a.r")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.black)
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 20)
                            , alignment: .trailing
                            )
                            .padding(.horizontal, 48)
                    }).disabled(store.isPurchasing)
                    .padding(.top, 11)
                    
                    }
                }else{
                    if let product = store.yearlv2Sale50Product{
                        
                   
                    
                        Text("ONLY \(decimaPriceToStr(price: product.price , chia: 12))\(removeDigits(string: product.displayPrice ))/Month.")
                        .mfont(24, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                      .padding(.top, 28)
                    
                        HStack(spacing : 0){
                            Text("Total \(product.displayPrice)/year ")
                                .mfont(17, .bold)
                                .foregroundColor(.black)
                            Text("(\(decimaPriceToStr(price: product.price , chia: 0.5))\(removeDigits(string: product.displayPrice ))/year)")
                                .mfont(17, .bold)
                                .foregroundColor(.black)
                                .overlay(
                                    Rectangle()
                                        .fill(Color.black.opacity(0.8))
                                        .frame(height: 1)

                                )
                        }
                      .padding(.top, 8)
                    
                    
                    Button(action: {
                        store.isPurchasing = true
                        store.purchase(product: product, onBuySuccess: {
                            b in
                               if b {
                                   DispatchQueue.main.async{
                                       store.isPurchasing = false
                                       presentationMode.wrappedValue.dismiss()
                                       showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                   }
                               }else{
                                   DispatchQueue.main.async{
                                       store.isPurchasing = false
                                       showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                   }
                               }
                        })
                    }, label: {
                        Capsule()
                            .fill(
                                Color.white
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 64)
                        
                            .overlay(
                                HStack{
                                  
                                    Text("Seize Now")
                                        .mfont(20, .bold)
                                      .multilineTextAlignment(.center)
                                      .foregroundColor(.black)
                                      .overlay(
                                          ZStack{
                                              if store.isPurchasing{
                                                  ResizableLottieView(filename: "progress_white")
                                                       .frame(width: 36, height: 36)
                                              }
                                          }.offset(x : -36)
                                          , alignment: .leading
                                      )
                                }
                                
                            )
                            .overlay(
                               Image("a.r")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.black)
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 20)
                            , alignment: .trailing
                            )
                            .padding(.horizontal, 48)
                    }).disabled(store.isPurchasing)
                    .padding(.top, 11)
                    
                    }
                }
                
        
                
                
                HStack(spacing : 4){
                    Spacer()
                    
                    Button(action: {
                        
                        
                        if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
                            UIApplication.shared.open(url)
                        }
                        
                    }, label: {
                        Text("Privacy Policy")
                            .underline()
                            .foregroundColor(.black)
                            .mfont(12, .regular)
                        
                    })
                    
                    Text("|")
                        .mfont(12, .regular)
                        .foregroundColor(.black)
                    
                    Button(action: {
                        
                        if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                            UIApplication.shared.open(url)
                        }
                    }, label: {
                        Text("Terms of Use")
                            .underline()
                            .foregroundColor(.black)
                            .mfont(12, .regular)
                        
                    })
                 
                    Text("|")
                        .mfont(12, .regular)
                        .foregroundColor(.black)
                    Button(action: {
                        Task{
                            let b = await store.restore()
                            if b {
                                store.fetchProducts()
                                showToastWithContent(image: "checkmark", color: .green, mess: "Restore Successful")
                            }else{
                                showToastWithContent(image: "xmark", color: .red, mess: "Cannot restore purchase")
                            }
                        }
                        
                    }, label: {
                        Text("Restore")
                            .underline()
                            .foregroundColor(.black)
                            .mfont(12, .regular)
                        
                    })
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 16)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(
                    WebImage(url: URL(string: UserDefaults.standard.string(forKey: "sub_event_bg_image_url") ?? ""))
                        .onSuccess { image, data, cacheType in
                          
                        }
                        .resizable()
                        .indicator(.activity) // Activity Indicator
                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                )
                .onViewDidLoad {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        withAnimation(.easeOut){
                            showBtnClose = true
                        }
                    })
                }
                .overlay(
                    ZStack{
                        if store.isPurchasing{
                           ProgressBuySubView()
                                .ignoresSafeArea()
                        }
                    }
                )
            
        }
        
      
         
   
}

#Preview {
    Sub_Event()
        .environmentObject(MyStore())
}
