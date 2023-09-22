//
//  OnboardingVerTwoSubView.swift
//  WallpaperIOS
//
//  Created by Duc on 21/09/2023.
//

import SwiftUI
import AVKit
import StoreKit
#Preview {
    OnboardingVerTwoSubView()
        .environmentObject(MyStore())
}


struct OnboardingVerTwoSubView: View {
    @State var currentPage : Int =  1
    @EnvironmentObject var store : MyStore
    @State var currentProduct : Int = 2
    
    
    @State var navigateToHome : Bool = false
    
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var rewardAd : RewardAd
    
    let list_1 : [String] = [
        "100% free during the trial.",
        "Easily cancel anytime.",
        "Get full access to all features and content. Why not try?",
        "One-time-only offer for new user. The firrst week is on us."
    ]
    
    
 
    
    
    var body: some View {
        ZStack{
            NavigationLink(destination:
                            MainView()
                           
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
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .background(Color.black)
                .overlay(
                    content()
                )
                .overlay(
                    ZStack{
                        if currentPage >= 5 {
                            Button(action: {
                                if currentPage == 5 {
                                    withAnimation(.linear){
                                        currentPage = 6
                                    }
                                    
                                }else{
                                    withAnimation{
                                        navigateToHome.toggle()
                                    }
                                }
                            }, label: {
                                Image("close.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                            }).padding(.horizontal, 16)
                        }
                     
                    }
                    
                    , alignment: .topTrailing
                )
            
        }
   
            
    
    }
}

extension OnboardingVerTwoSubView{
    
    
    func content() -> some View{
        VStack(spacing : 0){
            
            ZStack{
                if currentPage < 5 {
                    
                    VStack(spacing : 0){
                        
                        Text(getTextTitle(page:currentPage))
                        .mfont(32, .bold)
                        .foregroundColor(.main)
                       
                        .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay( 0.2 ) , value: currentPage)
                        .padding(.horizontal, 48)
                        Text(getTextSubTitle(page:currentPage))
                        .mfont(24, .regular)
                        .foregroundColor(.white)
                        
                      
                        .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay( 0.2 ) , value: currentPage)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 48)
                        
                        
                    }.frame(maxWidth: .infinity, maxHeight : .infinity, alignment : .bottom)
                        .padding(.bottom, 24)
                    
                    
                }else if currentPage == 5 {
                    Page_5(currentProduct: $currentProduct)
                        .environmentObject(store)
                }else{
                  Page_6()
                }
                      
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: {
              
                    if currentPage < 5 {
                        withAnimation(.linear){
                            currentPage += 1
                        }
                    }else if currentPage == 5 {
                        if currentProduct == 1 {
                            if let monthPro = store.monthProductV2 {
                                purchasesss(product: monthPro)
                            }
                        }else if  currentProduct == 2 {
                            if let yearPro = store.yearlyFreeTrialProduct {
                                purchasesss(product: yearPro)
                            }
                        }else if  currentProduct == 3 {
                            if let threeMonthPro = store.threeMonthProduct {
                                purchasesss(product: threeMonthPro)
                            }
                        }
                        
                        
                    }else if currentPage == 6 {
                        if let yearPro = store.yearlyFreeTrialProduct {
                            purchasesss(product: yearPro)
                        }
                    }
                   
                
                
            }, label: {
                HStack{
                    
                  
                    Text(( currentProduct == 2 && currentPage == 5 ) ? "Try for free" : "Continue")
                    .mfont(16, .bold)
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
            .padding(.bottom, 64)
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
                    if currentPage == 5 || currentPage == 6 {
                        HStack(spacing : 4){
                            Button(action: {
                                if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("Privacy Policy").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            })
                            
                            Text("|").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            
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
                                Text("Restore").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            })
                            
                            Text("|").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            
                            Button(action: {
                                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("Term of use").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            })
                            
                          
                            
                        }.edgesIgnoringSafeArea(.bottom)
                    }
                }
                    
                   
                    
               
                , alignment: .bottom
            )
    }
    
    
    func purchasesss(product : Product) {
        store.isPurchasing = true
        showProgressSubView()
        Firebase_log("Click_buy_in_onboarding")
        store.purchase(product: product, onBuySuccess: { b in
            if b {

                DispatchQueue.main.async{
                    store.isPurchasing = false
                    hideProgressSubView()
                    Firebase_log("Click_buy_in_onboarding_successful")
                    
                    showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                    withAnimation{
                        navigateToHome.toggle()
                    }
                }
            }else{
                DispatchQueue.main.async{
                    store.isPurchasing = false
                    hideProgressSubView()
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
            return "Depth Effect"
        }else if page == 4 {
            return "Shuffle Packs"
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
            return "Amazing 3D effects"
        }else if page == 4 {
            return "Automatically change exciting wallpapers"
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
        VideoOnboarding(video_name: "depth_effect")
    }
    func Screen_4() -> some View{
        VideoOnboarding(video_name: "shuffle_packs")
    }
    
    func Screen_5() -> some View{
        VideoOnboarding(video_name: "video4")
    }
    
   
    
    func Screen_6() -> some View{
        Image("bg_sc6")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .clipped()
            .gesture(DragGesture())
    }
    
    func Page_6() -> some View{
        VStack(spacing : 0){
            Text("Wait a Moment")
                .mfont(24, .bold)
                .foregroundColor(.main)
                .padding(.top, 100  )
                .frame(maxWidth: .infinity, alignment : .leading)
                .padding(.horizontal, 40)
            Text("Consider the following before you")
                .mfont(17, .regular)
              .foregroundColor(.white)
            
              .frame(maxWidth: .infinity, alignment : .leading)
              .padding(.horizontal, 40)
            Text("make the final decistion")
                .mfont(17, .regular)
              .foregroundColor(.white)
            
              .frame(maxWidth: .infinity, alignment : .leading)
              .padding(.horizontal, 40)
            
            Spacer()
            
         
                VStack(spacing : 16){
                    ForEach(list_1, id: \.self){ opt in
                        HStack(spacing : 16){
                            Image("check")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text(opt)
                                .mfont(17, .bold)
                                .foregroundColor(.white)
                            
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                            .padding(.horizontal, 40)
                    }
                }
                
            if let yearlyFreeTrialProduct = store.yearlyFreeTrialProduct {
                Text("Try 7 days for free")
                    .mfont(17, .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 56)
                
                Text("Then \(yearlyFreeTrialProduct.displayPrice)/year. No Payment Now")
                    .mfont(13, .regular)
                    .foregroundColor(.white)
            }
            
             
           
                
            
           
            
           
            
            
        }
        .frame(maxWidth: .infinity, maxHeight : .infinity, alignment : .top)
        .background(
            LinearGradient(colors: [Color("black_bg").opacity(0.2),
                                    Color("black_bg").opacity(0.6),
                                    Color("black_bg").opacity(0.8),
                                    Color("black_bg"),
                                    Color("black_bg")], startPoint: .top, endPoint: .bottom)
        ).padding(.bottom, 24)
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

struct Page_5: View {
    
    @Binding var currentProduct : Int
    @EnvironmentObject var store : MyStore
    let list_2 : [String] = [
        "No ADs.",
        "All Live Wallpapers.",
        "All Exclusive Wallpapers.",
        "All Special Wallpapers."
    ]
    
    
    var body: some View {
        VStack(spacing : 0){
            Spacer()
            
            VStack(spacing : 16){
                HStack(spacing : 23){
                    Image("star_5")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                    
                    Text("Wallive Premium")
                        .mfont(24, .bold)
                    .foregroundColor(.main)
                    
                }.frame(maxWidth: .infinity, alignment : .leading)
                    
                    .padding(.leading, 63)
                
                
                ForEach(list_2, id: \.self){
                    opt in
                    
                    HStack(spacing : 23){
                        Image("star_1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                        
                        Text("All Exclusive Wallpapers.")
                            .mfont(17, .bold)
                        .foregroundColor(.white)
                        
                    }.frame(maxWidth: .infinity, alignment : .leading)
                        .frame(height: 24)
                        .padding(.leading, 73)
                    
                }
                
             
            }
            
            if let monthProduct = store.monthProductV2,
               let yearTrialProduct = store.yearlyFreeTrialProduct,
               let threeMonthProduct = store.threeMonthProduct  {
                
                GeometryReader{
                    proxy in
                    let size = proxy.size
                    let widthItem = ( size.width - 48 ) / 5
                    
                 
                    
                    HStack(spacing : 8){
                        
                   
                        ZStack(alignment: .bottom){
                            Color.clear
                            
                          
                                
                            
                            if currentProduct == 1 {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.main)
                                    .frame( height: 100)
                            }
                            
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.mblack_bg)
                                .frame( height: 96)
                                .padding(2)
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.15))
                                .frame( height: 96)
                                .padding(2)
                            
                            
                            VStack(spacing : 0){
                                Text("1")
                                    .mfont(17, .bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.top, 8)
                                Text("MONTH")
                                    .mfont(17, .bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                                Text("\(monthProduct.displayPrice)/mo.")
                                    .mfont(13, .regular)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                                
                                Text("Billed monthly")
                                    .mfont(9, .regular)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                                
                            }.frame( height: 96, alignment : .top)
                                .padding(2)
                           
                           
                            
                        }.frame(width: widthItem * 1.5)
                            .frame(maxHeight: .infinity)
                            .onTapGesture {
                                withAnimation{
                                    currentProduct = 1
                                }
                            }
                        
                        ZStack(alignment: .bottom){
                           
                            
                            RoundedRectangle(cornerRadius: 16)
                                .fill(currentProduct == 2 ? Color.main : Color.main.opacity(0.4))
                                .overlay(
                                    Text("7-Day Free Trial")
                                        .mfont(15, .bold)
                                        .foregroundColor(.black)
                                        .frame( height: 40)
                                    , alignment: .top
                                )
                            
                            VStack(spacing : 0){
                                Text("12")
                                    .mfont(17, .bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.top, 8)
                                Text("MONTH")
                                    .mfont(17, .bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                                Text("\(decimaPriceToStr(price: yearTrialProduct.price , chia: 12))\(removeDigits(string: yearTrialProduct.displayPrice ))/mo.")
                                    .mfont(13, .regular)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                                
                                Text("Billed annually")
                                    .mfont(9, .regular)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                                
                            }
                            .frame(maxWidth : .infinity)
                            .frame( height: 100, alignment : .top)
                                .background(
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                LinearGradient(colors: [Color.mblack_bg, Color.mblack_bg , Color.mblack_bg ,Color.mblack_bg.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                                            )
                                            .frame( height: 100)
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white.opacity(0.15))
                                            .frame( height: 100)
                                    }
                                )
                                .padding(2)
                            
                        }.frame(width: widthItem * 2, height: size.height)
                            .onTapGesture {
                                withAnimation{
                                    currentProduct = 2
                                }
                            }
                           
                        
                        ZStack(alignment: .bottom){
                            
                            RoundedRectangle(cornerRadius: 16)
                                .fill(currentProduct == 3 ? Color.main : Color.main.opacity(0.4))
                                .overlay(
                                    Text("Popular")
                                        .mfont(15, .bold)
                                        .foregroundColor(.black)
                                        .frame( height: 40)
                                    , alignment: .top
                                )
                            VStack(spacing : 0){
                                Text("3")
                                    .mfont(17, .bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.top, 8)
                                Text("MONTH")
                                    .mfont(17, .bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                                Text("\(decimaPriceToStr(price: threeMonthProduct.price , chia: 3))\(removeDigits(string: threeMonthProduct.displayPrice ))/mo.")
                                    .mfont(13, .regular)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                                
                                Text("Billed quarterly")
                                    .mfont(9, .regular)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                                
                            }
                            .frame(maxWidth : .infinity)
                            .frame( height: 100, alignment : .top)
                                .background(
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                LinearGradient(colors: [Color.mblack_bg, Color.mblack_bg , Color.mblack_bg ,Color.mblack_bg.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                                            )
                                            .frame( height: 100)
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white.opacity(0.15))
                                            .frame( height: 100)
                                    }
                                   
                                )
                                .padding(2)
                            
                        }.frame(width: widthItem * 1.5, height: size.height)
                            .onTapGesture {
                                withAnimation{
                                    currentProduct = 3
                                }
                            }
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight : .infinity, alignment : .bottom)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .padding(.horizontal, 8)
                .padding(.top, 32)
                .padding(.bottom, 8)
                
                
                VStack(spacing : 4 ){
                    ZStack{
                        Color.clear
                        if currentProduct == 2 {
                            HStack{
                                Image("protected")
                                    .resizable()
                                    .frame(width: 16, height: 16, alignment: .center)
                                
                                Text("No Payment Now!")
                                    .mfont(13, .bold)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                            }
                        }
                      
                    }.frame( height: 18)
                    ZStack{
                        if currentProduct == 1 {
                            Text("Just \(monthProduct.displayPrice) per month, cancel any time.")
                                .mfont(11, .regular)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }else if currentProduct == 2 {
                            Text("Just \(yearTrialProduct.displayPrice) per year, cancel any time.")
                                .mfont(11, .regular)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }else if currentProduct == 3 {
                            Text("Just \(threeMonthProduct.displayPrice) per 3 months, cancel any time.")
                                .mfont(11, .regular)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                    }.frame(height : 15)
                    
                  
                        
                }.frame(height : 37, alignment: .bottom)
                
            }
            
            
            
            
            
              
            
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(
                LinearGradient(colors: [Color("black_bg").opacity(0.0),
                                        Color("black_bg").opacity(0.4),
                                        Color("black_bg"),
                                        Color("black_bg")], startPoint: .top, endPoint: .bottom)
            ).padding(.bottom, 24)
    }
}

