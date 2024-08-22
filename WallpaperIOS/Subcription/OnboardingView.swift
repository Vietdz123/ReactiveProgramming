//
//  OnboardingVerTwoSubView.swift
//  WallpaperIOS
//
//  Created by Duc on 21/09/2023.
//

import SwiftUI
import AVKit
import StoreKit
import GoogleMobileAds
import UserMessagingPlatform
import AppTrackingTransparency

struct OnboardingView: View {
    @State var currentPage : Int =  1 //1
    @EnvironmentObject var store : MyStore
    @State var currentProduct : Int = 2
    
    @State var showXmark : Bool =  false
    @State var navigateToHome : Bool = false
    
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var rewardAd : RewardAd
    
    let list_1 : [String] = [
        "100% free during the trial.",
        "Easily cancel anytime.",
        "Get full access to all features and content. Why not try?",
        "One-time-only offer for new user. The first 3-day is on us."
    ]
    
  
    
    var body: some View {
        ZStack{
            NavigationLink(destination:
                            EztMainView()
                           
                .environmentObject(homeVM)
                .environmentObject(store)
                .environmentObject(interAd)
                .environmentObject(rewardAd)
                           , isActive: $navigateToHome, label: {
                EmptyView()
            })
            
            TabView(selection: $currentPage )  {
                Screen_1()
                    .tag(1)
                Screen_2()
                    .tag(2)
                Screen_3()
                    .tag(3)
                Screen_4()
                    .tag(4)
                Screen_5()
                    .tag(5)
                Screen_6()
                    .tag(6)
                Screen_7()
                    .tag(7)
                Screen_8()
                    .tag(8)
                Screen_9()
                    .tag(9)

                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .background(Color.black)
                .onChange(of: currentPage, perform: { page in
                    if page == 7 {
                        withAnimation(.easeIn){
                            showXmark = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                            withAnimation(.easeInOut){
                                showXmark = true
                            }
                        })
                    }
                })
                .overlay(
                    content()
                )
                .overlay(
                    ZStack{
                        if currentPage == 9  && showXmark {
                            Button(action: {
                                UserDefaults.standard.set(true, forKey: "firstTimeLauncher")
                            
                                    navigateToHome.toggle()
                               
                                       
                                   
                            }, label: {
                                Image("close.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .frame(width: 56, height: 40, alignment: .center)
                                    .opacity(0.5)
                            })
                        }
                        
                    }
                    
                    , alignment: .topTrailing
                )
            
                .overlay(
                    ZStack{
                        if store.isPurchasing {
                            ProgressBuySubView()
                        }
                    }
                )
            
        }

        .onAppear(perform: {
           showATTandGDPR()
        })
        
        
    }
    
   
    

}

extension OnboardingView{
    func content() -> some View{
        VStack(spacing : 0){
            ZStack{
                if currentPage < 9 {
                    VStack(spacing : 0){
                        
                        Text(getTextTitle(page:currentPage).toLocalize())
                            .mfont(32, .bold)
                            .foregroundColor(.main)
                            .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay( 0.2 ) , value: currentPage)
                            .padding(.horizontal, 48)
                        Text(getTextSubTitle(page:currentPage).toLocalize())
                            .mfont(24, .regular, line: 2)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: .infinity, maxHeight : .infinity, alignment : .bottom)
                    .padding(.bottom, 24)
                    
                    
                }else if currentPage == 9 {
       
                    Page_9_View(currentProduct: $currentProduct, navigateToHome : $navigateToHome)
                        .environmentObject(store)
          
                    
                    
                    
                    
                }

                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: {
                
                if currentPage < 9 {
                    withAnimation(.linear){
                        currentPage += 1
                    }
                }else if currentPage == 9 {
                    UserDefaults.standard.set(true, forKey: "firstTimeLauncher")
                    Firebase_log("Click_Buy_Sub_In_Onb")
                    
                    
                    
                    if currentProduct == 1 {
                        if let weekPro = store.weekProductNotSale {
                            Firebase_log("Click_Buy_Sub_In_Onb_Week")
                            purchasesss(product: weekPro, string: "Onb_Week")
                        }
                    }else if  currentProduct == 2 {
                        if let yearPro = store.lifeTimeProduct {
                            Firebase_log("Click_Buy_Sub_In_Onb_Year")
                            purchasesss(product: yearPro, string: "Onb_Year_FreeTrial")
                        }
                    }
                    
                    
                }

                
                
            }, label: {
                HStack{
                    
                    
                    Text(currentPage == 9 ? "START NOW" : "Continue")
                        .mfont(currentPage == 9 ?  20 : 16, .bold, line: 2)
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
            .padding(.bottom, 56)
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .background(
                VStack(spacing : 0){
                    Spacer()
                    LinearGradient(colors: [Color("black_bg").opacity(0), Color("black_bg")], startPoint: .top, endPoint: .bottom)
                        .frame(height : 120)
                    Color("black_bg")
                        .frame(height : 180)
                }.ignoresSafeArea()
            )
            .overlay(
                ZStack{
                    if currentPage >= 8 {
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
                            
                            
                            
                        }.edgesIgnoringSafeArea(.bottom)
                    }
                }
                
                
                
                
                , alignment: .bottom
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
    
    
    func getTextTitle(page : Int) -> String{
        if page == 1 {
            return "100000+"
        }else if page == 2 {
            return "Live Wallpapers"
        }else if page == 3 {
            return "Lighting Effects"
        }else if page == 4 {
            return "Depth Effect"
        }else if page == 5 {
            return "Shuffle Packs"
        }else if page == 6 {
            return "Watch Faces"
        }else if page == 7{
            return "Widgets"
        }else if page == 8{
            return "Ai Generator Art"
        }else{
            return ""
        }
    }
    
    func getTextSubTitle(page : Int) -> String{
        if page == 1 {
            return "4K Wallpapers"
        }else if page == 2 {
            return "Vivid every detail"
        }else if page == 3 {
            return "Unique and Exclusive"
        }else if page == 4 {
            return "Amazing 3D effects"
        }else if page == 5 {
            return "Automatically change exciting wallpapers"
        }else if page == 6 {
            return "Trendy and stylish"
            
        }else if page == 7 {
            return "An exclusive experience like never before"
        }else if page == 8 {
            return "Unprecedented experience"
        }else{
            return ""
        }
    }
    
    
    
   

    
}


#Preview {
    SplashView()
    
}
