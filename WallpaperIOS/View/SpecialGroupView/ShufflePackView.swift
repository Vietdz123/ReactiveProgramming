//
//  ShufflePackView.swift
//  WallpaperIOS
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ShufflePackView: View {
    @EnvironmentObject var viewModel : ShufflePackViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    
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
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            let shuffle = viewModel.wallpapers[i]

                            NavigationLink(destination: {
                              ShuffleDetailView(wallpaper: shuffle)
                                    .environmentObject(store)
                                    .environmentObject(interAd)
                                    .environmentObject(reward)
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
                } .padding(16)
              
            } 
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.bottom)
            .addBackground()
    }
}

struct ShufflePackView_Previews: PreviewProvider {
    static var previews: some View {
        ShufflePackView()
    }
}
