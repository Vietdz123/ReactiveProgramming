//
//  ConditionDynamicView.swift
//  WallpaperIOS
//
//  Created by Duc on 30/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI


class ConditionDynamicViewModel: SpViewModel {
    
    @Published var allowFetch : Bool = false
    
    @Published var additionalParam : String = ""
    
    override init(sort : SpSort = .NEW, sortByTop : SpTopRate = .TOP_WEEK) {
        print("ConditionDynamicViewModel init")
        
        super.init(sort: sort, sortByTop: sortByTop)
    }
    
    override func getWallpapers() {
            
        if !allowFetch && additionalParam.isEmpty{
            return
        }
        
            let urlString = "\(domain)api/v1/image-specials?limit=\(AppConfig.limit)\(additionalParam)&offset=\(currentOffset)&with=special_content+type,id,title&where=special_content_v2_id+3\(AppConfig.forOnlyIOS)"
            
            guard let url  = URL(string: urlString) else {
                return
            }
            
            
            print("ViewModel SP ConditionDynamicViewModel \(url.absoluteString)")
            
            URLSession.shared.dataTask(with: url){
                data, _ ,err  in
                guard let data = data, err == nil else {
                    return
                }
               
                let itemsCurrentLoad = try? JSONDecoder().decode(SpResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.wallpapers.append(contentsOf: itemsCurrentLoad?.data.data  ?? [])
                    self.currentOffset = self.currentOffset + AppConfig.limit


                }
                
            }.resume()
        }
   
}

struct ConditionDynamicView: View {
    var addPram : String = ""
    @StateObject var viewModel : ConditionDynamicViewModel = .init()
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
                Text("Dynamic Island")
                    .foregroundColor(.white)
                    .mfont(22, .bold)
                    .frame(maxWidth: .infinity).padding(.trailing, 18)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(.horizontal, 20)
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: [GridItem.init(spacing: 8),GridItem.init()], spacing: 8 ){
                    
                    if !viewModel.wallpapers.isEmpty {
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in
                            let  wallpaper = viewModel.wallpapers[i]
                            let string : String = wallpaper.path.first?.path.small ?? ""
                            
                            Button(action: {
                                EztMainViewModel.shared.paths.append(Router.gotoSpecialWalliveDetailView(currentIndex: i,
                                                                                                    wallpapers: viewModel.wallpapers))
                                
                            }, label: {
                                WebImage(url: URL(string: string))
                                    .onSuccess { image, data, cacheType in
                                    }
                                    .resizable()
                                    .placeholder {
                                        placeHolderImage()
                                            .frame(width: AppConfig.width_1, height: AppConfig.height_1)
                                    }
                                    .frame(width: AppConfig.width_1, height: AppConfig.height_1)
                                    .cornerRadius(8)
                                    .overlay(
                                        Image("dynamic")
                                            .resizable()
                                            .cornerRadius(8)
                                    )
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
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .edgesIgnoringSafeArea(.bottom)
            .addBackground()
            .overlay(
                ZStack{
                    if store.allowShowBanner(){
                        BannerAdViewMain(adStatus: $adStatus)
                            
                    }
                }
                
                , alignment: .bottom
            )
            .onAppear(perform: {
                viewModel.additionalParam = addPram
                viewModel.allowFetch = true
                viewModel.getWallpapers()
            })
    }
}

#Preview {
    ConditionDynamicView()
}
