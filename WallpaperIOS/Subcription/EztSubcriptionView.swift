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
    
    @EnvironmentObject var store : MyStore 
    
    @Namespace var anim
    @Environment(\.presentationMode) var presentationMode
    
   
    
    @State var buyType : BuyType = .YEARLY
    @State var player : AVPlayer?
    @State var isT1 : Bool = true
    
    @State var showBtnClose : Bool = false
    
    @State var currentProduct : Int = 2
 
    let list_2 : [String] = [
        "Unlimited Premium Wallpapers",
        "Unlimited Premium Widgets",
        "Unlimited AI-Generate",
        "Ad-free experience"
        
    ]
    
    var body: some View {
        ZStack{
            if player != nil {
                MyVideoPlayer(player: player!)
                    .ignoresSafeArea()
                
                LinearGradient(colors: [.clear, .clear, .black, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
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
                       let lifeTimeProduct = store.lifeTimeProduct
                    {
                        
                        Opt_Week(product: weekProduct)
                            .padding(.top, 16)
                        Opt_LifeTime(product: lifeTimeProduct)
                            .padding(.top, 16)
                      
                        HStack(spacing : 4){
                            if currentProduct == 1 {
                                Text("Auto-renewable, cancel anytime.")
                                    .mfont(11, .regular)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            }else{
                                Image("shield 1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                
                                Text("Cancel anytime.")
                                    .mfont(11, .regular)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            }
                        }.padding(.top,   16)

                        Button(action: {
                            
                         
                                
                                
                                if currentProduct == 1 {
                                    if let weekPro = store.weekProductNotSale {
                                        Firebase_log("Click_Buy_Sub_In_Onb_Week")
                                        purchasesss(product: weekPro, string: "Onb_Week")
                                    }
                                }else if  currentProduct == 2 {
                                    if let yearPro = store.lifeTimeProduct  {
                                        Firebase_log("Click_Buy_Sub_In_Onb_Year")
                                        purchasesss(product: yearPro, string: "Onb_Year_FreeTrial")
                                    }
                                }
                                
                                
                            

                            
                            
                        }, label: {
                            HStack{
                                
                                
                                Text("START NOW" )
                                    .mfont( 20 , .bold)
                                    .foregroundColor(.black)
                                
                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height : 56)
                            .contentShape(Rectangle())
                            .overlay(
                                ZStack{
                                    ResizableLottieView(filename: "arrow")
                                        .frame(width: 32, height: 32 )
                                        .padding(.trailing , 24)
                                }
                                
                                
                                , alignment: .trailing
                            )
                        })
                        .background(
                            Capsule().fill(Color.main)
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                        .padding(.bottom, 18)
                        HStack(spacing : 4){
                            Button(action: {
                                if let url = URL(string: "https://docs.google.com/document/d/1EY8f5f5Z_-5QfqAeG2oYdUxlu-1sBc-mgfco2qdRMaU") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("Privacy Policy".toLocalize()).mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            })
                            
                            Text("|").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            
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
                                Text("Restore".toLocalize()).mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            })
                            
                            Text("|").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            
                            Button(action: {
                                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("Term of use".toLocalize()).mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            })
                            
                            
                            
                        }
                    }
                    
                 
                    
                   
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .ignoresSafeArea()
            .background(
                VisualEffectView(effect: UIBlurEffect(style: .dark)).ignoresSafeArea()
            )
            .overlay(
                ZStack{
                   
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("close.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .frame(width: 56, height: 40, alignment: .center)
                                .opacity(0.5)
                        })
               
                    
                }
                
                , alignment: .topTrailing
            )
           
            
            
            
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
        .environmentObject(MyStore())
}




extension EztSubcriptionView{
    func purchasesss(product : Product, string : String) {
        store.isPurchasing = true
        store.purchase(product: product, onBuySuccess: { b in
            if b {
                DispatchQueue.main.async{
                    store.isPurchasing = false
                    Firebase_log("Buy_Sub_Success_In_\(string)")
                    showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                    presentationMode.wrappedValue.dismiss()
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
                Circle().stroke(Color.white.opacity(0.7), lineWidth: 1)
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
                            .opacity(currentProduct == 1 ? 1 : 0.7)
                       
//                        Text(String(format: NSLocalizedString("%@/week", comment: ""), product.displayPrice))
//                            .mfont(12, .regular)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    VStack(alignment: .trailing, content: {
                        Text(product.displayPrice)
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .opacity(currentProduct == 1 ? 1 : 0.7)
                        
                        Text("per week")
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .opacity(currentProduct == 1 ? 1 : 0.7)
                           
                    }) .padding(.trailing, 16)
                    
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
    
    func Opt_LifeTime(product : Product) -> some View {
        HStack(spacing : 0){
            ZStack{
                Circle()
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
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
                    VStack(alignment: .leading ,spacing : 2){
                        Text("LifeTime")
                            .mfont(16, .bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(currentProduct == 2 ? 1 : 0.7)
                        Text("One-time payment")
                        
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(currentProduct == 2 ? 1 : 0.7)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    VStack(alignment: .trailing){
                        Text(product.displayPrice)
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .padding(.trailing, 16)
                            .opacity(currentProduct == 2 ? 1 : 0.7)
                        Text("billed once")
                            .mfont(12, .regular)
                            .foregroundColor(.white)
                            .padding(.trailing, 16)
                            .opacity(currentProduct == 2 ? 1 : 0.7)
                    }
                    
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
