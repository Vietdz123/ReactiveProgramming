//
//  OnbooaringHasFreeTrial.swift
//  WallpaperIOS
//
//  Created by Duc on 11/05/2024.
//

import SwiftUI
import AVKit
import StoreKit
import GoogleMobileAds
import UserMessagingPlatform
import AppTrackingTransparency

struct OnbooaringHasFreeTrial: View {
    @State var currentPage : Int = 1
    @EnvironmentObject var store : MyStore
    @State var isBuyYear : Bool = true
    @State var enableFreeTrial : Bool = false
    
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
                ScreenUserFeedbackView()
                    .tag(9)
                Screen_10()
                    .tag(10)

                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .background(Color.black)
                .onChange(of: currentPage, perform: { page in
                    if page == 10 {
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
                        if currentPage == 10  && showXmark {
                            Button(action: {
                                UserDefaults.standard.set(true, forKey: "firstTimeLauncher")
                                    withAnimation{
                                        navigateToHome.toggle()
                                    }
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

extension OnbooaringHasFreeTrial{
    func content() -> some View{
        VStack(spacing : 0){
            ZStack{
                if currentPage < 10 {
                    VStack(spacing : 0){
                        
                        Text(getTextTitle(page:currentPage).toLocalize())
                            .mfont(32, .bold, line: 2)
                            .foregroundColor(.main)
                            .multilineTextAlignment(.center)
                            .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay( 0.2 ) , value: currentPage)
                            .padding(.horizontal, 48)
                        Text(getTextSubTitle(page:currentPage).toLocalize())
                            .mfont(currentPage == 9 ? 15 : 24, .regular, line: 2)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: .infinity, maxHeight : .infinity, alignment : .bottom)
                    .padding(.bottom, 24)
                    
                    
                }else if currentPage == 10 {
       
                    OnboadingSubFreeTrialView(isBuyYear: $isBuyYear, enableFreeTrial: $enableFreeTrial)
                        .environmentObject(store)
                       
                    
                    
                    
                    
                }

                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: {
                
                if currentPage < 10 {
                    withAnimation(.linear){
                        currentPage += 1
                    }
                }else if currentPage == 10 {
                    UserDefaults.standard.set(true, forKey: "firstTimeLauncher")
                    Firebase_log("Click_Buy_Sub_In_Onb")
                    
                    
                    if isBuyYear {
                        if let yearProduct = store.getYearOriginUsingProduct() {
                            Firebase_log("Click_Buy_Sub_In_Onb_Year")
                            purchasesss(product: yearProduct, string: "Onb_Year")
                        }
                    }else {
                        if enableFreeTrial {
                            if let weekPro = store.weekFreeTrialProduct {
                                Firebase_log("Click_Buy_Sub_In_Onb_Week_FT")
                                purchasesss(product: weekPro, string: "Onb_Week_FT")
                            }
                        }else{
                            if let weekPro = store.weekProductNotSale {
                                Firebase_log("Click_Buy_Sub_In_Onb_Week")
                                purchasesss(product: weekPro, string: "Onb_Week")
                            }
                        }
                    }

                    
                }

                
                
            }, label: {
                HStack{
                    Text(currentPage == 10 ? "START NOW" : "Continue")
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
                    if currentPage == 10 {
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
        }else if page == 9{
            return "Trusted by 150,000+\nUsers Worldwide!"
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
        }else if page == 9 {
            return "Let's explore great experiences!"
        }else{
            return ""
        }
    }
    
    
    
   

    
}

extension OnbooaringHasFreeTrial {
    
    func rootView() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first   as? UIWindowScene
        else{
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }
    
    //MARK: show ATT and GDPR
    func showATTandGDPR(){
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            
            Firebase_log("ATT_Tracking_show")
            if status == .authorized{
                Firebase_log("ATT_Tracking_authorized")
            }
            
            // Create a UMPRequestParameters object.
            let parameters = UMPRequestParameters()
            // Set tag for under age of consent. false means users are not under age
            // of consent.
            let debugSettings = UMPDebugSettings()
            debugSettings.testDeviceIdentifiers = ["2CCEC876-0E47-4237-865A-78C8D7B08814"]
            debugSettings.geography = .EEA
            parameters.debugSettings = debugSettings
            parameters.tagForUnderAgeOfConsent = false
            
            // Request an update for the consent information.
            UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
                requestConsentError in
                
                if let consentError = requestConsentError {
                    // Consent gathering failed.
                    return print("Error: \(consentError.localizedDescription)")
                }
                
                UMPConsentForm.loadAndPresentIfRequired(from: rootView()) { (loadAndPresentError) in
                    
                    if let consentError = loadAndPresentError {
                        return print("Error: \(consentError.localizedDescription)")
                    }
                    
                    
                    print("chay vao day khong")
                    GADMobileAds.sharedInstance().start()
                    rewardAd.loadRewardedAd()
                    interAd.loadInterstitial()
                    
                    
                }
            }
            
            
        })
    }
    
    
    //MARK: Video screen
    
    func Screen_1() -> some View{
        VideoOnboarding(video_name: "video1")
    }
    
    func Screen_2() -> some View{
        VideoOnboarding(video_name: "live")
    }
    
    func Screen_3() -> some View{
        VideoOnboarding(video_name: "intro 2")
    }
    func Screen_4() -> some View{
        VideoOnboarding(video_name: "depth_effect")
    }
    func Screen_5() -> some View{
        VideoOnboarding(video_name: "shuffle_packs")
    }
    
    func Screen_6() -> some View{
        VideoOnboarding(video_name: "watchface")
        
    }
    
    func Screen_7() -> some View{
        VideoOnboarding(video_name: "video5")
        
    }
    
    func Screen_8() -> some View{
        VideoOnboarding(video_name: "intro 6")
        
    }
    
    func Screen_10() -> some View{
        VideoOnboarding(video_name: "bg")
        
    }
    
 
    
}
