//
//  EztWallpaperView.swift
//  WallpaperIOS
//
//  Created by Duc on 16/10/2023.
//

import SwiftUI

#Preview {
    EztMainView()
}

enum WallpaperTab : String, CaseIterable{
    case ForYou = "For You"
    case Category = "Category"
    case ShufflePack = "Shuffle Pack"
    case DepthEffect = "Depth Effect"
    case WatchFace = "Watch Face"
    case PosterContact = "Post Contact"
    case DynamicIsland = "Dynamic Island"
    case Live = "Live Wallpapers"
}


struct EztWallpaperView: View {
    
    //@StateObject var ctrlVM : EztWallpaperViewModel = .init()
    
    @EnvironmentObject var tagViewModel : TagViewModel 
    @EnvironmentObject var foryouVM : HomeViewModel 
    @StateObject var catalogVM : WallpaperCatalogViewModel = .init()
   
    
   
    @EnvironmentObject var liveVM : LiveWallpaperViewModel
    
    
    
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    
    @Binding var currentTab : WallpaperTab
    
    
    @Namespace var anim
    var body: some View {
        VStack(spacing : 0){
            TabControllView()
                .padding(.top, 16)
                .padding(.bottom, 16)
            
            TabView(selection: $currentTab,
                    content:  {
                EztForYouView()
                    .environmentObject(foryouVM)
                    .environmentObject(tagViewModel)
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                    .environmentObject(store)
                    .tag(WallpaperTab.ForYou)
                
                EztCategoryView()
                   
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                    .environmentObject(store)
                    .tag(WallpaperTab.Category)
                EztShufflePackView()
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                    .environmentObject(store)
                    .environmentObject(catalogVM)
                    
                    .tag(WallpaperTab.ShufflePack)
                EztDepthEffectView()
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                    .environmentObject(store)
                    .environmentObject(catalogVM)
                    .tag(WallpaperTab.DepthEffect)
                
                
                EztWatchFaceView()
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                    .environmentObject(store)
                    .environmentObject(catalogVM)
                    .tag(WallpaperTab.WatchFace)
                
                EztPosterContactView()
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                    .environmentObject(store)
                    .environmentObject(catalogVM)
                    .tag(WallpaperTab.PosterContact)
                
                EztDynamicIsland()
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                    .environmentObject(store)
                    .environmentObject(catalogVM)
                  
                    .tag(WallpaperTab.DynamicIsland)
                EztLiveWallpaperView()
                    .environmentObject(liveVM)
                  
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                    .environmentObject(store)
                    .tag(WallpaperTab.Live)
            }).tabViewStyle(.page(indexDisplayMode: .never))
                .background(
                    Color.clear
                )
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .addBackground()
           
    }
}


extension EztWallpaperView{
    func TabControllView() -> some View{
        ScrollViewReader{ reader in
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing : 12){
                    ForEach(WallpaperTab.allCases, id : \.rawValue){
                        tab in
                        
                        Text(tab.rawValue.toLocalize())
                            .mfont(13, currentTab == tab ? .bold : .regular)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            .id(tab)
                            .frame(height : 32)
                            .background(
                                ZStack{
                                    Capsule()
                                        .fill(
                                            Color.white.opacity(0.1)
                                        )
                                    
                                    if currentTab == tab{
                                        
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    stops: [
                                                        Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                                        Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                                        Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                                    ],
                                                    startPoint: UnitPoint(x: 0, y: 1.38),
                                                    endPoint: UnitPoint(x: 1, y: -0.22)
                                                )
                                            )
                                            .matchedGeometryEffect(id: "TAB_WL", in: anim)
                                        
                                        
                                    }
                                    
                                }
                             
                            )
                            .contentShape(Rectangle())
                            .onTapGesture{
                                withAnimation{
                                    currentTab = tab
                                }
                               
                              
                                
                            }
                        
                    }
                    
                    
                }.padding(.leading, 16)
            }.onChange(of: currentTab, perform: {
                tab in
                withAnimation{
                    reader.scrollTo(tab)
                }
            })
        }
      
        
    }
}
