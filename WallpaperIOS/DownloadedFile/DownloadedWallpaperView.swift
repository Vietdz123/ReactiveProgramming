//
//  DownloadedWallpaperView.swift
//  WallpaperIOS
//
//  Created by Mac on 27/04/2023.
//

import SwiftUI

struct DownloadedWallpaperView: View {
    
    @StateObject var viewModel : FileSaveViewModel = .init()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var isViewWL : Bool = true
    
    var body: some View {
        VStack(spacing : 0){
            
            
            
            Text("Downloaded")
                .foregroundColor(.yellow)
                .mfont(17, .bold)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .overlay(
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image( "back")
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .frame(width: 64, height: 44)
                            .contentShape(Rectangle())
                    }), alignment: .leading
                )
            
       
            
            
            HStack(spacing : 0){
                Text("Wallpaper")
                    .mfont(16,isViewWL ? .bold : .regular)
                    .foregroundColor( isViewWL ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation{
                            isViewWL = true
                        }
                    }
                  
                Text("Live Wallpaper")
                    .mfont(16, !isViewWL ? .bold : .regular)
                    .foregroundColor( !isViewWL ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation{
                            isViewWL = false
                        }
                    }
            }
            .frame(maxWidth: .infinity)
            .frame( height: 44)
            .padding(.horizontal, 40)
            
            TabView(selection: $isViewWL){
                ZStack{
                    if viewModel.imageDownloadeds.isEmpty{
                        VStack{
                           
                            Image(systemName: "arrow.down.to.line")
                                .resizable()
                                .foregroundColor(.gray)
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 44, height: 44)
                            
                            Text("The wallpaper you downloaded will be here")
                                .foregroundColor(.gray)
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }else{
                        ScrollView(.vertical, showsIndicators: false){
                            LazyVGrid(columns: [GridItem.init(spacing  : 8), GridItem.init()], spacing: 8){
                                ForEach(0..<viewModel.imageDownloadeds.count, id: \.self){ i  in
                                    let url = viewModel.imageDownloadeds[i]
                                    NavigationLink(destination: {
                                       DownloadFileView(index: i)
                                            .environmentObject(viewModel)
                                    }, label: {
                                        AsyncImage(url: url){
                                            phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .clipped()
                                            } else if phase.error != nil {
                                                Color.red
                                            } else {
                                                Color.blue
                                            }
                                            
                                            
                                        }
                                        .frame(width: AppConfig.imgWidth, height: AppConfig.imgHeight)
                                        .cornerRadius(2)
                                    })
                                }
                            }.padding(16)
                        }
                    }
                }
                .background(Color.black)
                
                .tag(true)
                ZStack{
                
                        VStack{
                           
                            Image(systemName: "arrow.down.to.line")
                                .resizable()
                                .foregroundColor(.gray)
                                .aspectRatio( contentMode: .fit)
                                .frame(width: 44, height: 44)
                            
                            Text("The live wallpaper you downloaded will be here")
                                .mfont(13, .regular)
                                .foregroundColor(.gray)
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                   
                }
                .background(Color.black)
                .tag(false)
            }      
        }
        .addBackground()
      
    }
}

struct DownloadedWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadedWallpaperView()
    }
}
