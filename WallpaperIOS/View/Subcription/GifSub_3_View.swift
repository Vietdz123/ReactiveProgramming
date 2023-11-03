//
//  GifSub_3_View.swift
//  WallpaperIOS
//
//  Created by Duc on 23/10/2023.
//

import SwiftUI

struct GifSub_3_View: View {
    
    @State private var showBtnClose : Bool = false
    @Binding var  show  : Bool
    @State var animationGift : Bool = false
    @EnvironmentObject var storeVM : MyStore
    
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            VStack{
                         HStack{
                             Spacer()
                             
                             Button(action: {
                                 
                             }, label: {
                                 HStack{
                                     Spacer()
                                     
                                     Button(action: {
                                       
                                             show = false
                                     
                                      
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
                             })
                         }
                Spacer()
                     }.frame(maxWidth: .infinity, maxHeight: .infinity)
            GeometryReader{ proxy in
                
                let size = proxy.size
                
                if let product = storeVM.yearlv2Sale50Product {
                    VStack(spacing : 0){
                        Spacer()
                        HStack(spacing : 0){
                            Text("~ ")
                                .mfont(24, .bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            Text("\(getDisplayPrice(price: product.price ,chia: 51,displayPrice: product.displayPrice ))")
                                .mfont(24, .bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.main)
                            Text("/Week")
                                .mfont(24, .bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        
                        
                        HStack(spacing : 0){
                            Text("Just \(product.displayPrice)/year (")
                                .mfont(13, .regular)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            Text("\(getDisplayPrice(price: product.price ,chia: 0.5,displayPrice: product.displayPrice ))/year)")
                                .mfont(13, .regular)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .overlay(
                                    Capsule()
                                        .fill(.white)
                                        .frame(height: 1)
                                )
                            Text(")")
                                .mfont(13, .regular)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }.padding(.top, 8)
                        
                        
                        Button(action: {
                            storeVM.isPurchasing = true
                            showProgressSubView()
                            let log =  "Click_Buy_Sub_In_GiftView"
                            Firebase_log(log)
                            storeVM.purchase(product: product, onBuySuccess: {
                                b in
                                   if b {
                                       DispatchQueue.main.async{
                                           hideProgressSubView()
                                           storeVM.isPurchasing = false
                                           show.toggle()
                                           
                                           let log1 =
                                           "Buy_Sub_In_Success_GiftView"
                                           Firebase_log(log1)
                                           showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                         
                                          
                                       }
                                      
                                   }else{
                                       DispatchQueue.main.async{
                                           storeVM.isPurchasing = false
                                           hideProgressSubView()
                                           showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                       }
                                   }
                            })
                        }, label: {
                            HStack(spacing : 0){
                                Text("Seize Now")
                                    .mfont(20, .bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .frame(width: 100, height: 28, alignment: .top)
                            }
                            
                            .frame(maxWidth: .infinity)
                            .frame(height: 64)
                            .background(
                                Capsule()
                                    .fill(
                                        Color.white
                                    )
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
                            .padding(.horizontal, 28)
                            .padding(.top, 48)
                        })
                        
                     
                        
                        
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
                                                                let b = await storeVM.restore()
                                                                if b {
                                                                    storeVM.fetchProducts()
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
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                        
                        
                        
                    }
                    .frame(width: size.width, height: size.height)
                    .background(
                        Image("gifsub_3")
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(16)
                    )
                }
                
                
            }
            .frame(width : getRect().width - 80, height: ( getRect().width - 80 ) * 606 / 348 )
            .scaleEffect(animationGift ? 1.0 : 0.1)
            .animation(.easeInOut(duration: 0.5), value: animationGift)
              
          
          
            
            
        }
        .offset(y : animationGift ? 0 : getRect().height)
        .onAppear {
            if !animationGift {
                withAnimation(.linear){
                    animationGift = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                showBtnClose = true
            })
          
        }
    }
}

#Preview {
    GifSub_3_View( show: .constant(true))
        .environmentObject(MyStore())
}
