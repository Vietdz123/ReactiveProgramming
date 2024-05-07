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
       
            if let product =  store.getYearSale50UsingProduct() {
                
           
            
//                Text("ONLY \( getDisplayPrice(price: product.price ,chia: 51, displayPrice: product.displayPrice ) )/\("Week" ).")
                Text( String(format: NSLocalizedString("ONLY %@/Week", comment: ""), getDisplayPrice(price: product.price, chia: 51, displayPrice: product.displayPrice)) )
                .mfont(24, .bold)
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
            
                HStack(spacing : 0){
               //     Text("Total \(product.displayPrice)/\( "year" ) ")
                    Text( String(format: NSLocalizedString("Total %@/year", comment: ""), product.displayPrice ) )
                        .mfont(17, .bold)
                        .foregroundColor(.white)
//                    Text("(\(decimaPriceToStr(price: product.price , chia: 0.5))\(removeDigits(string: product.displayPrice ))/\("year" ))")
                    Text( String(format: NSLocalizedString("(%@/year)", comment: ""), getDisplayPrice(price: product.price, chia: 0.5, displayPrice: product.displayPrice)) )
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
           
                store.isPurchasing = true
                let log = "Click_Buy_Sub_In_Promotion_Year_Sale"
                Firebase_log(log)
                store.purchase(product: product, onBuySuccess: {
                    b in
                       if b {
                           DispatchQueue.main.async{
                               store.isPurchasing = false
                               presentationMode.wrappedValue.dismiss()
                               showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                               let log1 = 
                               "Buy_Sub_In_Success_Promotion_Year_Sale"
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
                    
                    
                    if let url = URL(string: "https://docs.google.com/document/d/1EY8f5f5Z_-5QfqAeG2oYdUxlu-1sBc-mgfco2qdRMaU") {
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
                            store.fetchProducts()
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

struct Sub_2_View_Previews: PreviewProvider {
    static var previews: some View {
        Sub_2_View()
            .environmentObject(MyStore())
    }
}
