//
//  OnboardingSubView.swift
//  WallpaperIOS
//
//  Created by Duc on 09/05/2024.
//

import SwiftUI
import StoreKit
struct Page_9_View : View {
    
    
    @EnvironmentObject var store : MyStore
    @Binding var currentProduct : Int
    @Binding var navigateToHome : Bool
    let list_2 : [String] = [
        "Unlimited Premium Wallpapers",
        "Unlimited Premium Widgets",
        "Unlimited AI-Generate",
        "Ad-free experience"
        
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            
            VStack(spacing : 0){
                Spacer()
                    .frame(height: getSafeArea().top)
                Image("new_crown")
                    .resizable()
                    .frame(width: 62, height: 48)
                Text("Wallive Premium".toLocalize())
                    .mfont(24, .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.87, blue: 0.19))
                    .padding(.top, 16)
                
                Text("Give your Phone A Cool Makeover".toLocalize())
                    .mfont(17, .bold, line: 2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 4)
                
                ZStack{
                    ResizableLottieView(filename: "sub2")
                        .frame(maxWidth: .infinity, maxHeight : .infinity)
                }.frame(maxWidth: .infinity)
                    .frame(height: getRect().width * 144 / 375)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                

                
                VStack(spacing : 8){

                                 ForEach(list_2, id: \.self){
                                     opt in
                                     
                                     HStack(spacing : 16){
                                         Image("star_1")
                                             .resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(width: 12, height: 12)
                                             .frame(width: 32, height: 32)
                                         
                                         Text(opt.toLocalize())
                                             .mfont(17, .bold, line: 2)
                                             .foregroundColor(.white)
                                         
                                     }.frame(maxWidth: .infinity, alignment : .leading)
                                     
                                         .padding(.leading, 43)
                                         .padding(.trailing, 24)
                                     
                                 }
                                 
                                 
                }.padding(.bottom, 4)

                
                
                
                if let weekProduct = store.weekProductNotSale,
                   let yearProductOrigin = store.getYearOriginUsingProduct()
                {
                    
                    
                    Opt_Year(product: yearProductOrigin)
                        .padding(.top, 16)
                    Opt_Week(product: weekProduct)
                        .padding(.top, 16)

                    Text("Auto-renewable, cancel anytime.")
                        .mfont(11, .regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.top,   16)

                    
                }
                
                Spacer()
                    .frame(height: 90)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(
            VisualEffectView(effect: UIBlurEffect(style: .dark)).ignoresSafeArea()
        )
        
        
        
    }
    func purchasesss(product : Product, string : String) {
        store.isPurchasing = true
        store.purchase(product: product, onBuySuccess: { b in
            if b {
                DispatchQueue.main.async{
                    store.isPurchasing = false
                    Firebase_log("Buy_Sub_Success_In_\(string)")
                    showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                    withAnimation{
                        navigateToHome.toggle()
                    }
                }
            }else{
                DispatchQueue.main.async{
                    store.isPurchasing = false
                }
            }
        }
        )
    }
    
    func Opt_Week(product : Product) -> some View {
        HStack(spacing : 0){
            ZStack{
                Circle().stroke(Color.white, lineWidth: 1)
                if currentProduct == 1 {
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
                    
                    
                }
                
                
            }.frame(width: 24, height: 24)  .padding(.horizontal, 16)
            
            ZStack{
                
                HStack{
                    VStack(spacing : 2){
                        Text("Weekly".toLocalize())
                            .mfont(16, .bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Text("\(product.displayPrice)/week")
                        Text(String(format: NSLocalizedString("%@/week", comment: ""), product.displayPrice))
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    // Text("\(product.displayPrice)/week")
                    Text(String(format: NSLocalizedString("%@/week", comment: ""), product.displayPrice))
                        .mfont(12, .regular)
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                }

            }
            
        }.frame(maxWidth: .infinity)
            .frame(height: 72)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture{
                withAnimation{
                    currentProduct = 1
                    purchasesss(product: product, string: "Onb_Week")
                }
            }
            .background(
                BG_opt(opacity: currentProduct == 1 ? 0.7 : 0.2)
            )
            .overlay{
                if currentProduct == 1 {
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
                if currentProduct == 2 {
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
                    
                    
                }
                
                
                
                
                
            }.frame(width: 24, height: 24)  .padding(.horizontal, 16)
            
            ZStack{
                HStack{
                    VStack(spacing : 2){
                        Text("Annually".toLocalize())
                            .mfont(16, .bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(format: NSLocalizedString("%@/year", comment: ""), product.displayPrice ))
                        
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text(String(format: NSLocalizedString("%@/week", comment: ""), getDisplayPrice(price: product.price, chia: 51, displayPrice: product.displayPrice) ))
                        .mfont(12, .regular)
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                }
            }
            
        }.frame(maxWidth: .infinity)
            .frame(height: 72)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture{
                withAnimation{
                    currentProduct = 2
                    purchasesss(product: product, string: "Onb2_Year_FreeTrial")
                }
            }
            .background(
                BG_opt(opacity: currentProduct == 2 ? 0.7 : 0.2)
            )
            .overlay{
                if currentProduct == 2{
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.main, lineWidth : 2)
                    
                }
            }
            .overlay(alignment: .topTrailing){
                Text("SPECIAL OFFER".toLocalize())
                    .mfont(10, .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .frame(width: 87, height: 22)
                    .background(
                        Capsule()
                            .fill(Color.main)
                    )
                    .offset(x: -8, y : -11)
            }
            .padding(.horizontal, 27)
        
    }
    
    
    
    func BG_opt(opacity : CGFloat) -> some View{
        RoundedRectangle(cornerRadius: 12)
            .fill(
                
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1).opacity(opacity), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.82, green: 0.23, blue: 0.89).opacity(opacity), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0, y: 1),
                    endPoint: UnitPoint(x: 1, y: 0)
                )
            )
    }
    
}
