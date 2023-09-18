//
//  ContentView.swift
//  WallpaperIOS
//
//  Created by Mac on 25/04/2023.
//

import SwiftUI
import CoreData
import NavigationTransitions
import FirebaseRemoteConfig





//struct ContentView: View {
//
//    @StateObject var appVM : AppViewModel = .init()
//    @StateObject var myStore : MyStore = .init()
//    let openAd : OpenAd = OpenAd()
//    let interAd : InterstitialAdLoader = .init()
//    let reward : RewardAd = .init()
//    @Environment(\.scenePhase)  var scenePhase
//
//    init() {
//        UIRefreshControl.appearance().tintColor = .yellow
//        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
//        UIRefreshControl.appearance().attributedTitle = NSAttributedString(string: "Refreshing Data", attributes: attributes)
//        UITabBar.appearance().isHidden  = true
//    }
//
//    var body: some View {
//        ZStack{
//            VStack(spacing : 0){
//                NavigationView {
//                    PrepapeView(viewAppear: $appVM.hasLoadOpenAds)
//                        .environmentObject(myStore)
//                        .environmentObject(reward)
//                        .environmentObject(interAd)
//                }.navigationViewStyle(.stack)
//                    .navigationTransition(.fade(.out))
//                if myStore.allowShowBanner() {
//                    BannerAdView(adFormat: .adaptiveBanner, adStatus: $appVM.adStatus)
//                        .animation(.linear, value: myStore.allowShowBanner())
//                }
//
//            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//                .edgesIgnoringSafeArea(.bottom)
//
//
//
//            if appVM.notFirstTime {
//                if !appVM.hasLoadOpenAds {
//                    SplashScreenView()
//                }
//            }else{
//                OnboardingSubView(show: $appVM.notFirstTime, hasLoadAds: $appVM.hasLoadOpenAds)
//                    .environmentObject(myStore)
//            }
//
//
//
//        }.onChange(of: scenePhase, perform: {
//            newPhase in
//            if newPhase == .active {
//                if appVM.openApp {
//                    openAd.requestAppOpenAd()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//                        appVM.openApp = false
//                        if myStore.isPro(){
//                            withAnimation(.easeInOut(duration: 1.0)) {
//                                appVM.hasLoadOpenAds = true
//                            }
//                        }else{
//
//                            if appVM.notFirstTime == false{
//                                return
//                            }
//
//                            if openAd.appOpenAd != nil {
//                                openAd.tryToPresentAd(onCommit: { _ in
//                                    appVM.showOpenAds = false
//                                    withAnimation(.easeInOut(duration: 1.0)) {
//                                        appVM.hasLoadOpenAds = true
//                                    }
//                                })
//                            }else{
//                                withAnimation(.easeInOut(duration: 1.0)) {
//                                    appVM.hasLoadOpenAds = true
//                                }
//                            }
//                        }
//                    })
//
//                }else{
//                    if !myStore.isPro(){
//
//                        if !appVM.showOpenAds {
//                            return
//                        }
//                        if openAd.appOpenAd != nil {
//                            openAd.tryToPresentAd(onCommit: { _ in
//                                appVM.showOpenAds = false
//                                withAnimation(.easeInOut(duration: 1.0)) {
//                                    appVM.hasLoadOpenAds = true
//                                }
//                            })
//                        }else{
//                            withAnimation(.easeInOut(duration: 1.0)) {
//                                appVM.hasLoadOpenAds = true
//                            }
//                        }
//                    }
//                }
//
//
//
//            }else if newPhase == .inactive{
//
//            }else {
//                UserDefaults.standard.set(true, forKey: "user_exit_app")
//                if !myStore.isPro(){
//                    appVM.showOpenAds = true
//                }
//
//
//            }
//        })
//
//
//        
//
//    }
//
//}
//
//
