//
//  EztSpecialPageView.swift
//  WallpaperIOS
//
//  Created by Duc on 20/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztSpecialPageView: View {
    @Namespace var anim
    @Environment(\.presentationMode) var presentationMode
 
    
    @StateObject var viewModel : SpecialPageViewModel = .init()
    let currentTag : String
    let type : Int
    let tagID : Int
   
    
    @EnvironmentObject var interVM : InterstitialAdLoader
    @EnvironmentObject var rewardVM : RewardAd
    @EnvironmentObject var storeVM : MyStore
    
    
    var body: some View {
        VStack(spacing : 0){
            HStack(spacing : 0){
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image("back")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .containerShape(Rectangle())
            })
            Text(currentTag)
                .foregroundColor(.white)
                .mfont(22, .bold)
                .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            
        }.frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 44)
            .padding(.horizontal, 20)
        
            HStack(spacing : 12){
                ForEach(SpSort.allCases, id: \.rawValue){
                    sort in
                    
              
                        Text(sort.rawValue.toLocalize())
                            .mfont(13, .bold)
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                          .frame(width : 80, height: 28)
                          .background(
                            ZStack{
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                                
                                if viewModel.sort == sort{
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
                                        .matchedGeometryEffect(id: "SORT", in: anim)
                                }
                                
                            }
                            
                          )
                          .contentShape(Rectangle())
                          .onTapGesture(perform: {
                              if viewModel.sort == sort{
                                  return
                              }
                              
                              withAnimation{
                                  viewModel.sort = sort
                              }
                              viewModel.currentOffset = 0
                              viewModel.wallpapers.removeAll()
                              viewModel.getWallpapers()
                          })
                 
                    
                }
                
                Spacer()
            }.padding( 16)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8),  GridItem.init()], spacing: 8 ){
                    if !viewModel.wallpapers.isEmpty {
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            let  wallpaper :SpWallpaper = viewModel.wallpapers[i]
                            
                            
                            NavigationLink(destination: {
                                if wallpaper.specialContentV2ID == 1 {
                                    ShuffleDetailView(wallpaper: wallpaper)
                                        .environmentObject(rewardVM)
                                        .environmentObject(interVM)
                                        .environmentObject(storeVM)
                                        
                                }else{
                                    SpWLDetailView( index: i)
                                        .environmentObject(viewModel as SpViewModel)
                                        .environmentObject(rewardVM)
                                        .environmentObject(interVM)
                                        .environmentObject(storeVM)
                                       
                                }
                            }, label: {
                        
                                    
                               
                                if wallpaper.specialContentV2ID == 1 {
                                    ItemShuffleWL2(wallpaper: wallpaper, isPro: storeVM.isPro())
                                }else if wallpaper.specialContentV2ID == 2{
                                    ItemDepthEffectWL(wallpaper: wallpaper, isPro: storeVM.isPro())
                                }else{
                                    ItemDynamictWL(wallpaper: wallpaper, isPro: storeVM.isPro())
                                }
                              
                                
                            })
                            
                            
                            .onAppear(perform: {
                                if i == ( viewModel.wallpapers.count - 6 ){
                                    viewModel.getWallpapers()
                                    
                                }
                                
                                
                               
                                
                            })
                            
                        }
                    }
                }
                .padding(.horizontal, 16)
            }.refreshable {
              
                viewModel.currentOffset = 0
                viewModel.wallpapers.removeAll()
                viewModel.getWallpapers()
            }
            .onAppear(perform: {
             
                
                if  viewModel.type == 0 || viewModel.tagId == 0 && viewModel.wallpapers.isEmpty{
                    viewModel.type = type
                    viewModel.tagId = tagID
                    viewModel.currentTag = currentTag
                    
                    viewModel.sort = .NEW
                    viewModel.wallpapers = []
                    viewModel.currentOffset = 0
                    viewModel.getWallpapers()
                }
                
                
            })
            
            
        
        
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .edgesIgnoringSafeArea(.bottom)
            .addBackground()
    }
}

#Preview {
    EztSpecialPageView(currentTag: "Nature", type: 1, tagID: 3)
}
