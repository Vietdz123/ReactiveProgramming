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
                
            
                    if let product = store.getYearSale50UsingProduct(){
                        
                   
                        Text( String(format: NSLocalizedString("ONLY %@/Week", comment: ""),  getDisplayPrice(price: product.price, chia: 51, displayPrice: product.displayPrice) ) )
                        .mfont(24, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color.init(hex: UserDefaults.standard.string(forKey: "textColor") ?? "000000"))
                      .padding(.top, 28)
                    
                        HStack(spacing : 0){
                            Text( String(format: NSLocalizedString("Total %@/year", comment: ""), product.displayPrice) )
                         //   Text("Total \(product.displayPrice)/year ")
                                .mfont(17, .bold)
                                .foregroundColor(Color.init(hex: UserDefaults.standard.string(forKey: "textColor") ?? "000000"))
                            Text("(\(decimaPriceToStr(price: product.price , chia: 0.5))\(removeDigits(string: product.displayPrice ))/year)")
                                .mfont(17, .bold)
                                .foregroundColor(Color.init(hex: UserDefaults.standard.string(forKey: "textColor") ?? "000000"))
                                .overlay(
                                    Rectangle()
                                        .fill(
                                            Color.init(hex: UserDefaults.standard.string(forKey: "textColor") ?? "000000") ?? Color.white
                                        )
                                        .frame(height: 1)

                                )
                        }
                      .padding(.top, 8)
                    
                    
                    Button(action: {
                        store.isPurchasing = true
                        let log =  "Click_Buy_Sub_In_Promotion_Event_Year_Sale"
                        Firebase_log(log)
                        store.purchase(product: product, onBuySuccess: {
                            b in
                               if b {
                                   DispatchQueue.main.async{
                                       store.isPurchasing = false
                                       presentationMode.wrappedValue.dismiss()
                                       showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                       let log1 = 
                                       "Buy_Sub_Success_In_PromoEv_Year_Sale"
                                       Firebase_log(log1)
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
                                Color.init(hex: UserDefaults.standard.string(forKey: "btnBgColor") ?? "000000") ?? Color.white
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 64)
                        
                            .overlay(
                                HStack{
                                  
                                    Text("Seize Now")
                                        .mfont(20, .bold)
                                      .multilineTextAlignment(.center)
                                      .foregroundColor( Color.init(hex: UserDefaults.standard.string(forKey: "btnTextColor") ?? "000000"))
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
                            .padding(.top, 32)
                    
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
                            .foregroundColor(Color.init(hex: UserDefaults.standard.string(forKey: "textColor") ?? "000000"))
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
                            .foregroundColor(Color.init(hex: UserDefaults.standard.string(forKey: "textColor") ?? "000000"))
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
                            .foregroundColor(Color.init(hex: UserDefaults.standard.string(forKey: "textColor") ?? "000000"))
                            .mfont(12, .regular)
                        
                    })
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.bottom, 16)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(
                    ZStack{
                        WebImage(url: URL(string: UserDefaults.standard.string(forKey: "sub_event_bg_image_url") ?? ""))
                            .resizable()
                            .scaledToFill()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
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
