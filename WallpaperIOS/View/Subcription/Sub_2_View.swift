//
//  Sub_2_View.swift
//  WallpaperIOS
//
//  Created by Mac on 29/08/2023.
//

import SwiftUI

struct Sub_2_View: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store : MyStore
    var body: some View {
        VStack(spacing : 0){
          
                HStack{
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("close.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    })
                    
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                
            Image("sub2_text1")
                .resizable()
                .aspectRatio( contentMode: .fit)
              .frame(width: 327)
            
            
            Image("sub2_text2")
                .resizable()
                .aspectRatio( contentMode: .fit)
              .frame(width: 316)
              
              .padding(.top, 12)
                
            Spacer()
       
            if let product = store.isPro() ? store.weekProduct  : store.yearlv2SalaProduct {
                
           
            
                Text("ONLY \(decimaPriceToStr(price: product.price , chia:  store.isVer1() ? 7 : 12))\(removeDigits(string: product.displayPrice ))/\(store.isVer1() ? "Day" : "Month" ).")
                .mfont(24, .bold)
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
            
                HStack(spacing : 0){
                    Text("Total \(product.displayPrice)/\(store.isVer1() ? "week" : "year" ) ")
                        .mfont(17, .bold)
                        .foregroundColor(.white)
                    Text("(\(decimaPriceToStr(price: product.price , chia: 0.5))\(removeDigits(string: product.displayPrice ))/\(store.isVer1() ? "week" : "year" ))")
                        .mfont(17, .bold)
                        .foregroundColor(.white)
                        .overlay(
                            Rectangle()
                                .fill(Color.white.opacity(0.8))
                                .frame(height: 1)

                        )
                }
                
              .padding(.top, 8)
            
            Button(action: {
                showProgressSubView()
                store.isPurchasing = true
                store.purchase(product: product, onBuySuccess: {
                    b in
                       if b {
                           DispatchQueue.main.async{
                               store.isPurchasing = false
                               hideProgressSubView()
                               showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                              
                           }
                          
                       }else{
                           DispatchQueue.main.async{
                               store.isPurchasing = false
                               hideProgressSubView()
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
                                          EZProgressView()
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
            .padding(.top, 44)
            
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
                        .foregroundColor(.white)
                        .mfont(12, .regular)
                    
                })
                
                Text("|")
                    .mfont(12, .regular)
                    .foregroundColor(.white)
                
                Button(action: {
                    
                    if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                        UIApplication.shared.open(url)
                    }
                }, label: {
                    Text("Terms of Use")
                        .underline()
                        .foregroundColor(.white)
                        .mfont(12, .regular)
                    
                })
             
                Text("|")
                    .mfont(12, .regular)
                    .foregroundColor(.white)
                Button(action: {
                    Task{
                        let b = await store.restore()
                        if b {
                            showToastWithContent(image: "checkmark", color: .green, mess: "Restore Successful")
                        }else{
                            showToastWithContent(image: "xmark", color: .red, mess: "Cannot restore purchase")
                        }
                    }
                    
                }, label: {
                    Text("Restore")
                        .underline()
                        .foregroundColor(.white)
                        .mfont(12, .regular)
                    
                })
                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
                
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
            .background(
                Image("sub_2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        
            
    }
}

struct Sub_2_View_Previews: PreviewProvider {
    static var previews: some View {
        Sub_2_View()
            .environmentObject(MyStore())
    }
}
