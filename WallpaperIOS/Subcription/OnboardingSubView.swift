////
////  OnboardingSubView.swift
////  WallpaperIOS
////
////  Created by Mac on 26/06/2023.
////
//
//import SwiftUI
//import AVKit
//struct OnboardingSubView: View {
//    @State var page : Int = 0
//    @State var navigateToHome : Bool = false
//    @EnvironmentObject var homeVM : HomeViewModel
//    @EnvironmentObject var store : MyStore
//    @EnvironmentObject var interAd : InterstitialAdLoader
//    @EnvironmentObject var rewardAd : RewardAd
//    @State var showBtnClose : Bool = false
//    var body: some View {
//        ZStack{
//            
//            
//            VStack{
//                TabView(selection: $page, content: {
//                    
//                    ScreenOne().ignoresSafeArea().gesture(DragGesture()).tag(0)
//                    ScreenSecond().ignoresSafeArea().gesture(DragGesture()).tag(1)
//                    ScreenThird().ignoresSafeArea().gesture(DragGesture()).tag(2)
//                    ScreenFour().ignoresSafeArea().gesture(DragGesture()).tag(3)
//                    ScreenFive()
//                        .environmentObject(store)
//                        .ignoresSafeArea()
//                        .gesture(DragGesture()).tag(4)
//                    
//                })
//                
//                .tabViewStyle(.page(indexDisplayMode: .never))
//                .background(Color.black)
//                .ignoresSafeArea()
//                .onChange(of: page, perform: {
//                    newValue in
//                    if newValue == 4 {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
//                            showBtnClose = true
//                        })
//                    }
//                })
//                .overlay(
//                    ZStack{
//                        if page > 3 && showBtnClose {
//                            Button(action: {
//                                withAnimation{
//                                    UserDefaults.standard.set(true, forKey: "firstTimeLauncher")
//                                    navigateToHome.toggle()
//                                }
//                                
//                            }, label: {
//                                Image("close.circle.fill")
//                                    .resizable()
//                                    .frame(width: 24, height: 24)
//                                    .frame(width: 56, height: 40, alignment: .center)
//                                    .opacity(0.5)
//                            })
//                            
//                        }
//                    }, alignment: .topTrailing
//                    
//                )
//                
//            }
//            
//            
//            ZStack{
//                VStack(spacing : 0){
//                    Spacer()
//                    LinearGradient(colors: [Color("black_bg").opacity(0), Color("black_bg")], startPoint: .top, endPoint: .bottom)
//                        .frame(height : 120)
//                    Color("black_bg")
//                        .frame(height : 180)
//                }.ignoresSafeArea()
//                
//                VStack(spacing : 0){
//                    
//                    Spacer()
//                    
//                    if page == 4{
//                        Image("allfeatures")
//                            .resizable()
//                            .frame(width: 138, height: 120)
//                        Text("Unlock All Premium Features")
//                            .mfont(16, .bold)
//                            .foregroundColor(.white)
//                            .padding(.bottom, 12)
//                        if let  weekly = store.weekProductNotSale {
//                            Text("Only \(weekly.displayPrice) per week.")
//                                .mfont(12, .regular)
//                                .foregroundColor(.white)
//                            Text("Auto-renewable. Cancel anytime.")
//                                .mfont(12, .regular)
//                                .foregroundColor(.white)
//                                .padding(.bottom, 32)
//                        }
//                        
//                        
//                        
//                        
//                        
//                    }else{
//                        Text(getTextTitle(page:page))
//                            .foregroundColor(.main)
//                            .mfont(32, .bold)
//                        
//                            .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay( 0.2 ) , value: page)
//                        Text(getTextSubTitle(page:page))
//                            .foregroundColor(.white)
//                            .mfont(24, .regular)
//                            .multilineTextAlignment(.center)
//                            .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1), value: page)
//                            .padding(.horizontal, 27)
//                            .padding(.bottom, 32)
//                    }
//                    
//                    
//                    
//                    Button(action: {
//                        if page < 4 {
//                            withAnimation(.linear){
//                                page += 1
//                            }
//                            
//                        }else{
//                            Firebase_log("Click_Buy_Sub_In_Onb")
//                            UserDefaults.standard.set(true, forKey: "firstTimeLauncher")
//                            if let weekPro = store.weekProductNotSale {
//                                store.isPurchasing = true
//                               
//                                Firebase_log("Click_Buy_Sub_In_Onb_Week")
//                                store.purchase(product: weekPro, onBuySuccess: { b in
//                                    if b {
//                                        DispatchQueue.main.async{
//                                            store.isPurchasing = false
//                                            Firebase_log("Buy_Sub_Success_In_Onb_Week")
//                                            showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
//                                            withAnimation{
//                                                navigateToHome.toggle()
//                                            }
//                                        }
//                                    }else{
//                                        DispatchQueue.main.async{
//                                           
//                                            store.isPurchasing = false
//                                        }
//                                    }
//                                    
//                                    
//                                }
//                                )
//                            }else{
//                                store.isPurchasing = false
//                                hideProgressSubView()
//                                showToastWithContent(image: "xmark", color: .red, mess: "Product is not ready!")
//                            }
//                        }
//                    }, label: {
//                        HStack{
//                            
//                            
//                            Text( "CONTINUE")
//                                .mfont(16, .bold)
//                                .foregroundColor(.black)
//                                .overlay(
//                                    ZStack{
//                                        if store.isPurchasing{
//                                            EZProgressView()
//                                        }
//                                    }.offset(x : -36)
//                                    , alignment: .leading
//                                )
//                            
//                        }
//                        .frame(maxWidth: .infinity)
//                        .frame(height : 56)
//                        .contentShape(Rectangle())
//                        .overlay(
//                            ZStack{
//                                ResizableLottieView(filename: "arrow")
//                                    .frame(width: 32, height: 32 )
//                                    .padding(.trailing , 24)
//                            }
//                            
//                            
//                            , alignment: .trailing
//                        )
//                    })
//                    .background(
//                        Capsule().fill(Color.main)
//                    )
//                    .padding(.horizontal, 24)
//                    .padding(.bottom, 76)
//                }
//                .ignoresSafeArea()
//                .overlay(
//                    ZStack{
//                        if page == 3 {
//                            HStack(spacing : 4){
//                                Button(action: {
//                                    if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
//                                        UIApplication.shared.open(url)
//                                    }
//                                }, label: {
//                                    Text("Privacy Policy").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
//                                })
//                                
//                                Text("|").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
//                                
//                                Button(action: {
//                                    Task{
//                                        let b = await store.restore()
//                                        if b {
//                                            store.fetchProducts()
//                                            showToastWithContent(image: "checkmark", color: .green, mess: "Restore Successful")
//                                        }else{
//                                            showToastWithContent(image: "xmark", color: .red, mess: "Cannot restore purchase")
//                                        }
//                                    }
//                                    
//                                }, label: {
//                                    Text("Restore").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
//                                })
//                                
//                                Text("|").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
//                                
//                                Button(action: {
//                                    if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
//                                        UIApplication.shared.open(url)
//                                    }
//                                }, label: {
//                                    Text("Term of use").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
//                                })
//                                
//                                
//                                
//                            }
//                        }
//                    }
//                    
//                    
//                    
//                    
//                    , alignment: .bottom
//                )
//                
//            }
//            
//            NavigationLink(destination:
//                            EztMainView()
//                .environmentObject(homeVM)
//                .environmentObject(store)
//                .environmentObject(interAd)
//                .environmentObject(rewardAd)
//                           , isActive: $navigateToHome, label: {
//                EmptyView()
//            })
//            
//        }
//        .overlay(
//            ZStack{
//                if store.isPurchasing {
//                    ProgressBuySubView()
//                }
//            }
//        )
//    }
//    
//    func getTextTitle(page : Int) -> String{
//        if page == 0 {
//            return "100000+"
//        }else if page == 1 {
//            return "Live Wallpapers"
//        }else if page == 2 {
//            return "Depth Effect"
//        }else if page == 3 {
//            return "Shuffle Packs"
//        }else{
//            return ""
//        }
//    }
//    
//    func getTextSubTitle(page : Int) -> String{
//        if page == 0 {
//            return "4K Wallpapers"
//        }else if page == 1 {
//            return "Vivid every detail"
//        }else if page == 2 {
//            return "Amazing 3D effects"
//        }else if page == 3 {
//            return "Automatically change exciting wallpapers"
//        }else{
//            return ""
//        }
//    }
//    
//    
//}
//
//
//struct ScreenOne : View{
//    @State var avPlayer : AVPlayer?
//    
//    var body: some View{
//        ZStack{
//            if  avPlayer != nil{
//                MyVideoPlayer(player: avPlayer!)
//            }
//        }
//        .onAppear(perform: {
//            avPlayer = AVPlayer(url:  Bundle.main.url(forResource: "video1", withExtension: "mp4")!)
//            avPlayer!.play()
//        })
//        .onDisappear(perform: {
//            if avPlayer != nil{
//                avPlayer!.pause()
//            }
//            avPlayer = nil
//        })
//        
//        
//    }
//}
//
//
//struct ScreenSecond : View{
//    @State var avPlayer : AVPlayer?
//    
//    var body: some View{
//        ZStack{
//            if  avPlayer != nil{
//                MyVideoPlayer(player: avPlayer!)
//            }
//        }
//        .onAppear(perform: {
//            avPlayer = AVPlayer(url:  Bundle.main.url(forResource: "live", withExtension: "mp4")!)
//            avPlayer!.play()
//        })
//        .onDisappear(perform: {
//            if avPlayer != nil{
//                avPlayer!.pause()
//            }
//            avPlayer = nil
//        })
//        
//        
//    }
//}
//
//struct ScreenThird : View{
//    @State var avPlayer : AVPlayer?
//    
//    var body: some View{
//        ZStack{
//            if  avPlayer != nil{
//                MyVideoPlayer(player: avPlayer!)
//            }
//        }
//        .onAppear(perform: {
//            avPlayer = AVPlayer(url:  Bundle.main.url(forResource: "depth_effect", withExtension: "mp4")!)
//            avPlayer!.play()
//        })
//        .onDisappear(perform: {
//            if avPlayer != nil{
//                avPlayer!.pause()
//            }
//            avPlayer = nil
//        })
//        
//        
//    }
//}
//
//struct ScreenFour : View{
//    @State var avPlayer : AVPlayer?
//    
//    var body: some View{
//        ZStack{
//            if  avPlayer != nil{
//                MyVideoPlayer(player: avPlayer!)
//            }
//        }
//        .onAppear(perform: {
//            avPlayer = AVPlayer(url:  Bundle.main.url(forResource: "shuffle_packs", withExtension: "mp4")!)
//            avPlayer!.play()
//        })
//        .onDisappear(perform: {
//            if avPlayer != nil{
//                avPlayer!.pause()
//            }
//            avPlayer = nil
//        })
//        
//        
//    }
//}
//
//struct ScreenFive : View{
//    @State var avPlayer : AVPlayer?
//    var body: some View{
//        ZStack{
//            if  avPlayer != nil{
//                MyVideoPlayer(player: avPlayer!)
//            }
//            
//            
//        }
//        .onAppear(perform: {
//            UserDefaults.standard.set(true, forKey: "not_first_time_enter_app")
//            
//            avPlayer = AVPlayer(url:  Bundle.main.url(forResource: "video4", withExtension: "mp4")!)
//            avPlayer!.play()
//        })
//        .onDisappear(perform: {
//            if avPlayer != nil{
//                avPlayer!.pause()
//            }
//            avPlayer = nil
//        })
//        
//        
//    }
//}
//
