//
//  ShufflePackView.swift
//  WallpaperIOS
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShufflePackView: View {
    
    @StateObject var viewModel : ShufflePackViewModel = .init(sort: .NEW, sortByTop: .TOP_WEEK)
    @Environment(\.presentationMode) var presentationMode
    
    @State var store : MyStore = .shared

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
                Text("Shuffle Pack")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 16), GridItem.init(spacing : 0)], spacing: 16 ){
                    if !viewModel.wallpapers.isEmpty {
                        
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){ i in
                            let shuffle = viewModel.wallpapers[i]
                            Button(action: {
                                EztMainViewModel.shared.paths.append(Router.gotoShuffleDetailView(wallpaper: shuffle))
                                
                            }, label: {
                                ItemShuffleWL2(wallpaper: shuffle, isPro: store.isPro())
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
                .padding(16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.bottom)
        .addBackground()
        .overlay(alignment: .bottom){
            if store.allowShowBanner(){
                BannerAdViewMain(adStatus: $adStatus)
            }
        }

    }
}
