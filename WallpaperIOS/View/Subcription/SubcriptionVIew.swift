//
//  SubcriptionVIew.swift
//  WallpaperIOS
//
//  Created by Mac on 15/05/2023.
//

import SwiftUI
import AVKit

import FirebaseAnalytics

enum BuyType {
    case WEEKLY
    case MONTHLY
    case YEARLY
    case UNLIMITED
}

struct SubcriptionVIew: View {
    @Namespace var anim
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var store : MyStore
    
    @State var buyType : BuyType = .WEEKLY
    @State var player : AVPlayer?
    @State var isT1 : Bool = true
    
    var body: some View {
        ZStack{
            if player != nil {
                MyVideoPlayer(player: player!)
                    .ignoresSafeArea()
            }
            
            //        if store.isVer1(){
            //SubView_1()
            //     }else{
                     SubView_2()
            //   }
            
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .onAppear(perform: {
            
            
            self.player = AVPlayer(url:  Bundle.main.url(forResource: "bg", withExtension: "mp4")!)
            if  self.player != nil {
                self.player!.play()
            }
            Firebase_log("Sub_view_show_total")
            
            
        })
        .onDisappear(perform : {
            
            if self.player != nil {
                self.player!.pause()
                self.player = nil
            }
        })
    }
}


extension SubcriptionVIew {
    
    @ViewBuilder
    func SubView_1() -> some View{
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
            
            
            ScrollView(.vertical, showsIndicators: false){
                
                ResizableLottieView(filename: "star")
                    .frame(width: 80, height: 80)
                
                Text("WALLIVE PRO")
                    .mfont(24, .bold)
                    .foregroundColor(.yellow)
                    .padding(.top, 8)
                
                
                OptForProUser()
                
                
                ZStack{
                    if store.purchasedIds.isEmpty{
                        
                        if let monthly = store.monthProduct, let weekly = store.weekProductNotSale{
                            HStack(spacing : 24){
                                ZStack{
                                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                                        .clipShape(RoundedRectangle(cornerRadius:  16))
                                    
                                    if buyType == .WEEKLY{
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.yellow, lineWidth: 2)
                                            .matchedGeometryEffect(id: "BUYSUB", in: anim)
                                    }
                                    
                                    
                                    VStack{
                                        Text("\(weekly.displayPrice)")
                                            .mfont(24, .bold)
                                            .foregroundColor(.main)
                                        Text("PER WEEK")
                                            .mfont(13, .regular)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Image("best_deal")
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    
                                    
                                    
                                }.frame(width: getRect().width / 2 - 36 , height:  getRect().width / 2 - 36)
                                    .overlay(
                                        Text("\(decimaPriceToStr(price: weekly.price , chia: 7))\(removeDigits(string: weekly.displayPrice ))/DAY")
                                            .mfont(13, .bold)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 8)
                                        , alignment: .bottom
                                    )
                                    .onTapGesture {
                                        withAnimation{
                                            buyType = .WEEKLY                                        }
                                    }
                                
                                
                                ZStack{
                                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                                        .clipShape(RoundedRectangle(cornerRadius:  16))
                                    if buyType == .MONTHLY{
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.yellow, lineWidth: 2)
                                            .matchedGeometryEffect(id: "BUYSUB", in: anim)
                                    }
                                    
                                    VStack{
                                        Text("\(monthly.displayPrice)")
                                            .mfont(24, .bold)
                                            .foregroundColor(.main)
                                        Text("PER MONTH")
                                            .mfont(13, .regular)
                                            .foregroundColor(.white)
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }.frame(width: getRect().width / 2 - 36 , height:  getRect().width / 2 - 36)
                                    .onTapGesture {
                                        withAnimation{
                                            buyType = .MONTHLY
                                        }
                                    }
                                
                                
                                
                            }.frame(maxWidth: .infinity)
                                .padding(.horizontal, 24 )
                                .padding(.top, 24)
                        }
                        
                        
                    }
                }
                
                Button(action: {
                    if store.purchasedIds.isEmpty{
                        store.isPurchasing = true
                        showProgressSubView()
                        Firebase_log("Sub_click_buy_sub_total")
                        
                        if buyType == .MONTHLY && store.monthProduct != nil {
                            
                            Firebase_log("Sub_click_buy_1_month")
                            store.purchase(product: store.monthProduct!, onBuySuccess: { b in
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
                            
                            
                        }else if buyType == .WEEKLY && store.weekProductNotSale != nil{
                            
                            Firebase_log("Sub_click_buy_weekly")
                            store.purchase(product: store.weekProductNotSale!, onBuySuccess: { b in
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
                    }
                }, label: {
                    HStack{
                        
                        Text( "BUY SUBSCRIPTION" )
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
                        .foregroundColor(.yellow)
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .disabled(store.isPurchasing)
                
                
                
                
                BottomButton()
                
                
                
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func SubView_2() -> some View{
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
            Spacer()
         
                
                ResizableLottieView(filename: "star")
                    .frame(width: 80, height: 80)
                
                Text("Wallive Premium")
                    .mfont(24, .bold)
                    .foregroundColor(.yellow)
                    .padding(.top, 8)
            Text("Give your Phone A Cool Makeover")
                .mfont(17, .bold)
                .foregroundColor(.white)
                .padding(.top, 4)
                .padding(.bottom, 16)
                
                
                OptForProUser()
            
                
            Spacer()
                
                ZStack{
                    if store.purchasedIds.isEmpty{
                        if let yearlyNoFreeTrial = store.yearlyNoFreeTrialProduct{
                            
                            VStack(spacing : 0){
                                Text("Just \(yearlyNoFreeTrial.displayPrice)/year.")
                                    .mfont(17, .bold)
                                Text("( Lest than \(decimaPriceToStr(price: yearlyNoFreeTrial.price , chia: 365))\(removeDigits(string: yearlyNoFreeTrial.displayPrice ))/day! )")
                                    .mfont(15, .regular)
                                    .padding(.top, 6)
                                
                                
                                Button(action: {
                                    if store.purchasedIds.isEmpty{
                                        store.isPurchasing = true
                                        showProgressSubView()
                                        Firebase_log("Sub_click_buy_sub_total")
                                        
                                        
                                        
                                       
                                        store.purchase(product: yearlyNoFreeTrial, onBuySuccess: { b in
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
                                        
                                        Text( "BUY SUBSCRIPTION" )
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
                                        .foregroundColor(.yellow)
                                )
                                .padding(.horizontal, 24)
                                .padding(.top, 16)
                                .disabled(store.isPurchasing)
                            }
                            
                        
                            
                            
                            
                        }
                     
                        
                        
                    }
                }
                
                
                
                
                
                
                BottomButton()
                
                
                
           
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    
    @ViewBuilder
    func OptForProUser() -> some View{
        VStack(spacing : 0){
            HStack(spacing : 0){
                Image("check")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text("No ADs.")
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
                Text("All Live Wallpapers.")
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
                Text("All Exclusive Wallpapers.")
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
                Text("All Special Wallpapers.")
                    .mfont(17, .bold)
                    .foregroundColor(.white)
                    .padding(.leading,  16)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 0))
            
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 192)
        .background(
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .clipShape(RoundedRectangle(cornerRadius:  16))
            
        ) .padding(.horizontal, 38)
    }
    
    @ViewBuilder
    func BottomButton() -> some View{
        
        Text( "The subscription will be renewed automatically. You can cancel anytime.")
            .mfont(11, .regular)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.top, 8)
            .padding(.horizontal, 24)
        
        Text("Unlimited access to all wallpapers. No ads. Payments are charged to the user’s Apple ID account at confirmation of purchase. Subscriptions automatically renew unless the user cancels at least 24 hours before the end of current period. The account is charged for renewal within 24-hours before the end of the current period. Users can manage and cancel subscriptions in their account settings on the App Store.")
            .mfont(9, .regular)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.top, 8)
            .padding(.horizontal, 24)
        
        HStack(spacing : 0){
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
            .padding(.leading, 32)
            
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
                Text("Restore Purchase")
                    .underline()
                    .foregroundColor(.white)
                    .mfont(12, .regular)
                
            })
            .padding(.leading, 32)
        }
        .padding(.top, 16)
    }
    
}

extension Decimal {
    var toPriceDouble: String {
        let priceDouble = NSDecimalNumber(decimal: self).doubleValue / 30
        return String(format: "%0.2f", priceDouble)
    }
}
