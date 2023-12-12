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
    
    
    @Published var showMenu : Bool = false
    @Published var currentTab : EztTab = .HOME
    //@Published var showGift : Bool = false
    
  
    
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
    
//    func changeSubType() {
//
//        
//        let subTypeSave =  UserDefaults.standard.integer(forKey: "gift_sub_type")
//      
//        
//        if subTypeSave == 0 {
//                UserDefaults.standard.set(1, forKey: "gift_sub_type")
//        }else if subTypeSave == 1 {
//                UserDefaults.standard.set(2, forKey: "gift_sub_type")
//        }else if subTypeSave == 2{
//                UserDefaults.standard.set(0, forKey: "gift_sub_type")
//        }
//        
//       
//    }
    
}

struct EztMainView : View {
    
    @StateObject var mainViewModel : EztMainViewModel = .init()
    @StateObject var exlusiveVM : ExclusiveViewModel = .init()
    
    @StateObject var shuffleVM : ShufflePackViewModel = .init(sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var depthVM : DepthEffectViewModel = .init(sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var dynamicVM : DynamicIslandViewModel = .init(sort : .POPULAR, sortByTop: .TOP_WEEK)
    
    @StateObject var liveVM : LiveWallpaperViewModel = .init()
   
    
    @StateObject var foryouVM : HomeViewModel = .init()
    @StateObject var tagViewModel : TagViewModel = .init()
    

    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    
    
    @Namespace var anim
    var body: some View {
        ZStack{
            VStack(spacing : 0){
                TopBar()
                TabView(selection: $mainViewModel.currentTab,
                        content:  {
                    EztHomeView(currentTab: $mainViewModel.currentTab)
                        .environmentObject(exlusiveVM)
                        .environmentObject(shuffleVM)
                        .environmentObject(depthVM)
                        .environmentObject(dynamicVM)
                        .environmentObject(liveVM)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                        .gesture(DragGesture())
                        .tag(EztTab.HOME)
                    EztWallpaperView()
                        .environmentObject(foryouVM)
                        .environmentObject(tagViewModel)
                        .environmentObject(liveVM)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                        .gesture(DragGesture())
                        .tag(EztTab.WALLPAPER)
                    EztWidgetView()
                             .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                
                        .gesture(DragGesture())
                        .tag(EztTab.WIDGET)
                    
                    EztWatchFaceView()
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                        .tag(EztTab.WATCHFACE)
                })
        
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .overlay(
                    BottomBar(), alignment: .bottom
                )
                .edgesIgnoringSafeArea(.bottom)
            
            if  mainViewModel.showMenu{
                SlideMenuView(
                    showMenu:  $mainViewModel.showMenu
                )
                .environmentObject(store)
            
                .environmentObject(rewardAd)
                .environmentObject(interAd)
                
            }
            
            
        }//.addBackground()
        .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .onAppear(perform: {
                if  mainViewModel.showMenu{
                    mainViewModel.showMenu = false
                }

                    if mainViewModel.allowShowSubView && !store.isPro() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            mainViewModel.allowShowSubView = false
                            mainViewModel.showSubView = true
                        })
                    }
                
            
                
                let getPermissionNotification = UserDefaults.standard.bool(forKey: "getPermissionNotification")
                if !getPermissionNotification {
                    UserDefaults.standard.setValue(true, forKey: "getPermissionNotification")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 15.0, execute: {
                        NotificationHelper.share.requestNotificationPermission(onComplete: {
                            b in
                            if b {
                                DispatchQueue.main.async {
                                    showToastWithContent(image: "checkmark", color: .green, mess: "Thanks for permisson!")
                                }
                            }
                        })
                        
                    })
                }
               
                
                
            })
//            .overlay{
//                if mainViewModel.showGift{
//                    GiftView()
//                }
//            }
            .fullScreenCover(isPresented: $mainViewModel.showSubView, onDismiss: {
               
            }, content: {
                SubViewRandom()
                    .environmentObject(store)
            })
        
    }
    
//    @ViewBuilder
//    func GiftView(giftSubType : Int = UserDefaults.standard.integer(forKey: "gift_sub_type")  ) -> some View{
//        if giftSubType == 0 {
//           GiftSub_1_View(show: $mainViewModel.showGift)
//        }else if giftSubType == 1{
//            GiftSub_2_View(show: $mainViewModel.showGift)
//        }else{
//            GifSub_3_View(show: $mainViewModel.showGift)
//        }
//    }
    
    
    @ViewBuilder
    func SubViewRandom() -> some View {
        if mainViewModel.subType == 0 {
            if store.isHasEvent(){
                Sub_Event()
            }else{
                Sub_1_View()
            }
            
        }else if mainViewModel.subType == 1 {
            Sub_2_View()
        }else{
            Sub_3_View()
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
                                    .environmentObject(rewardAd)
                                    .environmentObject(store)
                                   
                                    .environmentObject(interAd)
            }, label: {
                Image("search")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
                    .frame(width: 48, height: 48, alignment: .center)
                
            })
            
        }.frame(maxWidth: .infinity)
            .frame(height: 48)
        
    }
    
    @ViewBuilder
    func BottomBar() -> some View{
        VStack(spacing : 12){
//            if !store.isPro(){
//                Button(action: {
//                    mainViewModel.showGift.toggle()
//                    mainViewModel.changeSubType()
//                }, label: {
//                    
//                
//                
//                HStack(spacing : 0){
//                    HStack(spacing : 0){
//                        ResizableLottieView(filename: "giftbox")
//                            .frame(width: 86, height: 86)
//                            .offset(y : 4)
//                        // .padding(.leading, 12)
//                        //  .padding(.trailing, 12)
//                        
//                        Text("Last chance for your gift...".toLocalize())
//                            .mfont(15, .bold, line: 1)
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.leading)
//                            
//                            
//                        Spacer()
//                      
//                         
//                   
//                            Text("Open".toLocalize())
//                                .mfont(13, .bold)
//                                .multilineTextAlignment(.center)
//                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
//                                .frame(width: 64, height: 28)
//                                .background(
//                                    Capsule()
//                                        .fill(.white)
//                                    
//                                )
//                                .padding(.trailing, 12)
//                      
//                        
//                        
//                        
//                    }.frame(maxWidth: .infinity)
//                        .frame(height: 48)
//                        .background(
//                            Capsule()
//                                .fill(
//                                    LinearGradient(
//                                        stops: [
//                                            Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
//                                            Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
//                                            Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
//                                        ],
//                                        startPoint: UnitPoint(x: 0, y: 1.38),
//                                        endPoint: UnitPoint(x: 1, y: -0.22)
//                                    )
//                                )
//                                .frame(height: 48)
//                            
//                        )
//                        .padding(.horizontal, 12)
//                }
//                .frame(height: 68, alignment: .bottom)
//                .clipped()
//               
//                
//                })
//                
//            }
            
           
           
               
                
            
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
                               // .padding(EdgeInsets(top: 0, leading: 8, bottom: 12, trailing: 8))
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
               
        }
        .frame(maxWidth: .infinity)
    //    .background(.white.opacity(0.001))
       // .frame(height: store.isPro() ? 72 : 152, alignment : .bottom)
        .frame(height: 72 , alignment : .bottom)
        
    }
    
    
}




