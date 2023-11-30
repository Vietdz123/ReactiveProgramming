//
//  EztForYou.swift
//  WallpaperIOS
//
//  Created by Duc on 23/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EztForYouView: View {
    @EnvironmentObject var viewModel : HomeViewModel
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
  
    
 
    
    @StateObject var tagViewModel : TagViewModel = .init()
    
    var body: some View {
        
        ZStack{
            NavigationLink(isActive: $tagViewModel.navigateAtHome, destination: {
                TagView()
                    .environmentObject(tagViewModel)
                    .environmentObject(reward)
                    .environmentObject(store)
                    .environmentObject(favViewModel)
                    .environmentObject(interAd)
                
            }, label: {
                EmptyView()
            })
            
            
            if !viewModel.wallpapers.isEmpty{
                VStack(spacing : 0){

                    ScrollView(.vertical, showsIndicators: false){
                        CompositionalView(items: 0..<viewModel.wallpapers.count, id: \.self, content: {
                            index in
                            
                            GeometryReader{
                                proxy in
                                let size = proxy.size
                                let wallpaper = viewModel.wallpapers[index]
                                let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
                                
                                NavigationLink(destination: {
                                    WLView(index: index)
                                        .environmentObject(viewModel as CommandViewModel)
                                        .environmentObject(reward)
                                        .environmentObject(store)
                                        .environmentObject(favViewModel)
                                        .environmentObject(interAd)
                                }, label: {
                                    
                                    WebImage(url: URL(string: string))
                                        .onSuccess { image, data, cacheType in
                                            
                                        }
                                        .resizable()
                                        .placeholder {
                                            placeHolderImage()
                                                .frame(width: size.width, height: size.height)
                                        }
                                        
                                        .scaledToFill()
                                        .clipped()
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                        .cornerRadius(8)
                                        .overlay(alignment : .topTrailing){
                                            if !store.isPro() && wallpaper.content_type  == "private" {
                                                Image("crown")
                                                    .resizable()
                                                    .frame(width: 16, height: 16, alignment: .center)
                                                    .padding(8)
                                            }
                                        }

                                    
                                })
                               
                                
                                .onAppear(perform: {
                         
                                    if viewModel.shouldLoadData(id: index){
                                        viewModel.getWallpapers()
                                        
                                    }
                                })
                                
                            }
                         
                            
                        }, content2: { index in
                            if !viewModel.tags.isEmpty && index < viewModel.tags.count{
                                TagViewBuilder(tag: viewModel.tags[index])
                                    .onAppear(perform: {
                                        if viewModel.checkLoadNextPageTag(index: index) == true{
                                            viewModel.getTags()
                                           
                                        }
                                    })
                                    
                            }
                        
                        }).padding(.horizontal, 16)
                        
                        
                        
                        
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                
                
                
            }

            
        }
        .refreshable {
            viewModel.wallpapers.removeAll()
            viewModel.getWallpapers()
            viewModel.tags.removeAll()
            viewModel.getTags()
        }

    }
    
    func TagViewBuilder(tag : Tag) -> some View{
        Button(action: {
            tagViewModel.tag = tag.title
            tagViewModel.navigateAtHome.toggle()
        }, label: {
            HStack(spacing : 8){
                VStack(alignment: .leading, spacing : 0){
                    Text("\(tag.title)")
                        .mfont(17, .bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    Text("Awesome category for you!".toLocalize())
                        .mfont(11, .regular)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(width: 120, alignment: .leading)
                        .padding(.top, 4)
                    Spacer()
                    HStack(spacing : 12){
                        Text("Discover".toLocalize())
                            .mfont(15, .regular)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Image("arrow.right")
                            .resizable()
                            .frame(width: 16, height: 16)

                    }.frame(width: 120, height: 36, alignment: .center)
                        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0))
                        .background(
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
                        )
                        .padding(.bottom , 24)


                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                ZStack{
                    HStack{
                        WebImage(url: URL(string: tag.images[0].previewSmallURL ))
                                 
                                     .onSuccess { image, data, cacheType in
                                   
                                     }
                                     .resizable()
                                     .placeholder {
                                         placeHolderImage()
                                             .frame( width: 80,height: 160)
                                     }
                                     .indicator(.activity) // Activity Indicator
                                     .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                     .scaledToFill()
                                     .frame( width: 80,height: 160)
                                     .cornerRadius(4)
                        
                        WebImage(url: URL(string: tag.images[1].previewSmallURL))
                                 
                                     .onSuccess { image, data, cacheType in
                                   
                                     }
                                     .resizable()
                                     .placeholder {
                                         placeHolderImage()
                                             .frame( width: 80,height: 160)
                                     }
                                     .indicator(.activity) // Activity Indicator
                                     .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                     .scaledToFill()
                                     .frame( width: 80,height: 160)
                                     .cornerRadius(4)
                        
                    }
                    
                  

                }.frame(maxWidth: .infinity)
                   
            
            }
            .frame(maxWidth: .infinity)
            .frame(height: 176)
            .background(
                ZStack{

                    VisualEffectView(effect: UIBlurEffect(style: .dark))


                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .white.opacity(0.15), location: 0.00),
                            Gradient.Stop(color: .white.opacity(0), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 0.5),
                        endPoint: UnitPoint(x: 1, y: 0.5)
                    )


                }
            )
            .cornerRadius(8)
         
        })
    }
}

#Preview {
    EztMainView()
}
