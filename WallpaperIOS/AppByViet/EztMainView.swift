//
//  EztMainView.swift
//  WallpaperIOS
//
//  Created by Duc on 16/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

#Preview {
    EztMainView()
}

class EztMainViewModel : ObservableObject{
    
    static let shared = EztMainViewModel()
    @Published var paths: NavigationPath = NavigationPath()
    @Published var showMenu : Bool = false
    @Published var currentTab : EztTab = .HOME
    @Published var currentWallpaperTab : WallpaperTab = .ForYou
    @Published var showGift : Bool = false
    
    @Published var adStatus : AdStatus = .loading
    @Published var firstAppear : Bool = true
    
    @Published var showSubView : Bool = false
    @Published var allowShowSubView : Bool = true
    
    let subType : Int
    
    init() {
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
        
    }
    
    
    
    
    
    
}

struct EztMainView : View {
    
    @StateObject var mainViewModel : EztMainViewModel = .shared
    @StateObject var exlusiveVM : ExclusiveViewModel = .init()
    @StateObject var shuffleVM : ShufflePackViewModel = .init(sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var depthVM : DepthEffectViewModel = .init(sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var dynamicVM : DynamicIslandViewModel = .init(sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var liveVM : LiveWallpaperViewModel = .init()
    @StateObject var foryouVM : HomeViewModel = .init()
    @StateObject var tagViewModel : TagViewModel = .init()
    @StateObject var catalogVM : WallpaperCatalogViewModel = .init()
    @StateObject var store : MyStore = .shared
    
    
    @Namespace var anim
    var body: some View {
        NavigationStack(path: $mainViewModel.paths) {
            ZStack(alignment: .top) {
                Image("BGIMG")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TopBar()
                        .padding(.top, topSafeArea)
                    
                    TabView(selection: $mainViewModel.currentTab,
                            content:  {
                        EztHomeView(currentTab: $mainViewModel.currentTab, wallpaperTab: $mainViewModel.currentWallpaperTab)
                            .gesture(DragGesture())
                            .tag(EztTab.HOME)
                        
                        EztWallpaperView(currentTab: $mainViewModel.currentWallpaperTab,
                                         showGift : $mainViewModel.showGift)
                        .gesture(DragGesture())
                        .tag(EztTab.WALLPAPER)
                        
                        EztWidgetView()
                            .gesture(DragGesture())
                            .tag(EztTab.WIDGET)
                        
                        GenArtMainView()
                            .tag(EztTab.GENERATION)
                    })
                }
                .overlay(alignment: .bottom, content: {
                    BottomBar()
                })
              
                
                if mainViewModel.showMenu {
                    SlideMenuView(showMenu: $mainViewModel.showMenu)
                }
            }
            .frame(width: widthDevice, height: heightDevice)
            .ignoresSafeArea()
            .navigationDestination(for: Router.self) { value in
                switch value {
                    
                case .gotoEztPosterContactView:
                    EztPosterContactView()
                    
                case .gotoEztLiveWallpaperView:
                    EztLiveWallpaperView()
                    
                case .gotoDynamicIslandView:
                    EztDynamicIsland()
                    
                case .gotoShufflePackView:
                    EztShufflePackView()
                    
                case .gotoLightingEffectView:
                    EztLightingEffectView()
                    
                case .gotoNewestLightingEffect:
                    NewestLightingEffectView()
                    
                case .gotoNewestAnSpecialWatchFaceView:
                    EztWatchFaceView()
                    
                case .gotoDepthEffectView:
                    EztDepthEffectView()
                    
                case let .gotoLiveWallpaperDetail(currentOffset, wallpapers):
                    LiveWLView(viewModel: .init(wallpapers: wallpapers), currentIndex: currentOffset)
                    
                case .gotoNewestWatchFaceView:
                    NewestWatchFaceView(viewModel: .init())
                    
                case .gotoShufflePackeList:
                    EztShufflePackListCateView()
                    
                case let .gotoSpecialWalliveDetailView(currentIndex, wallpapers):
                    SpWLDetailView(index: currentIndex, viewModel: .init(wallpapers: wallpapers))
                    
                case let .gotoSpeicalPageView(title: title, type: type, tadId: tagID):
                    EztSpecialPageView(currentTag: title, type: type, tagID: tagID)
                    
                case .gotoShuffleDetailView(let wallpaper):
                    ShuffleDetailView(wallpaper: wallpaper)
                    
                case let .gotoSpecialOnePageDetailView(wallpapers: wallpapers, index: index):
                    SPWLOnePageDetailView(wallpapers: wallpapers, index: index)
                    
                case .gotoNewestAndPopularDynamic:
                    EztDynamicIslslandCateView()
                    
                case .gotoNewestDynamicView(let wallpapers):
                    NewestDynamicView(viewModel: .init(wallpapers: wallpapers))
                    
                case .gotoListDepthEffectView(let wallpapers):
                    DepthEffectListView(viewModel: .init(wallpapers: wallpapers))
                    
                case let .gotoLockThemeListView(wallpapers: wallpapers):
                    LockThemeListView(viewModel: .init(wallpapers: wallpapers))
                    
                case let .gotoLockThemeDetailView(wallpapers: wallpapers, currentIndex: currentIndex):
                    LockThemeDetailView(index: currentIndex, viewModel: .init(wallpapers: wallpapers))
                }
            }
            .onAppear(perform: {
                UserDefaults.standard.setValue(true, forKey: "user_go_main")
                
                if mainViewModel.firstAppear {
                    mainViewModel.firstAppear = false
                    let notFirstTimeInMain = UserDefaults.standard.bool(forKey: "not_1st_time_in_main")
                    if !notFirstTimeInMain {
                        UserDefaults.standard.set(true, forKey: "not_1st_time_in_main")
                        
                    } else {
                        mainViewModel.currentTab = .WALLPAPER
                        var timeCountEnterApp : Int = UserDefaults.standard.integer(forKey: "timecount_enter_app")
                        
                        if !UserDefaults.standard.bool(forKey: "lan_hai_vao_app"){
                            UserDefaults.standard.set(true, forKey: "lan_hai_vao_app")
                            timeCountEnterApp = timeCountEnterApp + Int.random(in: 0...1)
                        }
                        
                        if timeCountEnterApp % 3 == 0 {
                            mainViewModel.currentWallpaperTab = .Category
                            
                        } else if timeCountEnterApp % 3 == 1 {
                            mainViewModel.currentWallpaperTab = .Special
                            
                        } else{
                            mainViewModel.currentWallpaperTab = .LockScreenTheme
                        }
                        
                        UserDefaults.standard.set(timeCountEnterApp + 1, forKey: "timecount_enter_app")
                        
                        if mainViewModel.allowShowSubView && !store.isPro() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                mainViewModel.allowShowSubView = false
                                mainViewModel.showSubView = true
                            })
                        }
                        
                    }
                }
                
                if  mainViewModel.showMenu{
                    mainViewModel.showMenu = false
                }
                
                let getPermissionNotification = UserDefaults.standard.bool(forKey: "getPermissionNotification")
                if !getPermissionNotification {
                    UserDefaults.standard.setValue(true, forKey: "getPermissionNotification")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15.0, execute: {
                        NotificationHelper.share.requestNotificationPermission(onComplete: {
                            _ in
                            
                        })
                        
                    })
                }
            })
//            .navigationTransition(.fade(.out))
        }
    }
     
       
    

    
}

extension EztMainView{
    func TopBar() -> some View{
        HStack(spacing : 0){
            Image("menu")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24, alignment: .center)
                .frame(width: 48, height: 48, alignment: .center)
                .containerShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)){
                        mainViewModel.showMenu.toggle()
                    }
                }
            
            Spacer()
            
            Text(mainViewModel.currentTab == .HOME ? "Wallive" : mainViewModel.currentTab.rawValue.toLocalize())
                .mfont(20, .bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.main)
            
            Spacer()
            
            NavigationLink(destination: {
                SearchView()

            }, label: {
                Image("search")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
                    .frame(width: 48, height: 48, alignment: .center)
                
            })
            
        }
        .frame(width: widthDevice, height: 48)
        
    }
    
    @ViewBuilder
    func BottomBar() -> some View{
        VStack(spacing : 0){

            HStack(spacing : 0 ){
                ForEach(EztTab.allCases, id : \.rawValue){
                    tab in
                    VStack(spacing : 0){
                        ZStack{
                            if mainViewModel.currentTab == tab{
                                
                                
                                VStack(spacing : 4){
                                    Image("\(tab.rawValue)111")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20, alignment: .center)
                                    
                                    Text(tab.rawValue.uppercased().toLocalize())
                                        .mfont(11,  .bold)
                                        .foregroundColor(.white)
                                    
                                }
                                .frame(maxHeight: .infinity)
                                .background(
                                    TrapezoidShape()
                                        .fill(
                                            LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.18, green: 0.66, blue: 1).opacity(0.9), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 0.87, green: 0.22, blue: 0.88).opacity(0.36), location: 1.00),
                                                ],
                                                startPoint: UnitPoint(x: 0.5, y: 0),
                                                endPoint: UnitPoint(x: 0.5, y: 1)
                                            )
                                        )
                                        .blur(radius: 15)
                                        .opacity(0.7)
                                        .matchedGeometryEffect(id: "MAIN_TABB", in: anim)
                                )
                                .overlay(
                                    ZStack{
                                        if mainViewModel.currentTab == tab{
                                            Capsule()
                                                .fill(Color.main)
                                                .frame(width: 16, height: 2)
                                                .matchedGeometryEffect(id: "MAIN_TAB", in: anim)
                                                .padding(.bottom, 8)
                                            //.offset(y : 0)
                                            
                                        }
                                    }, alignment : .bottom
                                )
                            }else{
                                
                                
                                VStack(spacing : 4){
                                    Image("\(tab.rawValue)111")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white.opacity(0.7))
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20, alignment: .center)
                                    
                                    Text(tab.rawValue.uppercased().toLocalize())
                                        .mfont(11,  .regular)
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    
                                }
                                
                            }
                        }.padding(.horizontal, 8)
                            .padding(.bottom, 8)
                        
                        
                    }.frame(maxWidth: .infinity, maxHeight : .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation{
                                mainViewModel.currentTab = tab
                            }
                        }
                    
                }
            }.frame(maxWidth: .infinity)
                .frame(height: 72)
                .background(
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                    // Color.red
                )
                .background(Color(red: 0.08, green: 0.1, blue: 0.09).opacity(0.7))
            
            
            if store.allowShowBanner(){
                BannerAdHomeView()
                
                
            }
            
            
        }
        .frame(maxWidth: .infinity)
        
        
    }
    
    
}

