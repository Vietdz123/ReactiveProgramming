//
//  EztSubcriptionView.swift
//  WallpaperIOS
//
//  Created by Duc on 24/10/2023.
//

import SwiftUI
import AVFoundation
import StoreKit

enum BuyType {
    case WEEKLY
    case MONTHLY
    case YEARLY
    case UNLIMITED
}


struct EztSubcriptionView: View {
    
    @StateObject var store : MyStore = .init()
    
    @Namespace var anim
    @Environment(\.presentationMode) var presentationMode
    
    //  @EnvironmentObject var store : MyStore
    
    @State var buyType : BuyType = .YEARLY
    @State var player : AVPlayer?
    @State var isT1 : Bool = true
    
    @State var showBtnClose : Bool = false
    
    
    
    var body: some View {
        ZStack{
            if player != nil {
                MyVideoPlayer(player: player!)
                    .ignoresSafeArea()
            }
            
            VStack(spacing : 0){
                HStack{
                    Button(action: {
                        
                    }, label: {
                        Text("Restore".toLocalize())
                            .mfont(13, .regular)
                            .foregroundColor(.white)
                    }).padding(.leading, 16)
                    
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        ZStack{
                            if showBtnClose{
                                Image("close.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .frame(width: 40, height: 40)
                                    .opacity(0.7)
                            }
                        }.frame(width: 40, height: 40)
                        
                    })
                    
                }
                .frame(maxWidth: .infinity)
                
                ScrollView(.vertical, showsIndicators : false){
                    VStack(spacing : 0){
                        ResizableLottieView(filename: "star")
                            .frame(width: 80, height: 80)
                        
                        Text("Wallive Premium".toLocalize())
                            .mfont(24, .bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.main)
                            .padding(.top, 8)
                        
                        
                        Text("Give your Phone A Cool Makeover".toLocalize())
                            .mfont(17, .bold, line: 2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.top, 4)
                        
                        OptForProUser().padding(.top, 24)
                        
                        if let yearProduct = store.yearlyOriginalProduct, let monthProduct = store.monthProduct, let weekProduct = store.weekProductNotSale{
                            
                            
                            Opt_Year(product: yearProduct).padding(.top, 32)
                            Opt_Month(product: monthProduct).padding(.top, 16)
                            Opt_Week(product: weekProduct).padding(.top, 16)
                            
                            Button(action: {
                                                            if store.purchasedIds.isEmpty{
                                                                store.isPurchasing = true
                                                                showProgressSubView()
                                                                Firebase_log("Sub_click_buy_sub_total")
                                
                                
                                                                let product : Product = buyType == .YEARLY ? yearProduct :  ( buyType == .MONTHLY ? monthProduct : weekProduct )
                                
                                                                store.purchase(product: product, onBuySuccess: { b in
                                                                    if b {
                                                                        DispatchQueue.main.async{
                                                                            store.isPurchasing = false
                                                                            hideProgressSubView()
                                                                            showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                                                            presentationMode.wrappedValue.dismiss()
                                                                        }
                                
                                                                    }else{
                                                                        DispatchQueue.main.async{
                                                                            store.isPurchasing = false
                                                                            hideProgressSubView()
                                                                            showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                                                        }
                                                                    }
                                
                                                                })
                                
                                                            }
                                
                            }, label: {
                                HStack{
                                    
                                    Text( "BUY SUBSCRIPTION".toLocalize() )
                                        .mfont(17, .bold)
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
                                
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .contentShape(Rectangle())
                            })
                            .background(
                                Capsule()
                                    .foregroundColor(.main)
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            
                        }
                        

                        //     .disabled(store.isPurchasing)
                        
                        
                        Text("The subscription will be renewed automatically. You can cancel anytime.")
                            .mfont(11, .regular, line : 4)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                        
                        Text("Payments are charged to the user’s Apple ID account at confirmation of purchase. Subscriptions automatically renew unless the user cancels at least 24 hours before the end of current period. The account is charged for renewal within 24-hours before the end of the current period. Users can manage and cancel subscriptions in their account settings on the App Store.")
                            .mfont(9, .regular, line: 5)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        
                        
                        BottomButton()
                    }
                }
               
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .onAppear(perform: {
            
            
            self.player = AVPlayer(url:  Bundle.main.url(forResource: "bg", withExtension: "mp4")!)
            if  self.player != nil {
                self.player!.play()
            }
            Firebase_log("Sub_view_show_total")
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                withAnimation(.easeOut){
                    showBtnClose = true
                }
            })
            
            
        })
        .onDisappear(perform : {
            
            if self.player != nil {
                self.player!.pause()
                self.player = nil
            }
        })
    }
}

#Preview {
    EztSubcriptionView()
}




extension EztSubcriptionView{
    @ViewBuilder
    func OptForProUser() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Image("check")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text("Unlimited Premium Wallpapers".toLocalize())
                    .mfont(17, .bold)
                    .foregroundColor(.white)
                    .padding(.leading,  16)
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 0))
            
            HStack(spacing : 0){
                Image("check")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text("Unlimited Premium Widgets".toLocalize())
                    .mfont(17, .bold)
                    .foregroundColor(.white)
                    .padding(.leading,  16)
                    .lineLimit(1)
                    .fixedSize()
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 0))
            
            HStack(spacing : 0){
                Image("check")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text("No ADs.".toLocalize())
                    .mfont(17, .bold)
                    .foregroundColor(.white)
                    .padding(.leading,  16)
                    .lineLimit(1)
                    .fixedSize()
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 0))
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 152)
        .background(
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .clipShape(RoundedRectangle(cornerRadius:  16))
            
        ) .padding(.horizontal, 28)
    }
    
    func BG_opt() -> some View{
        RoundedRectangle(cornerRadius: 12)
            .fill(
                
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1).opacity(0.2), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.82, green: 0.23, blue: 0.89).opacity(0.2), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0, y: 1),
                    endPoint: UnitPoint(x: 1, y: 0)
                )
            )
    }
    
    func Opt_Week(product : Product) -> some View {
        HStack(spacing : 0){
            ZStack{
                Circle()
                    .stroke(Color.white, lineWidth: 1)
                
                if buyType == .WEEKLY {
                  
                    Image("checkmark")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                            Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.1, y: 1.17),
                                        endPoint: UnitPoint(x: 1, y: -0.22)
                                    )
                                )
                        )
                        .matchedGeometryEffect(id: "CHECK", in: anim)
                    
                }
                
                
            }.frame(width: 24, height: 24)  .padding(.horizontal, 16)
            
            ZStack{
                
                HStack{
                    VStack(spacing : 2){
                        Text("Weekly".toLocalize())
                            .mfont(16, .bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text( String(format: NSLocalizedString("%@/week", comment: ""), product.displayPrice)  )
                      //  Text("\(product.displayPrice)/week")
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                   // Text("\(product.displayPrice)/week")
                    Text( String(format: NSLocalizedString("%@/week", comment: ""), product.displayPrice)  )
                        .mfont(12, .regular)
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                }
                
                
                
                
                
            }
            
        }.frame(maxWidth: .infinity)
            .frame(height: 48)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture{
                withAnimation{
                    buyType = .WEEKLY
                }
            }
            .background(
                BG_opt()
            )
            .overlay{
                if buyType == .WEEKLY {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.main, lineWidth : 2)
                      
                }
            }
            .padding(.horizontal, 27)
        
    }
    
    func Opt_Month(product : Product) -> some View {
        HStack(spacing : 0){
            ZStack{
                Circle()
                    .stroke(Color.white, lineWidth: 1)
                
                
                if buyType == .MONTHLY {
                    Image("checkmark")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                            Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.1, y: 1.17),
                                        endPoint: UnitPoint(x: 1, y: -0.22)
                                    )
                                )
                        )
                        .matchedGeometryEffect(id: "CHECK", in: anim)
                    
                }
                
                
                
            }.frame(width: 24, height: 24)  .padding(.horizontal, 16)
            
            ZStack{
                
                HStack{
                    VStack(spacing : 2){
                        Text("Monthly".toLocalize())
                            .mfont(16, .bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text( String(format: NSLocalizedString("%@/month", comment: ""), product.displayPrice)  )
                            //  Text("\(product.displayPrice)/month")
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text( String(format: NSLocalizedString("%@/week", comment: ""), "\(decimaPriceToStr(price: product.price ,chia: 4))\(removeDigits(string: product.displayPrice))")  )
//                    Text("\(decimaPriceToStr(price: product.price ,chia: 4))\(removeDigits(string: product.displayPrice))/week")
                        .mfont(12, .regular)
                                            .foregroundColor(.white)
                        .padding(.trailing, 16)
                }
                
                
                
                
                
            }
            
        }.frame(maxWidth: .infinity)
            .frame(height: 48)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture{
                withAnimation{
                    buyType = .MONTHLY
                }
            }
            .background(
                BG_opt()
            )
            .overlay{
                if buyType == .MONTHLY {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.main, lineWidth : 2)
                       
                }
            }
            .padding(.horizontal, 27)
        
    }
    
    func Opt_Year(product : Product) -> some View {
        HStack(spacing : 0){
            ZStack{
                Circle()
                    .stroke(Color.white, lineWidth: 1)
                
                if buyType == .YEARLY {
                    
                   
                    
                    Image("checkmark")
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                            Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.1, y: 1.17),
                                        endPoint: UnitPoint(x: 1, y: -0.22)
                                    )
                                )
                        )
                        .matchedGeometryEffect(id: "CHECK", in: anim)
                    
                }
                   
               
                
                
                
            }.frame(width: 24, height: 24)  .padding(.horizontal, 16)
            
            ZStack{
                
                HStack{
                    VStack(spacing : 2){
                        Text("Annually".toLocalize())
                            .mfont(16, .bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text( String(format: NSLocalizedString("%@/year", comment: ""), product.displayPrice)  )
                       // Text("\(product.displayPrice)/year")
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                   // Text("\(decimaPriceToStr(price: product.price ,chia: 51))\(removeDigits(string: product.displayPrice))/week")
                    Text( String(format: NSLocalizedString("%@/week", comment: ""), "\(decimaPriceToStr(price: product.price ,chia: 51))\(removeDigits(string: product.displayPrice))")  )
                        .mfont(12, .regular)
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                }
                
                
                
                
                
            }
            
        }.frame(maxWidth: .infinity)
            .frame(height: 48)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture{
                withAnimation{
                    buyType = .YEARLY
                }
            }
            .background(
                BG_opt()
            )
            .overlay{
                if buyType == .YEARLY {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.main, lineWidth : 2)
                     
                }
            }
            .overlay(alignment: .topTrailing){
                Text("Best value".toLocalize())
                    .mfont(10, .bold)
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(width: 64, height: 16)
                  .background(
                    Capsule()
                        .fill(Color.main)
                  )
                  .offset(x: -8, y : -8)
            }
            .padding(.horizontal, 27)
        
    }
    
    
    func BottomButton() -> some View{
        HStack(spacing : 0){
            Button(action: {
                
                
                if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
                    UIApplication.shared.open(url)
                }
                
            }, label: {
                Text("Privacy Policy".toLocalize())
                    .underline()
                    .foregroundColor(.white)
                    .mfont(9, .regular)
                
            })
            
            Button(action: {
                
                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                    UIApplication.shared.open(url)
                }
            }, label: {
                Text("Terms of Use".toLocalize())
                    .underline()
                    .foregroundColor(.white)
                    .mfont(9, .regular)
                
            }).padding(.leading, 16)
            
            
            
        }
        .padding( 16)
    }
}
