//
//  GiftSub_1_View.swift
//  WallpaperIOS
//
//  Created by Duc on 23/10/2023.
//

import SwiftUI

struct GiftSub_1_View: View {
    
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
                if let product = storeVM.getYearSale50UsingProduct() {
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
                           // Text("Just \(product.displayPrice)/year ")
                            Text(String(format: NSLocalizedString("Just %@/year.", comment: ""), product.displayPrice))
                                .mfont(13, .regular)
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                          
                            Text(String(format: NSLocalizedString("(%@/year)", comment: ""), getDisplayPrice(price: product.price ,chia: 0.5,displayPrice: product.displayPrice )))
                                .mfont(13, .regular)
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .overlay(
                                Capsule()
                                    .fill(.white)
                                    .frame(height: 1)
                              )

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
                                Text("Seize Now".toLocalize())
                                    .mfont(20, .bold)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                  .frame(width: 100, height: 28, alignment: .top)
                            }
                          
                            .frame(maxWidth: .infinity)
                                .frame(height: 64)
                                .background(
                                    Capsule()
                                        .fill(
                                        
                                            LinearGradient(
                                            stops: [
                                            Gradient.Stop(color: Color(red: 1, green: 0.77, blue: 0.08), location: 0.00),
                                            Gradient.Stop(color: Color(red: 1, green: 0.89, blue: 0.52), location: 0.23),
                                            Gradient.Stop(color: Color(red: 1, green: 0.78, blue: 0), location: 0.49),
                                            Gradient.Stop(color: Color(red: 1, green: 0.89, blue: 0.52), location: 0.74),
                                            Gradient.Stop(color: Color(red: 1, green: 0.75, blue: 0), location: 1.00),
                                            ],
                                            startPoint: UnitPoint(x: 1, y: 0),
                                            endPoint: UnitPoint(x: 0, y: 1)
                                        )
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
                                .padding(.top, 24)
                            
                        })
                        
                   
                       
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
                        .padding(.bottom, 48)
                        
                        
                        
                    }
                    .frame(width: size.width, height: size.height)
                    
                    
                    .background(
                        Image("gifsub_1")
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(16)
                    )
                }
                
   
                
            }.frame(width : getRect().width - 80, height: ( getRect().width - 80 ) * 640 / 295 )
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
    GiftSub_1_View( show: .constant(true))
        .environmentObject(MyStore())
}
