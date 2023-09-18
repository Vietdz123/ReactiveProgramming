//
//  PrepapeView.swift
//  WallpaperIOS
//
//  Created by Mac on 17/05/2023.
//

import SwiftUI
import StoreKit

class MainViewModel : ObservableObject {
    
    @Published var adStatus : AdStatus = .loading
    
    @Published var currentTab : NewTab = .HOME
    @Published var navigateToSubView = false
    @Published var showMenu : Bool = false
    @Published var showWatchRVDialog : Bool = false
    @Published var showBottomTab : Bool = true
    @Published var showDialogGetCoin2 : Bool = false
    
    @Published var todayGetGift : Bool = false
    @Published var randomPos : Int = 0
    @Published var expandGift : Bool = false
    
    @Published var translate : Bool = false
    @Published var scale : Bool = false
    
    @Published var autoShowGift : Bool = false
    
    
    @Published var showSubView : Bool = false
    
    @Published var allowShowSubView : Bool = true
    
    let subType : Int
    
    init(){
        let subTypeSave =  UserDefaults.standard.integer(forKey: "sub_type")
        self.subType = subTypeSave
        
        if subTypeSave == 0 {
            if Bool.random() {
                UserDefaults.standard.set(1, forKey: "sub_type")
            }else{
                UserDefaults.standard.set(2, forKey: "sub_type")
            }
        }else if subTypeSave == 1 {
            if Bool.random() {
                UserDefaults.standard.set(0, forKey: "sub_type")
            }else{
                UserDefaults.standard.set(2, forKey: "sub_type")
            }
        }else if subTypeSave == 2{
            if Bool.random() {
                UserDefaults.standard.set(0, forKey: "sub_type")
            }else{
                UserDefaults.standard.set(1, forKey: "sub_type")
            }
        }
        
        
        randomPos = Int.random(in: 0...14)
        checkToDayGetGift()
        checkAutoShowGiftToday()
        
      
        
    }
    
    
    
    func checkToDayGetGift()  {
        let currentDate = Date().toString(format: "dd/MM/yyyy")
        let date_get_gift = UserDefaults.standard.string(forKey: "date_get_gift") ?? ""
        
        if currentDate == date_get_gift {
            todayGetGift = true
        }else{
            todayGetGift = false
        }
        
    }
    
    func checkAutoShowGiftToday(){
        let currentDate = Date().toString(format: "dd/MM/yyyy")
        let date_autoshowgift = UserDefaults.standard.string(forKey: "date_auto_show_gift") ?? ""
        if date_autoshowgift != currentDate {
            UserDefaults.standard.set(currentDate, forKey: "date_auto_show_gift")
            autoShowGift = true
        }
    }
    
}

struct MainView: View {
    
    let fromDefault : Bool
    
    @Namespace var anim
    
    @AppStorage("current_coin", store: .standard) var currentCoin : Int = 0
    @StateObject var mainViewModel : MainViewModel = .init()
    
   
    
    
    @StateObject var dailyGiftViewModel : DailyGiftViewModel = .init()
    
    @StateObject var shuffleVM : ShufflePackViewModel = .init()
    @StateObject var dynamicVM : DynamicIslandViewModel = .init()
    @StateObject var depthEffectVM : DepthEffectViewModel = .init()
    
    @StateObject var categoryViewModel : CategoryViewModel = .init()
    @StateObject var liveViewModel : LiveWallpaperViewModel = .init()
    
    
 
    
    @StateObject var exclusiveViewModel : ExclusiveViewModel = .init()
    
    @StateObject var favViewModel : FavoriteViewModel = .init()
  
    @EnvironmentObject var viewModel : HomeViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination:
                            SubcriptionVIew()
                .environmentObject(store)
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                           , isActive: $mainViewModel.navigateToSubView, label: {
                EmptyView()
            })
            
            TabView(selection: $mainViewModel.currentTab ){
                HomeView()
                    .environmentObject(viewModel)
                    .environmentObject(rewardAd)
                    .environmentObject(store)
                    .environmentObject(interAd)
                    .environmentObject(favViewModel)
                    .environmentObject(categoryViewModel)
                    .tag(NewTab.HOME)
                
                SpecialView()
                    .environmentObject(shuffleVM)
                    .environmentObject(depthEffectVM)
                    .environmentObject(dynamicVM)
                    .environmentObject(store)
                    .environmentObject(interAd)
                    .environmentObject(favViewModel)
                    .tag(NewTab.SPECIAL)
                
                CategoryView()
                    .environmentObject(categoryViewModel)
                    .environmentObject(liveViewModel)
                    .environmentObject(rewardAd)
                    .environmentObject(store)
                    .environmentObject(favViewModel)
                    .tag(NewTab.EXPLORE)
                
                LiveWallpaperView()
                    .environmentObject(liveViewModel)
                    .environmentObject(store)
                    .environmentObject(interAd)
                    .environmentObject(favViewModel)
                    .tag(NewTab.VIDEO)
                
                
                
                ExclusiveView()
                    .environmentObject(exclusiveViewModel)
                    .environmentObject(rewardAd)
                    .environmentObject(store)
                    .environmentObject(favViewModel)
                    .tag(NewTab.AI_ART)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.top)
            .onChange(of: mainViewModel.currentTab, perform: { _ in
                if !mainViewModel.showBottomTab {
                    mainViewModel.showBottomTab = true
                }
            })
            
            VStack(spacing : 0){
                TopBar()
                Spacer()
                if mainViewModel.showBottomTab{
                    BottomBar()
                }
                
            }.ignoresSafeArea(.all, edges: .bottom)
            
            ZStack(alignment: .bottomTrailing){
                if !store.isPro() && !mainViewModel.todayGetGift && mainViewModel.currentTab  == .HOME {
                    if mainViewModel.expandGift {
                        if !dailyGiftViewModel.wallpapers.isEmpty{
                            if let wallpaper = dailyGiftViewModel.wallpapers.first {
                                DailyGiftDialog(wallpaper: wallpaper, show: $mainViewModel.expandGift, getGift: $mainViewModel.todayGetGift)
                                    .matchedGeometryEffect(id: "GIFT", in: anim)
                                    .onDisappear(perform: {
                                        if UserDefaults.standard.bool(forKey: "firsttime_request_noti") == false {
                                            UserDefaults.standard.set(true, forKey: "firsttime_request_noti")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                                UNUserNotificationCenter.current().requestAuthorization(options:  [.alert, .badge, .sound] ,completionHandler: {
                                                    _, _ in
                                                })
                                            })
                                            
                                        }else{
                                            showRateView()
                                        }
                                        
                                    })
                            }
                        }
                        
                    }else{
                        ResizableLottieView(filename: "giftbox")
                            .frame(width: 80, height: 80)
                            .scaleEffect(mainViewModel.scale ? 3 : 1, anchor: .center)
                            .offset(x : mainViewModel.translate ?  -getRect().width / 2 + 64  : 0, y : mainViewModel.translate ? ( -getRect().height / 2 + 64 ) : 0 )
                            .padding(.trailing, 16)
                            .padding(.bottom, ( store.allowShowBanner() ? 24 : 0 ) + 128 - getSafeArea().bottom)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .matchedGeometryEffect(id: "GIFT", in: anim)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.4)){
                                    mainViewModel.expandGift = true
                                }
                                
                                
                            }
                    }
                }
            }
            
            if  mainViewModel.showWatchRVDialog{
                WatchRVtoGetCoinDialog( show:  $mainViewModel.showWatchRVDialog, showDialog2: $mainViewModel.showDialogGetCoin2)
                    .environmentObject(store)
                    .environmentObject(rewardAd)
            }
            
            if mainViewModel.showDialogGetCoin2{
                WatchRVGetCoindAndBuySubDialog(reward: rewardAd, show: $mainViewModel.showDialogGetCoin2, clickBuyPro: {
                    mainViewModel.navigateToSubView = true
                })
            }
            
            if  mainViewModel.showMenu{
                SlideMenuView(
                    showMenu:  $mainViewModel.showMenu
                )
                .environmentObject(store)
                .environmentObject(favViewModel)
                .environmentObject(rewardAd)
                .environmentObject(interAd)
                
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .addBackground()
        .onAppear(perform: {
            if  mainViewModel.showMenu{
                mainViewModel.showMenu = false
            }
            
            if fromDefault {
                if mainViewModel.allowShowSubView && !store.isPro() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        mainViewModel.allowShowSubView = false
                        mainViewModel.showSubView = true
                    })
                }
            }
            
           
        })
        .onChange(of: mainViewModel.showMenu, perform: {
            newValue in
            if newValue {
                store.showBanner = false
            }else{
                store.showBanner = true
            }
        })
        .fullScreenCover(isPresented: $mainViewModel.showSubView, content: {
           SubViewRandom()
                .environmentObject(store)
        })

    }
    
    @ViewBuilder
    func SubViewRandom() -> some View {
        if mainViewModel.subType == 0 {
            Sub_1_View()
        }else if mainViewModel.subType == 1 {
            Sub_2_View()
        }else{
            Sub_3_View()
        }
    }
    
    
    @ViewBuilder
    func TopBar() -> some View{
        ZStack{
            HStack(spacing : 0){
                Image("menu")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)){
                            mainViewModel.showMenu.toggle()
                        }
                    }
                Spacer()
                NavigationLink(destination: {
                    SearchView()
                        .environmentObject(rewardAd)
                        .environmentObject(store)
                        .environmentObject(favViewModel)
                        .environmentObject(interAd)
                }, label: {
                    Image("search")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        
                })
                
                
                if !store.isPro(){
                    HStack(spacing : 6){
                        Image("coin")
                            .resizable()
                            .frame(width: 13.33, height: 13.33)
                        Text("\(currentCoin)")
                            .mfont(13, .bold)
                            .foregroundColor(.white)
                        
                        
                    }.frame(width: 42, height: 20)
                        .background(
                            Capsule().fill(Color.white.opacity(0.3))
                        )
                        .overlay(
                            Circle()
                                .fill(Color.main)
                                .frame(width: 4, height: 4), alignment: .topTrailing
                        )
                        .onTapGesture {
                            withAnimation{
                                mainViewModel.showWatchRVDialog.toggle()
                            }
                        }
                        .padding(.leading, 16)
                }
                
             
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .frame(maxWidth: .infinity)
            .frame(height: 44 )
            .background(
                Color.black.ignoresSafeArea()
            ).overlay(
                Text(mainViewModel.currentTab.rawValue.uppercased())
                    .mfont(20, .bold)
                    .foregroundColor(Color.main)
                
            )
        }
    }
    
    @ViewBuilder
    func BottomBar() -> some View{
        VStack(spacing : 0){
            if !store.isPro(){
                Button(action: {
                    Flurry_log("Sub_click_in_home")
                    mainViewModel.navigateToSubView = true
                }, label: {
                    HStack(spacing : 0){
                        ResizableLottieView(filename: "star")
                            .frame(width: 32, height: 32, alignment: .center)
                        
                        Text("Unlock All Features")
                            .mfont(16, .bold)
                            .foregroundColor(Color.main)
                            .padding(.leading, 16)
                        Spacer()
                        Image("off")
                            .resizable()
                            .frame(width: 44, height: 24)
                        
                        
                    }.frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                })
            }
            
            HStack(spacing : 0){
                ForEach(NewTab.allCases, id: \.rawValue){
                    tab in
                    Text(tab.rawValue).foregroundColor( mainViewModel.currentTab == tab ? .white : .white.opacity(0.7))
                        .mfont(13,  mainViewModel.currentTab == tab ? .bold : .regular)
                        .frame(maxHeight : .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation{
                                mainViewModel.currentTab = tab
                            }
                        }
                        .background{
                            ZStack{
                                if  mainViewModel.currentTab == tab {
                                    Capsule()
                                        .fill(Color.main)
                                        .frame(width: 36, height: 2)
                                        .offset(y : 12)
                                        .matchedGeometryEffect(id: "NEWTAB", in: anim)
                                }
                            }
                        }
                    if tab != NewTab.AI_ART {
                        Spacer()
                    }
                    
                }
            }.frame(maxWidth: .infinity)
                .frame(height: 56)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: store.allowShowBanner() ? 0 : 14 , trailing: 20))
            
            if store.allowShowBanner(){
                BannerAdView(adFormat: .adaptiveBanner, adStatus: $mainViewModel.adStatus)
            }
            
        }
        .ignoresSafeArea()
        .background(
            VisualEffectView(effect: UIBlurEffect(style: .dark))
            
        )
        
        
    }
    
    func newDateStartAnimation(){
        withAnimation{
            mainViewModel.translate = true
            mainViewModel.scale = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            withAnimation(.easeOut(duration: 0.6)){
                mainViewModel.expandGift = true
            }
            mainViewModel.translate = false
            mainViewModel.scale = false
        })
    }
    
}





