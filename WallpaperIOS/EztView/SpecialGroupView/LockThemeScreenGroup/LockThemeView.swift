//
//  LockThemeView.swift
//  WallpaperIOS
//
//  Created by Duc on 07/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

struct LockThemeListView: View {
    @StateObject var viewModel : LockThemeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var adStatus : AdStatus = .loading
    @StateObject private var store = MyStore.shared
    
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
                Text("Lock Screen Themes")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 44)
            .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8), GridItem.init()], spacing: 8 ){
                    
                    if !viewModel.wallpapers.isEmpty {
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            let wallpaper = viewModel.wallpapers[i]
                            let string : String = wallpaper.thumbnail.first?.url.full ?? ""
                            
                            Button(action: {
                                EztMainViewModel.shared.paths.append(Router.gotoLockThemeDetailView(wallpapers: viewModel.wallpapers, currentIndex: i))
                                
                            }, label: {
                                ZStack{
                                    if string.contains(".json"){
                                        if let url = URL(string: string){
                                            LottieView {
                                                await LottieAnimation.loadedFrom(url:  url )
                                            } .looping()
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: AppConfig.width_1, height: AppConfig.width_1 * 2.2)
                                               
                                        }

                                    } else {
                                        WebImage(url: URL(string: wallpaper.thumbnail.first?.url.preview ?? ""))
                                            .resizable()
                                            .placeholder {
                                                placeHolderImage()
                                                    .frame(width: AppConfig.width_1, height: AppConfig.width_1 * 2.2)
                                            }
                                          
                                            .scaledToFill()
                                    }
                                   
                                }
                                .frame(width: AppConfig.width_1, height: AppConfig.width_1 * 2.2)
                                .cornerRadius(8)
                                .showCrownIfNeeded(!store.isPro() && wallpaper.private == 1)
                                .onAppear(perform: {
                                    if i == ( viewModel.wallpapers.count - 6 ){
                                        viewModel.getWallpapers()
                                    }
                                })
                            })
                   
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                .padding(16)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .edgesIgnoringSafeArea(.bottom)
        .addBackground()

    }
}

