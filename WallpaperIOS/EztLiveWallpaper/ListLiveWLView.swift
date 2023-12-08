//
//  ListLiveWLView.swift
//  WallpaperIOS
//
//  Created by Mac on 07/06/2023.


import SwiftUI
import SDWebImageSwiftUI

struct ListLiveWLView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel : LiveWallpaperViewModel
    @EnvironmentObject var reward : RewardAd
   
    @EnvironmentObject var store : MyStore
   
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    @Namespace var anim
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
                Text( "Live Wallpaper")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init()], spacing: 8 ){
                    
                    if !viewModel.liveWallpapers.isEmpty {
                        ForEach(0..<viewModel.liveWallpapers.count, id: \.self){
                            i in
                            let  wallpaper = viewModel.liveWallpapers[i]
                            let string : String = wallpaper.image_variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
                            
                            NavigationLink(destination: {
                                LiveWLView(currentIndex : i)
                                    .navigationBarTitle("", displayMode: .inline)
                                    .navigationBarHidden(true)
                                    .environmentObject(viewModel)
                                    .environmentObject(store)
                                   
                                    .environmentObject(reward)
                                    .environmentObject(interAd)
                                
                            }, label: {
//                                AsyncImage(url: URL(string: string)){
//                                    phase in
//                                    if let image = phase.image {
//                                        image
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
//                                            .clipped()
//                                    } else if phase.error != nil {
//                                        AsyncImage(url: URL(string: string)){
//                                            phase in
//                                            if let image = phase.image {
//                                                image
//                                                    .resizable()
//                                                    .scaledToFill()
//                                                    .frame(width: getRect().width, height: getRect().height)
//                                                    .clipped()
//                                            }
//                                        }
//                                    } else {
//                                        placeHolderImage()
//                                    }
//
//
//                                }
//                                .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
//                                .cornerRadius(2)
                                WebImage(url: URL(string: string))
                                
                                   .onSuccess { image, data, cacheType in
                                       // Success
                                       // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                   }
                                   .resizable()
                                   .placeholder {
                                       placeHolderImage()
                                           .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
                                   }
                                   .indicator(.activity) // Activity Indicator
                                   .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                   .scaledToFill()
                                   
                                 
                                   
                                .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
                                .cornerRadius(2)
                                .overlay(
                                 
                                       
                                            
                                            HStack(spacing : 0){
                                               
                                                Image("live")
                                                    .resizable()
                                                    .frame(width: 16, height: 16 )
                                                    .padding(8)
                                                Spacer()
                                                if !store.isPro(){
                                            
                                                    Image("coin")
                                                        .resizable()
                                                        .frame(width: 13, height: 13, alignment: .center)
                                                    Text("\(wallpaper.cost ?? 0)")
                                                     //   .coinfont(10, .regular)
                                                        .foregroundColor(.white)
                                                    
                                                .frame(width: 16, height: 16, alignment: .center)
                                                    .background(
                                                        Capsule()
                                                            .fill(Color.black.opacity(0.7))
                                                    )
                                                    .padding(8)
                                            }
                                               
                                                
                                            }
                                            
                                            
                                            
                                            
                                     
                                    
                                    
                                    , alignment: .top
                                )
                            })
                            
                            
                            .onAppear(perform: {
                                if i == ( viewModel.liveWallpapers.count - 6 ){
                                    viewModel.getDataByPage()
                                }
                            })
                            
                        }
                    }
                }
                .padding(16)
            }
            
        }
        .addBackground()
    }
}

struct ListLiveWLView_Previews: PreviewProvider {
    static var previews: some View {
        ListLiveWLView()
    }
}
