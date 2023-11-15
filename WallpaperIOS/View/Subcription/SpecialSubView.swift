//
//  SpecialSubView.swift
//  WallpaperIOS
//
//  Created by Duc on 23/10/2023.
//

import SwiftUI
import StoreKit

struct SpecialSubView: View {
    
    var from : String = "WL"
    
    var fromDefault : Bool = true

    @Environment(\.presentationMode) var presentationMode
    
    let vip_op : [String] = [    "Unlimited Premium Wallpapers",
                                 "Unlimited Premium Widgets",
                                 "No ADs."]
    @EnvironmentObject var store : MyStore
    @State var showSubView : Bool = true
    @State var giftOpen : Bool = false
    @State var buyType : BuyType = .YEARLY
    @Namespace var anim
    
    var onClickClose : () -> ()
    
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            
            if showSubView {
                SubView()
            }else{
                
                VStack{
                    HStack{
                        Spacer()
                        
                        Button(action: {
                         onClickClose()
                        }, label: {
                            Image("close.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .opacity(0.7)
                        })
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if giftOpen{
                    
                    GiftShowView()
                    
                }else{
                    GiftView()
                }
            }
            
        }
    }
}

#Preview {
    SpecialSubView(onClickClose: {
        
    })
}

extension SpecialSubView{
    
    func SubView() -> some View{
        VStack(spacing : 0){
            HStack{
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut){
                        showSubView.toggle()
                    }
                }, label: {
                    Image("close.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .opacity(0.7)
                })
                
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            
            Spacer()
            Image("new_crown")
                .resizable()
                .frame(width: 126, height: 96)
            
            Text("PREMIUM".toLocalize())
                .mfont(32, .bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 1, green: 0.87, blue: 0.19))
                .padding(.top, 12)
            
            Text("CONTENT".toLocalize())
                .mfont(32, .bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 1, green: 0.87, blue: 0.19))
                .offset(y : -8)
            
            Text("Bringing you a wonderful experience!".toLocalize())
                .mfont(17, .bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .lineLimit(1)
                .fixedSize()
                .padding(.horizontal, 28)
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            ForEach(vip_op, id : \.self){
                opt in
                HStack{
                    Image("stone_yellow")
                        .resizable()
                        .frame(width: 12, height: 8)
                    Text(opt.toLocalize())
                        .mfont(17, .bold)
                        .foregroundColor(.white)
                        .padding(.leading, 24)
                        .lineLimit(1)
                        .fixedSize()
                    
                }.frame(maxWidth: .infinity, alignment : .leading)
                    .padding(.top, 16)
                    .padding(.leading, 48)
            }
            
            
            VStack(spacing : 0){
                
                if let weekProduct = store.weekProductNotSale, let monthProduct = store.monthProduct, let yearProduct = store.yearlyOriginalProduct{
                    Opt_Year(product: yearProduct)
                    Opt_Month(product: monthProduct).padding(.top, 12)
                    Opt_Week(product: weekProduct).padding(.top, 12).padding(.bottom, 24)
                    
                    
                    Button(action: {
                        
                        if store.purchasedIds.isEmpty{
                            store.isPurchasing = true
                            showProgressSubView()
                          
                            let product : Product = buyType == .YEARLY ? yearProduct :  ( buyType == .MONTHLY ? monthProduct : weekProduct )
                            
                            let productString : String = buyType == .YEARLY ? "Year" :  ( buyType == .MONTHLY ? "Month" : "Week" )
                            
                         
                            
                            Firebase_log("Sub_click_buy_sub_total")
                            Firebase_log("Sub_click_buy_In_Special_\(productString)_\(from)")
                            
                            
                            store.purchase(product: product, onBuySuccess: { b in
                                if b {
                                    DispatchQueue.main.async{
                                        store.isPurchasing = false
                                        hideProgressSubView()
                                        showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                        
                                        Firebase_log("Buy_Sub_Success_In_Special_\(productString)_\(from)")
                                        
                                        onClickClose()
                                        
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
                            
                            
                            Text("Continue".toLocalize())
                                .mfont(16, .bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .overlay(
                                    ZStack{
                                        if store.isPurchasing{
                                            EZProgressView()
                                        }
                                    }.offset(x : -36)
                                    , alignment: .leading
                                )
                        }
                        .frame(width: 240, height: 48)
                        .contentShape(Rectangle())
                        .background(
                            Capsule()
                                .foregroundColor(.main)
                        )
                    })
                }
                
                
                ZStack{
                    HStack(spacing : 32){
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
                            Text("RESTORE")
                                .mfont(10, .regular)
                                .foregroundColor(.white)
                        })
                        
                        Button(action: {
                            if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                UIApplication.shared.open(url)
                            }
                        }, label: {
                            Text("EULA")
                                .mfont(10, .regular)
                                .foregroundColor(.white)
                        })
                        
                        
                        Button(action: {
                            if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
                                UIApplication.shared.open(url)
                            }
                        }, label: {
                            Text("PRIVACY")
                                .mfont(10, .regular)
                                .foregroundColor(.white)
                        })
                    }
                    
                }.frame(height: 48)
                
                
            }.padding(.top, 32)
            
            
            
            
            
            
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    
    func GiftShowView() -> some View{
        VStack(spacing : 0){
            
            Text("WALLIVE")
                .mfont(28, .bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 1, green: 0.87, blue: 0.19))
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: -4)
                .frame(height: 39)
                .padding(.top, 56)
            Text("PREMIUM".toLocalize())
                .mfont(32, .bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 1, green: 0.87, blue: 0.19))
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: -4)
                .frame(height: 45)
                .padding(.top, -8)
            
            Text("Unlimited Premium Features".toLocalize())
                .mfont(17, .italic)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 263, alignment: .top)
                .padding(.top, 8)
            
            
            Text("-50%")
                .mfont(100, .bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, -16)
            
            Spacer()
            
            if let yearSale = store.yearlv2Sale50Product{
              //  Text("Less than \(getDisplayPrice(price:yearSale.price, chia: 51, displayPrice:yearSale.displayPrice))/Week")
                Text(String(format: NSLocalizedString("Less than %@/week", comment: ""), getDisplayPrice(price:yearSale.price, chia: 51, displayPrice:yearSale.displayPrice)))
                    .mfont(24, .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .padding(.horizontal, 12)
                
              
                Text(String(format: NSLocalizedString("Just %@/year", comment: ""), yearSale.displayPrice))
                    .mfont(15, .regular)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                
                
                Button(action: {
                    if store.purchasedIds.isEmpty{
                        store.isPurchasing = true
                        showProgressSubView()
                        Firebase_log("Sub_click_buy_sub_total")
                        
                        
                        
                        store.purchase(product: yearSale, onBuySuccess: { b in
                            if b {
                                DispatchQueue.main.async{
                                    store.isPurchasing = false
                                    hideProgressSubView()
                                    showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                    onClickClose()
                                    
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
                    Text("Claim Offer")
                        .mfont(20, .bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .frame(width: 240, height: 48)
                        .background(
                            Capsule()
                                .foregroundColor(.main)
                        )
                }).padding(.top, 27)
            }
            
            
            
            
            HStack(spacing : 32){
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
                    Text("RESTORE".toLocalize())
                        .mfont(10, .regular)
                        .foregroundColor(.white)
                })
                
                Button(action: {
                    if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                        UIApplication.shared.open(url)
                    }
                }, label: {
                    Text("EULA")
                        .mfont(10, .regular)
                        .foregroundColor(.white)
                })
                
                
                Button(action: {
                    if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
                        UIApplication.shared.open(url)
                    }
                }, label: {
                    Text("PRIVACY".toLocalize())
                        .mfont(10, .regular)
                        .foregroundColor(.white)
                })
            }
            .padding(.top, 8)
            .padding(.bottom, 18)
            
            
            
            
        }
        .frame(width: 295, height: 480, alignment: .top)
        .background(
            Image("special_gift_bg")
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
        )
        .overlay(alignment: .top){
            Image("new_crown")
                .resizable()
                .frame(width: 126, height: 96)
                .offset(y : -56)
        }
    }
    
    func GiftView() -> some View{
        VStack(spacing : 0){
            Spacer()
            Text("Wow! Here is a special\ndeal for you".toLocalize())
                .mfont(20, .bold, line: 2)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(width: 263, alignment: .top)
                .padding(.bottom, 32)
        }.frame(width: 295, height: 320, alignment: .top)
            .background(
                Image("special_gift")
                    .resizable()
                    .scaledToFit()
            )
            .overlay(alignment: .bottom){
                
                Text("Show me".toLocalize())
                    .mfont(20, .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .frame(width: 240, height: 48)
                    .background(
                        Capsule()
                            .foregroundColor(.main)
                    )
                
                    .contentShape(Rectangle())
                    .onTapGesture {
                        giftOpen.toggle()
                    }
                    .offset(y : 24)
                
                
                
            }
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
                        Text(String(format: NSLocalizedString("%@/month", comment: ""), product.displayPrice))
                       // Text("\(product.displayPrice)/month")
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text(String(format: NSLocalizedString("%@/week", comment: ""), getDisplayPrice(price: product.price, chia: 4, displayPrice: product.displayPrice) ))
                 //   Text("\(decimaPriceToStr(price: product.price ,chia: 4))\(removeDigits(string: product.displayPrice))/week")
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
                        Text(String(format: NSLocalizedString("%@/year", comment: ""), product.displayPrice ))
                      
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text(String(format: NSLocalizedString("%@/week", comment: ""), getDisplayPrice(price: product.price, chia: 51, displayPrice: product.displayPrice) ))
               //     Text("\(decimaPriceToStr(price: product.price ,chia: 51))\(removeDigits(string: product.displayPrice))/week")
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
    
}
