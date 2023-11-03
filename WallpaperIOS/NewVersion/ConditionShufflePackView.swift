//
//  ConditionShufflePackView.swift
//  WallpaperIOS
//
//  Created by Duc on 30/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI


class ConditionShufflePackViewModel: SpViewModel {
    
    @Published var allowFetch : Bool = false
    
    @Published var additionalParam : String = ""
    
    override init() {
        print("ConditionShufflePackViewModel init")
    }
    
    override func getWallpapers() {
            
        if !allowFetch && additionalParam.isEmpty{
            return
        }
        
            let urlString = "\(domain)api/v1/image-specials?limit=\(AppConfig.limit)\(additionalParam)&offset=\(currentOffset)&with=special_content+type,id,title&where=special_content_v2_id+1\(AppConfig.forOnlyIOS)"
            
            guard let url  = URL(string: urlString) else {
                return
            }
            
            
            print("ViewModel SP ShufflePackViewModel \(url.absoluteString)")
            
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



struct ConditionShufflePackView: View {
    @StateObject var viewModel : ConditionShufflePackViewModel = .init()
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    var urlString : String = ""
    
    
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
                LazyVGrid(columns: [GridItem.init(spacing: 0), GridItem.init(spacing : 0)], spacing: 16 ){
                    
                    if !viewModel.wallpapers.isEmpty {
                        ForEach(0..<viewModel.wallpapers.count, id: \.self){
                            i in

                            let shuffle = viewModel.wallpapers[i]

//                            
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
                }
                .padding(16)
            }
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.bottom)
            .addBackground()
            .onAppear(perform: {
                viewModel.additionalParam = urlString
                viewModel.allowFetch = true
                viewModel.getWallpapers()
            })
    }
}

