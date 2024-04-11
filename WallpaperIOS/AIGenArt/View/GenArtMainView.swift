//
//  GenArtMainView.swift
//  WallpaperIOS
//
//  Created by Duc on 18/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI


class GenArtMainViewModel : ObservableObject{
    
    @Published var genArtModelList : [GenArtModel] = []
    
    init(){
        getAllModelGenArt()
    }
    
    func getAllModelGenArt() {
        
        guard let url  = URL(string: "\(GenArtConfig.getAllModelURL)") else {
            return
        }
        print("GenArtMainViewModel url \(url.absoluteString)")
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            
            let itemsCurrentLoad = try? JSONDecoder().decode(GenArtResponse.self, from: data)
            DispatchQueue.main.async {
                self.genArtModelList.append(contentsOf: itemsCurrentLoad?.data.data ?? [])
                print("GenArtMainViewModel count: \(self.genArtModelList.count)")
            }
            
        }.resume()
    }
    
}


struct GenArtMainView: View {
    
    let bannerWidth = UIScreen.main.bounds.width - 32
    let bannerHeight = ( UIScreen.main.bounds.width - 32 ) *  184 / 343
    
    @State var navigateToImageGenArt : Bool = false
    @State var navigateToPromptGenArt : Bool = false
    @State var showLimitDialog : Bool = false
    @State var showSubView : Bool = false
    @StateObject var genArtMainViewModel : GenArtMainViewModel = .init()
    @StateObject var posterContactVM : PosterContactViewModel = .init(sort : .NEW)
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(spacing : 0){
                PromptGenArtOpt()
                ImageGenArtOpt()
                PosterContactWallpaper()
               
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            NavigationLink(
                destination: GenArtLimitView()
                    .environmentObject(store)
                   
                
                ,
                isActive: $showLimitDialog,
                label: {
                    EmptyView()
                })
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .addBackground()
        .fullScreenCover(isPresented: $showSubView, content: {
            EztSubcriptionView()
                .environmentObject(store)
        })
        .onViewDidLoad {
            GenArtConfig.getForbiddenResponse()
        }

    }
}

extension GenArtMainView{
    @ViewBuilder
    func ImageGenArtOpt() -> some View{
        ZStack{
            NavigationLink(
                destination: ImageGenArtView()
                    .environmentObject(genArtMainViewModel)
                    .environmentObject(store)
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                
                ,
                isActive: $navigateToImageGenArt,
                label: {
                    EmptyView()
                })
            
            Image("genart_banner2")
                .resizable()
                .onTapGesture {
                    if store.isPro(){
                        navigateToImageGenArt.toggle()
                    }else{
                        if GenArtLimitHelper.canGenArtToday(){
                            navigateToImageGenArt.toggle()
                        }else{
                            showLimitDialog.toggle()
                        }
                    }
                   
                }
        }.frame(width: bannerWidth, height: bannerHeight).padding(.top, 24)
        
    }
    
    @ViewBuilder
    func PromptGenArtOpt() -> some View{
        ZStack{
            NavigationLink(
                destination: PromptGenArtView()
                    .environmentObject(genArtMainViewModel)
                    .environmentObject(store)
                    .environmentObject(rewardAd)
                    .environmentObject(interAd)
                ,
                isActive: $navigateToPromptGenArt,
                label: {
                    EmptyView()
                })
            
            Image("genart_banner1")
                .resizable()
                .onTapGesture {
                    if store.isPro(){
                        navigateToPromptGenArt.toggle()
                    }else{
                        
                        if GenArtLimitHelper.canGenArtToday(){
                            navigateToPromptGenArt.toggle()
                        }else{
                            showLimitDialog.toggle()
                        }
                        
                    }
                  
                    
                }
        }.frame(width: bannerWidth, height: bannerHeight)
            .padding(.top, 16)
    }
    
    
    
    func PosterContactWallpaper() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("AI Poster Contact".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    EztPosterContactView()
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                    
                }, label: {
                    HStack(spacing : 0){
                        Text("See All".toLocalize())
                            .mfont(11, .regular)
                            .foregroundColor(.white)
                        Image("arrow.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18, alignment: .center)
                    }
                })
                
                
                
            }.padding(.horizontal, 16)
            ZStack{
                if posterContactVM.wallpapers.isEmpty{
                
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack(spacing : 12){
                            Spacer()
                                .frame(width: 4)
                            ForEach(posterContactVM.wallpapers.indices, id: \.self){
                                i in
                                let string = posterContactVM.wallpapers[i].thumbnail?.path.preview ?? ""
                                NavigationLink(destination: {
                                    SpWLDetailView(index: i)
                                        .environmentObject(posterContactVM as SpViewModel)
                                        .environmentObject(store)
                                        .environmentObject(rewardAd)
                                        .environmentObject(interAd)
                                }, label: {
                                    WebImage(url: URL(string: string))
                                        .resizable()
                                        .placeholder {
                                            placeHolderImage()
                                        }
                                        .scaledToFill()
                                        .frame(width: 128, height: 280)
                                        .clipped()
                                        .cornerRadius(8)
                                })
                                
                                
                            }
                        }
                    }

                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 280)
        }.padding(.top, 24)
    }
}

#Preview {
    GenArtMainView()
}
