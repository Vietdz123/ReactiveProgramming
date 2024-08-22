//
//  EztHomeView.swift
//  WallpaperIOS
//
//  Created by Duc on 16/10/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Lottie

#Preview {
    EztMainView()
}


struct EztHomeView: View {
    
    @Binding var currentTab : EztTab
    @Binding var wallpaperTab : WallpaperTab
    @EnvironmentObject var exclusiveVM : ExclusiveViewModel
    @EnvironmentObject var shuffleVM : ShufflePackViewModel
    @EnvironmentObject var depthVM : DepthEffectViewModel
    @EnvironmentObject var dynamicVM : DynamicIslandViewModel
    
    
    @StateObject var lightningVM : LightingEffectViewModel = .init(sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var posterContactVM : PosterContactViewModel = .init(sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var interactWidgetViewModel : WidgetMainViewModel = .init(type : .ALL, sort : .NEW, sortByTop: .TOP_WEEK)
    @StateObject var gifWidgetVM : WidgetMainViewModel = .init(type : .Gif, sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var digitalFriendWidgetVM : WidgetMainViewModel = .init(type : .DigitalFriend, sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var watchFaceViewModel : EztWatchFaceViewModel = .init(sort : .POPULAR, sortByTop: .TOP_WEEK)
    @StateObject var liveWlVM : LiveWallpaperViewModel = .init(sort: .POPULAR, sortByTop: .TOP_WEEK)
    
    
    
    
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var catalogVM : WallpaperCatalogViewModel 
    
    
   
 
    
    var body: some View {
        
            ScrollView(.vertical, showsIndicators : false){
              
                  
                    
                LazyVStack(spacing: 0, content: {
                    
                
               
                    LiveWallpaperInHome()
                /*1*/   TopWallpaper()
                /*2*/   WidgetInHome()
                /*3*/   WatchFaceViewInHome()
             //   /*4*/   BannerSaleHome()
                /*5*/   DepthEffectViewInHome()
                /*6*/   LightningEffectInHome()
                /*7*/   WidgetDigital()
                /*8*/   ShufflePackInHome()
                /*9*/   WidgetGifInHome()
                /*10*/   PosterContactInHome()
                
                    
                    Spacer()
                        .frame(height: 160)
                })
                
            
            }
            .refreshable {
                
            }
            .addBackground()
           
       
        
      
        
        
        
    }
}

extension EztHomeView{
    
    func BannerSaleHome() -> some View{
        ZStack{
            if !store.isPro(){
                if let product = store.getYearSale50UsingProduct(){
                    VStack(spacing : 0){
                        Text("Unlock all Features".toLocalize())
                            .mfont(17, .bold)
                            .foregroundColor(.main)
                            .frame(maxWidth: .infinity, alignment : .leading)
                            .shadow(color: .main.opacity(0.1), radius: 2)
                            .shadow(color: .main.opacity(0.6), radius: 2)
                            .padding(.leading, 16)
                            .padding(.top, 12)
                        
                        HStack(spacing : 0){

                            
                            Text(String(format: NSLocalizedString("ONLY %@/Week", comment: ""), getDisplayPrice(price: product.price,chia:51, displayPrice: product.displayPrice ) ))
                                .mfont(15, .regular)
                                .foregroundColor(.white)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                            .padding(.leading, 16)
                            .padding(.top, 8)
                        
                        HStack(spacing : 0){
                           // Text("Total \(product.displayPrice)/year ")
                            Text( String(format: NSLocalizedString("Total %@/year", comment: ""), product.displayPrice) )
                                .mfont(13, .regular)
                                .foregroundColor(.white)
                            
                            Text("(\(getDisplayPrice(price: product.price,chia:0.5, displayPrice: product.displayPrice ))/year)")
                                .mfont(13, .regular)
                                .foregroundColor(.white)
                                .overlay(
                                    Rectangle()
                                        .fill(Color.white)
                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                        .frame(height: 1)
                                )
                        }
                        
                        .frame(maxWidth: .infinity, alignment : .leading)
                        .padding(.leading, 16)
                        .padding(.top, 1)
                        
                        Spacer()
                        
                        Button(action: {
                            store.isPurchasing = true
                            showProgressSubView()
                            let log =  "Click_Buy_Sub_In_HomeBanner"
                            Firebase_log(log)
                            store.purchase(product: product, onBuySuccess: {
                                b in
                                if b {
                                    DispatchQueue.main.async{
                                        hideProgressSubView()
                                        store.isPurchasing = false
                                        
                                        
                                        let log1 =
                                        "Buy_Sub_In_Success_HomeBanner"
                                        Firebase_log(log1)
                                        showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                                        
                                        
                                    }
                                    
                                }else{
                                    DispatchQueue.main.async{
                                        store.isPurchasing = false
                                        hideProgressSubView()
                                        showToastWithContent(image: "xmark", color: .red, mess: "Purchase failure!")
                                    }
                                }
                            })
                        }, label: {
                            Text("Claim Now!".toLocalize())
                                .mfont(17, .bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .padding(.horizontal, 16)
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
                        }).padding(.horizontal, 16)
                        
                        
                        HStack{
                            Button(action: {
                                
                            }, label: {
                                Text("Privacy Policy ".toLocalize())
                                    .mfont(9, .regular)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.white)
                            })
                            
                            Text("|")
                                .mfont(9, .regular)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.white)
                            Button(action: {
                                
                            }, label: {
                                Text("Restore".toLocalize())
                                    .mfont(9, .regular)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.white)
                            })
                            
                            Text("|")
                                .mfont(9, .regular)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.white)
                            Button(action: {
                                
                            }, label: {
                                Text("Term of use".toLocalize())
                                    .mfont(9, .regular)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.white)
                            })
                            
                            
                        }.frame(height: 13)
                            .padding(.top, 6)
                            .padding(.bottom, 6)
                        
                        
                        
                        
                    }.frame(width: getRect().width - 32, height: (getRect().width - 32)  * 160 / 343 , alignment: .topLeading)
                        .background(
                            Image("banner_home_hori")
                                .resizable()
                                .scaledToFit()
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                }
                
            }
        }
    }
    //MARK: Top Wallpaper
    func TopWallpaper() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Top Wallpaper".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    TopWallpapersView()
                        .environmentObject(exclusiveVM)
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
                
                
                
                if exclusiveVM.wallpapers.isEmpty{
                    PlaceHolderListLoad()
                }else{
                    
                    let itemshow : Int = min(15, exclusiveVM.wallpapers.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            
                            NavigationLink(destination: {
                                WLView(index: 0)
                                    .environmentObject(exclusiveVM as CommandViewModel)
                                    .environmentObject(rewardAd)
                                    .environmentObject(store)
                                   
                                    .environmentObject(interAd)
                            }, label: {
                                
                                WebImage(url: URL(string: exclusiveVM.wallpapers.first?.variations.preview_small.url ?? ""))
                                    .resizable()
                                    .placeholder {
                                        placeHolderImage()
                                    }
                                    .scaledToFill()
                                    .frame(width: 160, height: 320)
                                    .clipped()
                                    .cornerRadius(8)
                                    .showCrownIfNeeded(exclusiveVM.wallpapers.first?.content_type == "private" && !store.isPro())
                            })
                            
                            
                            LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                                ForEach(1..<itemshow, content: {
                                    i in
                                    let wallpaper = exclusiveVM.wallpapers[i]
                                    
                                    
                                    NavigationLink(destination: {
                                        WLView(index: i)
                                            .environmentObject(exclusiveVM as CommandViewModel)
                                            .environmentObject(rewardAd)
                                            .environmentObject(store)
                                            .environmentObject(interAd)
                                    }, label: {
                                    WebImage(url: URL(string: wallpaper.variations.preview_small.url))
                                        .resizable()
                                        .placeholder {
                                            placeHolderImage()
                                        }
                                        .scaledToFill()
                                        .frame(width: 78, height: 156)
                                        .clipped()
                                        .cornerRadius(8)
                                        .showCrownIfNeeded(wallpaper.content_type == "private" && !store.isPro())
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
    
    @ViewBuilder
    func ShufflePackInHome() -> some View{
        
        VStack(spacing : 16){
            
            HStack(spacing :0){
                Text("Shuffle Packs".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                

                NavigationLink(destination: {
                    
                    EztShufflePackView()
                        .environmentObject(catalogVM)
                        .environmentObject(store)
                        .environmentObject(interAd)
                        .environmentObject(rewardAd)
                    
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
                
                
                
            }.frame(maxWidth: .infinity)
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
                                
                                
                                
                                NavigationLink(destination: {
                                    ShuffleDetailView(wallpaper: shuffle)
                                        .environmentObject(store)
                                        .environmentObject(interAd)
                                        .environmentObject(rewardAd)
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
    
    func WidgetInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Interactive Widget".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
//                NavigationLink(destination: {
//                    WidgetListView()
//                        .environmentObject(interactWidgetViewModel)
//                        .environmentObject(store)
//                        .environmentObject(rewardAd)
//                        .environmentObject(interAd)
//                }, label: {
                
                Button(action: {
                    withAnimation(.linear){
                        currentTab = .WIDGET
                    }
                   
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
                if interactWidgetViewModel.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    let itemShow = min(4, interactWidgetViewModel.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        
                        
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemShow, id: \.self) { count in
                                    let widgetObj = interactWidgetViewModel.widgets[count]
                                    
                                    
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(store)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj, isPro: store.isPro())
                                           
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: 320 / 2.2)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 320 / 2.2)
            .onAppear(perform: {
                if interactWidgetViewModel.widgets.isEmpty{
                    interactWidgetViewModel.getWidgets()
                }
                
            })
            
            
            
            
        }.padding(.top, 24)
    }
    
    
    func DepthEffectViewInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Depth Effect".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
               // Button(action: {
                    
                  //  currentTab = .WALLPAPER
                //    wallpaperTab = .DepthEffect
                 
                
                NavigationLink(destination: {
                    EztDepthEffectView()
                    .environmentObject(catalogVM)
                    .environmentObject(store)
                    .environmentObject(interAd)
                    .environmentObject(rewardAd)
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
                
                
                
                if depthVM.wallpapers.isEmpty{
                    PlaceHolderListLoad()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            NavigationLink(destination: {
                                SpWLDetailView(index: 0)
                                    .environmentObject(depthVM as SpViewModel)
                                    .environmentObject(store)
                                    .environmentObject(rewardAd)
                                    .environmentObject(interAd)
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
                                    .showCrownIfNeeded(depthVM.wallpapers.first?.contentType == 1 && !store.isPro())
                            })
                            
                            
                            LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                                ForEach(1..<15, content: {
                                    i in
                                    let wallpaper = depthVM.wallpapers[i]
                                    NavigationLink(destination: {
                                        SpWLDetailView(index: i)
                                            .environmentObject(depthVM as SpViewModel)
                                            .environmentObject(store)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
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
                                            .showCrownIfNeeded(wallpaper.contentType == 1 && !store.isPro())
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
    
    func PosterContactInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Poster Contact".toLocalize())
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
                    PlaceHolderListLoadHori()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                            LazyHStack(spacing: 12, content: {
                                ForEach(0..<7, content: {
                                    i in
                                    let wallpaper = posterContactVM.wallpapers[i]
                                    
                                    let string = wallpaper.thumbnail?.path.small ?? ""
                                    
                                    NavigationLink(destination: {
                                        SpWLDetailView(index: i)
                                            .environmentObject(posterContactVM as SpViewModel)
                                            .environmentObject(store)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        WebImage(url: URL(string: string))
                                            .resizable()
                                            
//                                            .placeholder {
//                                                placeHolderImage()
//                                            }
                                            .scaledToFill()
                                            .frame(width: 128, height: 280)
                                            .clipped()
                                       
                                            .cornerRadius(8)
                                            .showCrownIfNeeded(wallpaper.contentType == 1 && !store.isPro())
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
    
    //MARK: Lightning Effect
    func LightningEffectInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Lighting Effects".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()

                
                NavigationLink(destination: {
            
                    EztLightingEffectView()
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
                
                
                
                if lightningVM.wallpapers.isEmpty{
                    PlaceHolderListLoadHori()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                            LazyHStack( spacing: 12, content: {
                                ForEach(0..<7, content: {
                                    i in
                                    let wallpaper = lightningVM.wallpapers[i]
                                    let string = wallpaper.path.first?.path.preview  ?? ""
                                    
                                    NavigationLink(destination: {
                                        SpWLDetailView(index: i)
                                            .environmentObject(lightningVM as SpViewModel)
                                            .environmentObject(store)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        WebImage(url: URL(string: string))
                                            .resizable()
//                                            .placeholder {
//                                                placeHolderImage()
//                                            }
                                            .scaledToFill()
                                            .frame(width: 128, height: 280)
                                            .clipped()
                                       
                                            .cornerRadius(8)
                                            .overlay(
                                                Image("dynamic")
                                                    .resizable()
                                                    .cornerRadius(8)
                                            )
                                            .showCrownIfNeeded(wallpaper.contentType == 1 && !store.isPro())
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
 
    //MARK: Watch face
    func WatchFaceViewInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Best Watch Face".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
            
                   EztWatchFaceView()
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
                if watchFaceViewModel.wallpapers.isEmpty{
                  
                }else{
                    let itemshow = min(6, watchFaceViewModel.wallpapers.count)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 12){
                            ForEach(0..<itemshow, id: \.self){
                                i in
                                let  wallpaper = watchFaceViewModel.wallpapers[i]
                                let string : String = wallpaper.path.first?.path.preview ?? ""
                                
                                NavigationLink(destination: {
                                    WatchFaceDetailView(wallpaper: wallpaper)
                                        .environmentObject(store)
                                        .environmentObject(rewardAd)
                                        .environmentObject(interAd)
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
    

    //MARK: Widget Digital
    func WidgetDigital() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Hot Digital Friend".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {

                    ConditionalWidgetView(widgetType: .DigitalFriend)
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
                if digitalFriendWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    
                    let itemCountShow = min(4, digitalFriendWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = digitalFriendWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(store)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj, isPro: store.isPro())
                                           
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: 320 / 2.2)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 320 / 2.2)
            .onAppear(perform: {
                if digitalFriendWidgetVM.widgets.isEmpty{
                    digitalFriendWidgetVM.type = .DigitalFriend
                    digitalFriendWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    //MARK: Widget GIF
    func WidgetGifInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Interesting Gif Widget".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    ConditionalWidgetView(widgetType: .Gif)
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
                if gifWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    
                    let itemCountShow = min(4, gifWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = gifWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(store)
                                            .environmentObject(rewardAd)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj, isPro: store.isPro())
                                          
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: 320 / 2.2)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 320 / 2.2)
            .onAppear(perform: {
                if gifWidgetVM.widgets.isEmpty{
                    gifWidgetVM.type = .Gif
                    gifWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
    //MARK: LiveWallpaper
    func LiveWallpaperInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Live Wallpaper".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()

                
                NavigationLink(destination: {
                    EztLiveWallpaperView()
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
//                                    NavigationLink(destination: {
//                                        LiveWLView(currentIndex : i)
//                                            .navigationBarTitle("", displayMode: .inline)
//                                            .navigationBarHidden(true)
//                                            .environmentObject(liveWlVM)
//                                            .environmentObject(store)
//                                            .environmentObject(rewardAd)
//                                            .environmentObject(interAd)
//                                    }, label: {
//                                        WebImage(url: URL(string: string))
//                                            .resizable()
////                                            .placeholder {
////                                                placeHolderImage()
////                                            }
//                                            .scaledToFill()
//                                            .frame(width: 128, height: 280)
//                                            .clipped()
//                                            .cornerRadius(8)
//                                            .overlay(alignment : .top){
//                                                    HStack{
//                                                        Image("live")
//                                                            .resizable()
//                                                            .frame(width: 16, height: 16 )
//                                                            .padding(8)
//                                                        Spacer()
//                                                       
//                                                    }
//                                            }
//                                            .showCrownIfNeeded(!store.isPro() && wallpaper.contentType == 1)
//                                          
//                                    })
                                    
                                    
                                    
                                    
                                    
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
