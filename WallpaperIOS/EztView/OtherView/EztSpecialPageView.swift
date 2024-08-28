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

    @StateObject var storeVM : MyStore = .shared
    @State var adStatus : AdStatus = .loading
    
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 44)
            .padding(.horizontal, 20)
            
            HStack(spacing : 12) {
                ForEach(SpSort.allCases, id: \.rawValue) { sort in
                    
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
                            let wallpaper: SpWallpaper = viewModel.wallpapers[i]
                            
                            Button(action: {
                                if wallpaper.specialContentV2ID == 1 {
                                    EztMainViewModel.shared.paths.append(Router.gotoShuffleDetailView(wallpaper: wallpaper))
                                    
                                } else {
                                    EztMainViewModel.shared.paths.append(Router.gotoSpecialWalliveDetailView(currentIndex: i,
                                                                                                        wallpapers: viewModel.wallpapers))
                                }
                            }, label: {
                                if wallpaper.specialContentV2ID == 1 {
                                    ItemShuffleWL2(wallpaper: wallpaper, isPro: storeVM.isPro())
                                        .padding(.bottom, 8)
                                    
                                } else if wallpaper.specialContentV2ID == 2{
                                    ItemDepthEffectWL(wallpaper: wallpaper, isPro: storeVM.isPro())
                                    
                                } else {
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
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                .padding(.horizontal, 16)
            }
            .refreshable {
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
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .edgesIgnoringSafeArea(.bottom)
        .addBackground()
        .overlay(alignment : .bottom){
            if storeVM.allowShowBanner(){
                BannerAdViewMain(adStatus: $adStatus)
            }
        }
        
    }
}
