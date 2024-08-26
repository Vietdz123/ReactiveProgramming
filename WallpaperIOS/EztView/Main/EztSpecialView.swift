//
//  EztSpecialView.swift
//  WallpaperIOS
//
//  Created by Duc on 04/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct SpecialCategoryResponse: Codable {
    let data: SpecialCategoryData
}

struct SpecialCategoryData : Codable{
    let data: [SpecialCategory]
}

struct SpecialCategory: Codable {
    let id: Int
    let title: String
    let active, dailyRating, type, order: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, active
        case dailyRating = "daily_rating"
        case type, order
        
    }
}


class SpecialCategoryViewModel : ObservableObject {
    
    
    @Published var categoryList : [SpecialCategory] = []
    
    @Published var showGift : Bool = false
    
    init(){
        getCategorySortByDailyRating()
    }
    
    
    
    func changeSubType() {
        
        
        let subTypeSave =  UserDefaults.standard.integer(forKey: "gift_sub_type")
        
        
        if subTypeSave == 0 {
            UserDefaults.standard.set(1, forKey: "gift_sub_type")
        }else if subTypeSave == 1 {
            UserDefaults.standard.set(2, forKey: "gift_sub_type")
        }else if subTypeSave == 2 {
            UserDefaults.standard.set(0, forKey: "gift_sub_type")
        }
        
        
    }
    
    func getCategorySortByDailyRating() {
        let urlString = "https://wallpaper.eztechglobal.com/api/v1/special-contents-v2?app=2&order_by=daily_rating+desc&normal=1"
        
        
        
        
        guard let url  = URL(string: urlString) else {
            return
        }
        
        
        print("ViewModel SpecialCategoryViewModel \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url){
            data, _ ,err  in
            guard let data = data, err == nil else {
                return
            }
            
            let itemsCurrentLoad = try? JSONDecoder().decode(SpecialCategoryResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.categoryList.append(contentsOf: itemsCurrentLoad?.data.data ?? [])
                print("ViewModel SpecialCategoryViewModel \(self.categoryList.count)")
                
                
            }
            
        }.resume()
    }
    
    
}

struct EztSpecialView: View {
    
    @StateObject var store : MyStore = .shared
    @StateObject var wallpaperCatelogVM : WallpaperCatalogViewModel = .shared
    @StateObject var viewModel : SpecialCategoryViewModel = .init()
    @StateObject var lockScreenVM : LockThemeViewModel = .init(sort : .NEW, sortByTop: .TOP_WEEK)
    @StateObject var depthVM : DepthEffectViewModel = .init(sort : .NEW, sortByTop: .TOP_WEEK)
    @StateObject var dynamicVM : DynamicIslandViewModel = .init(sort : .NEW, sortByTop: .TOP_WEEK)
    @StateObject var lightningVM : LightingEffectViewModel = .init(sort : .NEW, sortByTop: .TOP_WEEK)
    @StateObject var posterContactVM : PosterContactViewModel = .init(sort : .NEW, sortByTop: .TOP_WEEK)
    @StateObject var shuffleVM : ShufflePackViewModel = .init(sort : .NEW, sortByTop: .TOP_WEEK)
    @StateObject var watchFaceViewModel : EztWatchFaceViewModel = .init(sort : .NEW, sortByTop: .TOP_WEEK)
    
    @StateObject var liveWlVM : LiveWallpaperViewModel = .init(sort: .NEW, sortByTop: .TOP_WEEK)
    
    @Binding var showGift : Bool
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            
            
            
            
            
            if !viewModel.categoryList.isEmpty{
                LazyVStack(spacing : 0){
                    
                    
                    
                    
                    ForEach(0..<7, id: \.self){
                        index in
                        let category = viewModel.categoryList[index]
                        ViewFromId(id: category.id)
                    }
                    
                    
                    
                }.padding(EdgeInsets(top: -24, leading: 0, bottom: 100, trailing: 0))
            }else{
                ProgressView()
                    .frame(width: 24, height: 24)
                    .padding(.top, 24)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .addBackground()
        
        
    }
    
    
}

extension EztSpecialView{
    
    func ViewFromId(id : Int) -> some View{
        ZStack{
            switch id {
            case 1 :
                //Shuffle Pack
                ShufflePackInHome()
            case 2 :
                DepthEffectViewInHome()
            case 3 :
                //Dynmic Island
                DynamicIslandInHome()
            case 5 :
                //Watch Face
                WatchFaceViewInHome()
            case 6 :
                //Poster Contact
                PosterContactInHome()
            case 7 :
                //Lighting Effects
                LightningEffectInHome()
            case 8 :
                LiveWallpaperInHome()
            default:
                EmptyView()
            }
        }
        
    }
    
    func WatchFaceViewInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0) {
                Text("Best Watch Face".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                //MARK: - Viet
                Button(action: {
                    EztMainViewModel.shared.paths.append(Router.gotoNewestAnSpecialWatchFaceView)
                    
                }, label: {
                    SeeAllView()
                })
                
            }
            .padding(.horizontal, 16)
            
            ZStack{
                if watchFaceViewModel.wallpapers.isEmpty{
                    
                } else {
                    let itemshow = min(6, watchFaceViewModel.wallpapers.count)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 12){
                            ForEach(0..<itemshow, id: \.self){
                                i in
                                let  wallpaper = watchFaceViewModel.wallpapers[i]
                                let string : String = wallpaper.path.first?.path.preview ?? ""
                                
                                //MARK: - Viet
                                NavigationLink(destination: {
                                    WatchFaceDetailView(wallpaper: wallpaper)
                                    
                                }, label: {
                                    ZStack{
                                        Color.black
                                        WebImage(url: URL(string: string))
                                            .resizable()
                                            .cornerRadius(24)
                                            .padding(9)
                                    }
                                    .frame(width: 139 , height: 176)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .cornerRadius(30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .inset(by: 1.5)
                                            .stroke(.white.opacity(0.3), lineWidth: 3)
                                    )
                                    .overlay(alignment: .bottomTrailing, content: {
                                        VStack(alignment: .trailing, spacing : 0){
                                            Text("TUE 16")
                                                .mfont(11, .bold, line: 1)
                                                .multilineTextAlignment(.trailing)
                                                .foregroundColor(.white)
                                                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                                            
                                            Text("10:09")
                                                .mfont(32, .regular, line: 1)
                                                .multilineTextAlignment(.trailing)
                                                .foregroundColor(.white)
                                                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                                                .offset(y : -8)
                                            
                                            
                                        }.padding(.bottom, 12)
                                            .padding(.trailing , 20)
                                    })
                                    .overlay(alignment: .topTrailing, content: {
                                        if !store.isPro()  && wallpaper.contentType == 1 {
                                            Image("crown")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                                .padding(.top, 16)
                                                .padding(.trailing, 18)
                                        }
                                    })
                                })
                                
                            }
                        }
                        
                        
                    }
                    .frame(height: 176)
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 176)
            
            
            
            
        }.padding(.top, 24)
    }
    
    @ViewBuilder
    func ShufflePackInHome() -> some View{
        
        VStack(spacing : 16){
            
            HStack(spacing : 0) {
                Text("Shuffle Packs".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                //MARK: - Viet
                Button(action: {
                    EztMainViewModel.shared.paths.append(Router.gotoShufflePackView)
                    
                }, label: {
                    SeeAllView()
                    
                })
                
            }
            .padding(.horizontal, 16)
            .padding(.horizontal, 16)
            
            
            ZStack{
                if shuffleVM.wallpapers.isEmpty{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0) {
                            
                            ForEach(0..<4, id: \.self) {
                                i in
                                
                                
                                ZStack(alignment: .trailing){
                                    placeHolderImage()
                                        .frame(width: 100, height: 200)
                                        .cornerRadius(8)
                                    
                                    Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 110, height: 220)
                                        .cornerRadius(8)
                                        .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                                    
                                        .padding(.trailing, 12)
                                    
                                    
                                    Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 120, height: 240)
                                        .cornerRadius(8)
                                        .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                                    
                                        .padding(.trailing, 24)
                                    
                                }.frame(width: 160, height: 240)
                                
                                
                            }
                            
                        }
                        
                        
                    }.padding(.horizontal, 16).disabled(true)
                }else{
                    
                    let itemShow = min(9, shuffleVM.wallpapers.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0) {
                            ForEach(0..<itemShow, id: \.self) {
                                i in
                                let shuffle = shuffleVM.wallpapers[i]
                                
                                
                                //MARK: - Viet
                                NavigationLink(destination: {
                                    ShuffleDetailView(wallpaper: shuffle)
                                    
                                }, label: {
                                    ItemShuffleWL(wallpaper: shuffle, isPro: store.isPro())
                                })
                                
                            }
                            
                        }
                        
                        
                    }.padding(.horizontal, 8)
                }
            }.frame(height: 240)
            
        }.padding(.top, 24)
        
        
        
        
        
        
        
    }
    
    
    func DepthEffectViewInHome() -> some View{
        VStack(spacing : 16){
            
            HStack(spacing : 0) {
                Text("Depth Effect".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                //MARK: - Viet
                Button(action: {
                    EztMainViewModel.shared.paths.append(Router.gotoDepthEffectView)
                    
                }, label: {
                    SeeAllView()
                    
                })
                
            }
            .padding(.horizontal, 16)
            ZStack{
                
                
                
                if depthVM.wallpapers.isEmpty{
                    PlaceHolderListLoad()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            NavigationLink(destination: {
                                SpWLDetailView(index: 0)
                                
                            }, label: {
                                
                                WebImage(url: URL(string: depthVM.wallpapers.first?.thumbnail?.path.preview ?? ""))
                                    .resizable()
                                    .placeholder {
                                        placeHolderImage()
                                    }
                                    .scaledToFill()
                                    .frame(width: 160, height: 320)
                                    .clipped()
                                    .cornerRadius(8)
                                    .showCrownIfNeeded(!store.isPro() && depthVM.wallpapers.first?.contentType == 1)
                            })
                            
                            
                            LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                                ForEach(1..<15, content: {
                                    i in
                                    let wallpaper = depthVM.wallpapers[i]
                                    NavigationLink(destination: {
                                        SpWLDetailView(index: i)
                                        
                                    }, label: {
                                        WebImage(url: URL(string: wallpaper.thumbnail?.path.preview ?? ""))
                                            .resizable()
                                            .placeholder {
                                                placeHolderImage()
                                            }
                                            .scaledToFill()
                                            .frame(width: 78, height: 156)
                                            .clipped()
                                            .cornerRadius(8)
                                            .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
                                    })
                                    
                                    
                                    
                                    
                                    
                                    
                                })
                            })
                        }
                        
                        
                    }
                    .frame(height: 320)
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 320)
            
            
            
            
        }.padding(.top, 24)
    }
    
    func DynamicIslandInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0) {
                Text("Dynamic Island".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                //MARK: - Viet
                Button(action: {
                    EztMainViewModel.shared.paths.append(Router.gotoDynamicIslandView)
                    
                }, label: {
                    SeeAllView()
                    
                })
                
            }
            .padding(.horizontal, 16)
            
            ZStack{
                
                
                
                if dynamicVM.wallpapers.isEmpty{
                    PlaceHolderListLoad()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            NavigationLink(destination: {
                                SpWLDetailView(index: 0)
                                
                            }, label: {
                                
                                WebImage(url: URL(string: dynamicVM.wallpapers.first?.path.first?.path.preview ?? ""))
                                    .resizable()
                                    .placeholder {
                                        placeHolderImage()
                                    }
                                    .scaledToFill()
                                    .frame(width: 160, height: 320)
                                    .clipped()
                                    .cornerRadius(8)
                                    .overlay(
                                        Image("dynamic")
                                            .resizable()
                                            .cornerRadius(8)
                                    )
                                    .showCrownIfNeeded(!store.isPro() && dynamicVM.wallpapers.first?.contentType == 1)
                            })
                            
                            
                            LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                                ForEach(1..<15, content: {
                                    i in
                                    let wallpaper = dynamicVM.wallpapers[i]
                                    NavigationLink(destination: {
                                        SpWLDetailView(index: i)
                                            .environmentObject(dynamicVM as SpViewModel)
                                            .environmentObject(store)
                                        
                                    }, label: {
                                        WebImage(url: URL(string: wallpaper.path.first?.path.preview ?? ""))
                                            .resizable()
                                            .placeholder {
                                                placeHolderImage()
                                            }
                                            .scaledToFill()
                                            .frame(width: 78, height: 156)
                                            .clipped()
                                            .cornerRadius(8)
                                            .overlay(
                                                Image("dynamic")
                                                    .resizable()
                                                    .cornerRadius(8)
                                            )
                                            .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
                                    })
                                    
                                    
                                    
                                    
                                    
                                    
                                })
                            })
                        }
                        
                        
                    }
                    .frame(height: 320)
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 320)
            
            
            
            
        }.padding(.top, 24)
    }
    
    func PosterContactInHome() -> some View {
        VStack(spacing : 16){
            HStack(spacing : 0) {
                Text("Poster Contact".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                //MARK: - Viet
                Button(action: {
                    EztMainViewModel.shared.paths.append(Router.gotoEztPosterContactView)
                    
                }, label: {
                    SeeAllView()
                    
                })
                
            }
            .padding(.horizontal, 16)
            
            ZStack {
                if posterContactVM.wallpapers.isEmpty{
                    PlaceHolderListLoadHori()
                    
                } else {
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack(spacing: 12, content: {
                            ForEach(0..<7, content: {
                                i in
                                let wallpaper = posterContactVM.wallpapers[i]
                                let string = wallpaper.thumbnail?.path.small ?? ""
                                
                                //MARK: - Viet
                                NavigationLink(destination: {
                                    SpWLDetailView(index: i)
                                    
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
                                        .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
                                    
                                })
                                
                            })
                        })
                        
                    }
                    .frame(height: 280)
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            
        }
        .padding(.top, 24)
        
    }
    
    
    func LightningEffectInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0) {
                Text("Lighting Effects".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                //MARK: - Viet
                Button(action: {
                    EztMainViewModel.shared.paths.append(Router.gotoLightingEffectView)
                    
                }, label: {
                    SeeAllView()
                    
                })
                
            }
            .padding(.horizontal, 16)
            
            
            ZStack {
                
                if lightningVM.wallpapers.isEmpty{
                    PlaceHolderListLoadHori()
                    
                } else {
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack( spacing: 12, content: {
                            ForEach(0..<7, content: {
                                i in
                                let wallpaper = lightningVM.wallpapers[i]
                                let string = wallpaper.path.first?.path.preview  ?? ""
                                
                                
                                //MARK: - Viet
                                NavigationLink(destination: {
                                    SpWLDetailView(index: i)
                                        .environmentObject(lightningVM as SpViewModel)
                                        .environmentObject(store)
                                    
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
                                        .overlay(
                                            Image("dynamic")
                                                .resizable()
                                                .cornerRadius(8)
                                        )
                                        .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
                                })
                            })
                        })
                        
                        
                        
                    }
                    .frame(height: 280)
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            
            
            
            
        }.padding(.top, 24)
    }
    
    //  MARK: LiveWallpaper
    func LiveWallpaperInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0) {
                Text("Live Wallpaper".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                //MARK: - Viet
                Button(action: {
                    EztMainViewModel.shared.paths.append(Router.gotoEztLiveWallpaperView)
                    
                }, label: {
                    SeeAllView()
                    
                })
                
            }
            .padding(.horizontal, 16)

            ZStack{
                
                if liveWlVM.wallpapers.isEmpty{
                    PlaceHolderListLoadHori()
                    
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack( spacing: 12, content: {
                            ForEach(0..<7, content: {
                                i in
                                let wallpaper = liveWlVM.wallpapers[i]
                                let string = wallpaper.thumbnail.first?.path.preview ?? ""
                                
                                //MARK: - Viet
                                Button(action: {
                                    EztMainViewModel.shared.paths.append(Router.gotoLiveWallpaperDetail(currentIndex: i,
                                                                                                    wallpapers: liveWlVM.wallpapers))
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
                                        .overlay(alignment : .top){
                                            HStack{
                                                Image("live")
                                                    .resizable()
                                                    .frame(width: 16, height: 16 )
                                                    .padding(8)
                                                Spacer()
                                                
                                            }
                                        }
                                        .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
                                })

                                
                            })
                        })
                        
                        
                        
                    }
                    .frame(height: 280)
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            
            
            
            
        }.padding(.top, 24)
    }
    
    
}

