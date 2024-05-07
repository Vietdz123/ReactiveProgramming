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

struct OnboardingVerTwoSubView: View {
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
    
    private let formViewControllerRepresentable = FormViewControllerRepresentable()
    
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
            
            
            
            
            
        })
        
        
    }
    
    
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
}

extension OnboardingVerTwoSubView{
    
    
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
                        //      .fixedSize()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 32)
                        
                        //                        .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay( 0.2 ) , value: currentPage)
                        
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight : .infinity, alignment : .bottom)
                    .padding(.bottom, 24)
                    
                    
                }else if currentPage == 9 {
       
                    Page_8_View_2(currentProduct: $currentProduct, navigateToHome : $navigateToHome)
                        .environmentObject(store)
          
                    
                    
                    
                    
                }
//                else{
//                    Page_9()
//                    
//                }
                
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
                        if let yearPro = store.getYearOriginUsingProduct()  {
                            Firebase_log("Click_Buy_Sub_In_Onb_Year_FreeTrial")
                            purchasesss(product: yearPro, string: "Onb_Year_FreeTrial")
                        }
                    }else if  currentProduct == 3 {
                        if let month24Pro = store.monthProduct {
                            Firebase_log("Click_Buy_Sub_In_Onb_Month")
                            purchasesss(product: month24Pro, string: "Onb_Month")
                        }
                    }
                    
                    
                }
//                else if currentPage == 9 {
//                    UserDefaults.standard.set(true, forKey: "firstTimeLauncher")
//                    if let yearPro = store.yearlyFreeTrialProduct {
//                        Firebase_log("Click_Buy_Sub_In_Consider_Year_FT")
//                        purchasesss(product: yearPro, string: "Consider_Year_FT")
//                    }
//                }
                
                
                
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
    
    func Screen_9() -> some View{
        
        VideoOnboarding(video_name: "bg")
        
        
    }
    

    
}

struct VideoOnboarding : View{
    
    @State var avPlayer : AVPlayer?
    let video_name : String
    
    
    var body: some View{
        ZStack{
            if  avPlayer != nil{
                MyVideoPlayer(player: avPlayer!)
                    .ignoresSafeArea()
                    .gesture(DragGesture())
            }
        }
        
        .onAppear(perform: {
            if let url =  Bundle.main.url(forResource: video_name, withExtension: "mp4") {
                avPlayer = AVPlayer(url: url)
                avPlayer!.play()
            }
            
        })
        .onDisappear(perform: {
            if avPlayer != nil{
                avPlayer!.pause()
            }
            avPlayer = nil
        })
        
        
    }
}


struct VideoOnboardingForSC5 : View{
    
    @State var avPlayer : AVPlayer?
    let video_name : String
    
    
    var body: some View{
        ZStack(alignment: .top) {
            
            if let avPlayer {
                VStack(spacing : 0){
                    MyVideoPlayer(player: avPlayer, aspect: .resizeAspect)
                    Spacer()
                }
                
                
                .ignoresSafeArea()
                .gesture(DragGesture())
            }
        }
        
        .onAppear(perform: {
            avPlayer = AVPlayer(url:  Bundle.main.url(forResource: video_name, withExtension: "mp4")!)
            avPlayer!.play()
        })
        .onDisappear(perform: {
            if avPlayer != nil{
                avPlayer!.pause()
            }
            avPlayer = nil
        })
        
        
    }
}





struct Page_8_View_2 : View {
    
    
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
                    //   Color.white.opacity(0.2)
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
                        .padding(.top,  UserDefaults.standard.bool(forKey: "using_btn_for_freetrial") ? 12 : 16)
                    

                    
                    
                    
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
                Circle()
                    .stroke(Color.white, lineWidth: 1)
                
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
                    //     Text("\(decimaPriceToStr(price: product.price ,chia: 51))\(removeDigits(string: product.displayPrice))/week")
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
#Preview {
    SplashView()
    
}
