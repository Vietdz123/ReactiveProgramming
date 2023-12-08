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
    
    @EnvironmentObject var exclusiveVM : ExclusiveViewModel
    @EnvironmentObject var shuffleVM : ShufflePackViewModel
    @EnvironmentObject var depthVM : DepthEffectViewModel
    @EnvironmentObject var dynamicVM : DynamicIslandViewModel
    
    @StateObject var widgetViewModel : WidgetMainViewModel = .init()
    @StateObject var watchFaceViewModel : EztWatchFaceViewModel = .init()
    @StateObject var soundWidgetVM : WidgetMainViewModel = .init()
    
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    
    
    let healthWidgets : [EztWidget] = [
        EztWidget(id: 67 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: []),
        EztWidget(id: 68 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: []),
        EztWidget(id: 69 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: []),
        EztWidget(id: 70 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: []),
        EztWidget(id: 71 , thumbnail: [], sound: [], path: [], category_id: 0, is_trend: 0, is_private: 1, order: 0, delay_animation: 0, active: 1, download: 0, rating: 0, daily_rating: 0, set: 0, cost :0, license: "", updated_at: "", created_at: "", category: CategoryWidget(id: 6, name: "Health"), apps: [], tags: [])

    ]
    
    var body: some View {
        
            ScrollView(.vertical, showsIndicators : false){
              
                  
                    
                LazyVStack(spacing: 0, content: {
                    
                
               
                    
                /*1*/   DepthEffectViewInHome()
                /*2*/   WidgetInHome()
                /*3*/   WatchFaceViewInHome()
                /*4*/   BannerSaleHome()
                /*5*/   TopWallpaper()
                /*6*/   WidgetSound()
                /*7*/   ShufflePackInHome()
                /*8*/   WidgetHEALTH()
                /*9*/   DynamicIslandViewInHome()
                
                    
                   
                   
                  
                    
                    
                    
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
                if let product = store.yearlv2Sale50Product{
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
    
    func TopWallpaper() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Top Wallpapers".toLocalize())
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
                        Text("See more".toLocalize())
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
                    ShufflePackView()
                        .environmentObject(shuffleVM)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                    
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
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
                Text("Interactive Widgets".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(widgetViewModel)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
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
                if widgetViewModel.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    let itemShow = min(4, widgetViewModel.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        
                        
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemShow, id: \.self) { count in
                                    let widgetObj = widgetViewModel.widgets[count]
                                    
                                    
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(store)
                                            .environmentObject(store)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: 160)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .onAppear(perform: {
                if widgetViewModel.widgets.isEmpty{
                    widgetViewModel.getWidgets()
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
                
                NavigationLink(destination: {
                    DepthEffectView()
                        .environmentObject(depthVM)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                    
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
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
    
    func DynamicIslandViewInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Dynamic Island".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                NavigationLink(destination: {
                    DynamicView()
                        .environmentObject(dynamicVM)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                    
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
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
                
                
                
                if dynamicVM.wallpapers.isEmpty{
                    PlaceHolderListLoad()
                }else{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 8){
                            NavigationLink(destination: {
                                SpWLDetailView(index: 0)
                                    .environmentObject(dynamicVM as SpViewModel)
                                    .environmentObject(store)
                                    .environmentObject(rewardAd)
                                    .environmentObject(interAd)
                            }, label: {
                                WebImage(url: URL(string: dynamicVM.wallpapers.first?.path.first?.path.small ?? ""))
                                    .resizable()
                                    .placeholder {
                                        placeHolderImage()
                                    }
                                    .scaledToFill()
                                    .frame(width: 160, height: 320)
                                    .clipped()
                                    .overlay(
                                        Image("dynamic")
                                            .resizable()
                                            .frame(width: 160, height: 320)
                                    )
                                    .cornerRadius(8)
                            })
                            
                            
                            
                            LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                                ForEach(1..<15, content: {
                                    i in
                                    let wallpaper = dynamicVM.wallpapers[i]
                                    
                                    let string = wallpaper.path.first?.path.small ?? ""
                                    
                                    NavigationLink(destination: {
                                        SpWLDetailView(index: i)
                                            .environmentObject(dynamicVM as SpViewModel)
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
                                            .frame(width: 78, height: 156)
                                            .clipped()
                                            .overlay(
                                                Image("dynamic")
                                                    .resizable()
                                                    .frame(width: 78, height: 156)
                                            )
                                            .cornerRadius(8)
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
 
    
    func WatchFaceViewInHome() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Watch Face".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
               // NavigationLink(destination: {
                Button(action: {
                    withAnimation(.linear){
                        currentTab = .WATCHFACE
                    }
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
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
                                        .overlay(alignment: .topTrailing, content: {
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
                                                
                                                
                                            }.padding(.top, 20)
                                                .padding(.trailing , 20)
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
    
    func WidgetHEALTH() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Health Widget".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    HealthWidgetListView(widgetList: healthWidgets)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
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
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing : 0){
                        Spacer().frame(width: 16)
                        LazyHStack(spacing : 16,content: {
                            ForEach(healthWidgets, id: \.id) { widgetObj  in
                                
                                NavigationLink(destination: {
                                    WidgetDetailView(widget: widgetObj)
                                        .environmentObject(store)
                                        .environmentObject(store)
                                        .environmentObject(interAd)
                                }, label: {
                                    Image("\(widgetObj.id)")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 320, height: 320 / 2.2)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.4), lineWidth : 1)
                                        }
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 16)
                                        )

                                })
                                
                                
                            }
                        })
                     }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
           
            
        }.padding(.top, 24)
    }
    
    func WidgetSound() -> some View{
        VStack(spacing : 16){
            HStack(spacing : 0){
                Text("Interesting Sound Widgets".toLocalize())
                    .mfont(20, .bold)
                    .foregroundColor(.white)
                
                
                Spacer()
                
                NavigationLink(destination: {
                    WidgetListView()
                        .environmentObject(soundWidgetVM)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                }, label: {
                    HStack(spacing : 0){
                        Text("See more".toLocalize())
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
                if soundWidgetVM.widgets.isEmpty{
                    ItemWidgetPlaceHolder()
                }else{
                    
                    let itemCountShow = min(4, soundWidgetVM.widgets.count)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 0){
                            Spacer().frame(width: 16)
                            LazyHStack(spacing : 16,content: {
                                ForEach(0..<itemCountShow, id: \.self) { count in
                                    let widgetObj = soundWidgetVM.widgets[count]
                                    NavigationLink(destination: {
                                        WidgetDetailView(widget: widgetObj)
                                            .environmentObject(store)
                                            .environmentObject(store)
                                            .environmentObject(interAd)
                                    }, label: {
                                        ItemWidgetView(widget: widgetObj)
                                    })
                                    
                                    
                                }
                            })
                        }
                        
                        
                        
                    }
                    .frame(height: 160)
                    
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .onAppear(perform: {
                if soundWidgetVM.widgets.isEmpty{
                    soundWidgetVM.type = .Sound
                    soundWidgetVM.getWidgets()
                }
                
            })
            
        }.padding(.top, 24)
    }
    
}
