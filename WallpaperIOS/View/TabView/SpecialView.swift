//
//  SpecialView.swift
//  WallpaperIOS
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct SpecialView: View {
    
    
    
   @EnvironmentObject var shuffleVM : ShufflePackViewModel
    @EnvironmentObject var dynamicVM : DynamicIslandViewModel
    @EnvironmentObject var depthEffectVM : DepthEffectViewModel
    
    

    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
    
   @AppStorage("shuffle_tuto", store: .standard) var notShuffleTutoFirstTime : Bool = false
    
    @State var avPlayer : AVPlayer?
    @State var avPlayerVideoSub : AVPlayer?
   
    
    var body: some View {
        VStack(spacing : 0){
            
            Spacer()
                .frame(height: 44)
            
            ScrollView(.vertical, showsIndicators: false){
                ShufflePack()
                DepthEffect()
                DynamicIsland()
                PromotionView()
                
               
                
                Spacer().frame(height: 250)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .refreshable {
                    shuffleVM.wallpapers.removeAll()
                    depthEffectVM.wallpapers.removeAll()
                    dynamicVM.wallpapers.removeAll()
                    shuffleVM.currentOffset = 0
                    depthEffectVM.currentOffset = 0
                    dynamicVM.currentOffset = 0
                    shuffleVM.getWallpapers()
                    depthEffectVM.getWallpapers()
                    dynamicVM.getWallpapers()
                }

            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .addBackground()
        
    }
  
    
   
    
}

extension SpecialView{
    @ViewBuilder
    func PromotionView() -> some View{
        ZStack(alignment: .bottom){
            if avPlayerVideoSub != nil{
                MyVideoPlayer(player: avPlayerVideoSub!)
                   
                
            }
            
            GeometryReader{
                proxy in
                let size = proxy.size
                VStack(spacing : 0){
                                        LinearGradient(colors: [Color("black_bg").opacity(0.0), Color("black_bg").opacity(0.9)], startPoint: .top, endPoint: .bottom)
                                        Rectangle()
                                            .fill(Color("black_bg").opacity(0.9))
                                            .frame(height : 64)
                                    }.frame(width : size.width, height: size.height)
            }

            
            
            
              
            
            if let product = store.isVer1() ? store.weekProduct : store.yearlyNoFreeTrialProduct {
                VStack(spacing : 0){
                    Text("Give your Phone")
                        .mfont(17, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                    Text("A Cool Makeover")
                        .mfont(17, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .padding(.top, 2)
                    
                    Text("Only \(product.displayPrice) per \(store.isVer1() ? "week" : "year").")
                        .mfont(13, .regular)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .padding(.top, 8)
                    
                    if !store.isVer1(){
                        Text("( Lest than \(decimaPriceToStr(price: product.price , chia: 365))\(removeDigits(string: product.displayPrice ))/day! )")
                            .mfont(13, .regular)
                            .padding(.top, 4)
                    }
                    
                    Text("Auto-renewable. Cancel anytime.")
                        .mfont(13, .regular)
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .padding(.top, 2)
                    
                    
                    Button(action: {
                        store.isPurchasing =  true
                        showProgressSubView()
                        store.purchase(product: product, onBuySuccess: {
                            b in
                               if b {
                                   DispatchQueue.main.async{
                                       store.isPurchasing = false
                                       hideProgressSubView()
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
                        Capsule()
                            .fill(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.15, green: 0.34, blue: 1), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.93, green: 0.42, blue: 1), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0, y: 1),
                                    endPoint: UnitPoint(x: 1, y: 0)
                                )
                            )
                          
                            .frame( width : 160,height: 44)
                        
                            .overlay(
                                HStack{
                                    
                                    Text("Let's Start")
                                        .mfont(17, .bold)
                                    
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .overlay(
                                            ZStack{
                                                if store.isPurchasing{
                                                    ResizableLottieView(filename: "progress_white")
                                                        .frame(width: 24, height: 24)
                                                   
                                                }
                                            }.offset(x : -24)
                                            , alignment: .leading
                                        )
                                }
                                
                               
                            )
                            
                    }).disabled(store.isPurchasing)
                    .padding(.top, 16)
                    
               
                    HStack(spacing : 4){
                        Spacer()
                        
                        Button(action: {
                            
                            
                            if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
                                UIApplication.shared.open(url)
                            }
                            
                        }, label: {
                            Text("Privacy Policy")
                                .underline()
                                .foregroundColor(.white)
                                .mfont(10, .regular)
                            
                        })
                        
                        Text("|")
                            .mfont(10, .regular)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            
                            if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                UIApplication.shared.open(url)
                            }
                        }, label: {
                            Text("Terms of Use")
                                .underline()
                                .foregroundColor(.white)
                                .mfont(10, .regular)
                            
                        })
                     
                        Text("|")
                            .mfont(10, .regular)
                            .foregroundColor(.white)
                        Button(action: {
                            Task{
                                let b = await store.restore()
                                if b {
                                    showToastWithContent(image: "checkmark", color: .green, mess: "Restore Successful")
                                }else{
                                    showToastWithContent(image: "xmark", color: .red, mess: "Cannot restore purchase")
                                }
                            }
                            
                        }, label: {
                            Text("Restore")
                                .underline()
                                .foregroundColor(.white)
                                .mfont(10, .regular)
                            
                        })
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                    
                }
            }
        
        }
        .frame(width: getRect().width - 32, height: ( getRect().width - 32) * 343 / 320 )
        .cornerRadius(8)
        .padding(.top, 16)
        .onAppear(perform: {
            avPlayerVideoSub = AVPlayer(url:  Bundle.main.url(forResource: "video_sub_speacial", withExtension: "mp4")!)
            if avPlayerVideoSub != nil{
                avPlayerVideoSub!.play()
                avPlayerVideoSub!.isMuted = true
            }
          
        })
        .onDisappear(perform: {
            if avPlayerVideoSub != nil{
                avPlayerVideoSub!.isMuted = true
                avPlayerVideoSub!.pause()
                avPlayerVideoSub = nil
            }
        })
        
    }
    
    @ViewBuilder
    func ShufflePack() -> some View{
        HStack(spacing :0){
            Text("Shuffle Packs")
                .mfont(17, .bold)
                .foregroundColor(.white)
            
            Spacer()
            
          
            
            NavigationLink(destination: {
                ShufflePackView()
                    .environmentObject(shuffleVM)
                    .environmentObject(store)
                    .environmentObject(interAd)
                    .environmentObject(reward)
            }, label: {
                Text("See more")
                    .mfont(11, .regular)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                
                Image("arrow.right")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .frame(width: 24, height: 24)
            })
            
          
            
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
        
        if shuffleVM.wallpapers.count >= 9 {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing : 16) {
                  
                    if !notShuffleTutoFirstTime{
                        NavigationLink(destination: {
                            ShuffleTutoView()
                        }, label: {
                            ZStack{
                                if avPlayer != nil{
                                    MyVideoPlayer(player: avPlayer!)
                                        .frame(width: 160, height: 240)
                                    
                                }
                                
                            }.frame(width: 140, height: 240)
                                .onAppear(perform: {
                                    avPlayer = AVPlayer(url:  Bundle.main.url(forResource: "preview_shuffle", withExtension: "mp4")!)
                                    if avPlayer != nil{
                                        avPlayer!.play()
                                        avPlayer!.isMuted = true
                                    }
                                  
                                })
                                .onDisappear(perform: {
                                    if avPlayer != nil{
                                        avPlayer!.isMuted = true
                                        avPlayer!.pause()
                                        avPlayer = nil
                                    }
                                })
                          
                    

                        }).cornerRadius(8)
                    }

                    
                    ForEach(0..<9, id: \.self) {
                        i in
                        let shuffle = shuffleVM.wallpapers[i]
                        let img1 = shuffle.path[0].path.small
                        let img2 = shuffle.path[1].path.extraSmall
                        let img3 = shuffle.path[2].path.extraSmall
                        
                        
                        NavigationLink(destination: {
                            ShuffleDetailView(wallpaper: shuffle)
                                .environmentObject(store)
                                .environmentObject(interAd)
                               
                                .environmentObject(reward)
                        }, label: {
                            ZStack(alignment: .trailing){
                                WebImage(url: URL(string: img3))
                                
                                   .onSuccess { image, data, cacheType in
                                   
                                   }
                                   .resizable()
                                   .placeholder {
                                       placeHolderImage()
                                           .frame(width: 100, height: 200)
                                   }
                                   .indicator(.activity) // Activity Indicator
                                   .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                   .scaledToFill()
                                    .frame(width: 100, height: 200)
                                    .cornerRadius(8)
                                    
                                WebImage(url: URL(string: img2))
                                
                                   .onSuccess { image, data, cacheType in
                                   
                                   }
                                   .resizable()
                                   .placeholder {
                                       placeHolderImage()
                                           .frame(width: 110, height: 220)
                                   }
                                   .indicator(.activity) // Activity Indicator
                                   .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                   .scaledToFill()
                                    .frame(width: 110, height: 220)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                                
                                    .padding(.trailing, 12)
                                   
                                
                                WebImage(url: URL(string: img1))
                                
                                   .onSuccess { image, data, cacheType in
                                   
                                   }
                                   .resizable()
                                   .placeholder {
                                       placeHolderImage()
                                           .frame(width: 120, height: 240)
                                   }
                                   .indicator(.activity) // Activity Indicator
                                   .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                   .scaledToFill()
                                    .frame(width: 120, height: 240)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 2)
                                    .overlay(
                                        
                                        ZStack{
                                            if !store.isPro(){
                                                Image("crown")
                                                    .resizable()
                                                    .frame(width: 16, height: 16, alignment: .center)
                                                    .padding(8)
                                            }
                                        }
                                        
                                        , alignment: .topTrailing
                                        
                                    )
                                    .padding(.trailing, 24)
                           
                            }.frame(width: 160, height: 240)
                        })

                    }
  
                }
                
                
            }.padding(.horizontal, 16)
        }
        
        
        
    }
    
    
    @ViewBuilder
    func DepthEffect() -> some View{
        HStack(spacing :0){
            Text("Depth Effect")
                .mfont(17, .bold)
                .foregroundColor(.white)
            
            Spacer()
            
            NavigationLink(destination: {
                DepthEffectView()
                    .environmentObject(depthEffectVM)
                    .environmentObject(store)
                    .environmentObject(interAd)
                    .environmentObject(favViewModel)
                    .environmentObject(reward)
            }, label: {
                Text("See more")
                    .mfont(11, .regular)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                
                Image("arrow.right")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .frame(width: 24, height: 24)
            })
            
          
            
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
        
        if depthEffectVM.wallpapers.count >= 9{
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing : 8){
                    
                    NavigationLink(destination: {
                        SpWLDetailView(index: 0)
                            .environmentObject(depthEffectVM as SpViewModel)
                            .environmentObject(store)
                            .environmentObject(interAd)
                            .environmentObject(favViewModel)
                            .environmentObject(reward)
                            
                    }, label: {
                        WebImage(url: URL(string: depthEffectVM.wallpapers.first?.thumbnail?.path.small ?? ""))
                           .onSuccess { image, data, cacheType in
                           
                           }
                           .resizable()
                           .placeholder {
                               placeHolderImage()
                                   .frame(width: 160, height: 320)
                           }
                           .indicator(.activity) // Activity Indicator
                           .transition(.fade(duration: 0.5)) // Fade Transition with duration
                           .scaledToFill()
                            .frame(width: 160, height: 320)
                            .cornerRadius(8)
                            .overlay(
                              
                                
                                ZStack{
                                    if !store.isPro(){
                                        Image("crown")
                                            .resizable()
                                            .frame(width: 16, height: 16, alignment: .center)
                                            .padding(8)
                                    }
                                }
                               
                                , alignment: .topTrailing
                            )
                    })
                    
                    
                   
             
                    LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                        ForEach(1..<9, content: {
                            i in
                            
                            let string = depthEffectVM.wallpapers[i].thumbnail?.path.small ?? ""
                            
                            NavigationLink(destination: {
                                SpWLDetailView(index: i)
                                    .environmentObject(depthEffectVM as SpViewModel)
                                    .environmentObject(store)
                                    .environmentObject(interAd)
                                    .environmentObject(favViewModel)
                                    .environmentObject(reward)
                            }, label: {
                                
                                WebImage(url: URL(string: string))
                                   .onSuccess { image, data, cacheType in
                                   
                                   }
                                   .resizable()
                                   .placeholder {
                                       placeHolderImage()
                                           .frame(width: 78, height: 156)
                                   }
                                   .indicator(.activity) // Activity Indicator
                                   .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                   .scaledToFill()
                                   .frame(width: 78, height: 156)
                                   .cornerRadius(8)
                                   .overlay(
                                     
                                    
                                    ZStack{
                                        if !store.isPro(){
                                            Image("crown")
                                                .resizable()
                                                .frame(width: 16, height: 16, alignment: .center)
                                                .padding(8)
                                        }
                                    }
                                      
                                       , alignment: .topTrailing
                                   )
                            })
                        })
                    })
                }
               
                
            }
            .frame(height: 320)
            .padding(.horizontal, 16)
        }
        
    }
    
    @ViewBuilder
    func DynamicIsland() -> some View{
        HStack(spacing :0){
            Text("Dynamic Island")
                .mfont(17, .bold)
                .foregroundColor(.white)
            
            Spacer()
            
            NavigationLink(destination: {
                DynamicView()
                    .environmentObject(dynamicVM )
                    .environmentObject(store)
                    .environmentObject(interAd)
                    .environmentObject(favViewModel)
                    .environmentObject(reward)
                
            }, label: {
                Text("See more")
                    .mfont(11, .regular)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                
                Image("arrow.right")
                    .resizable()
                    .aspectRatio( contentMode: .fit)
                    .frame(width: 24, height: 24)
            })
            
           
            
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
        
        
        if dynamicVM.wallpapers.count >= 9{
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing : 8){
                    
                    NavigationLink(destination: {
                        SpWLDetailView(index: 0)
                            .environmentObject(dynamicVM as SpViewModel)
                            .environmentObject(store)
                            .environmentObject(interAd)
                            .environmentObject(favViewModel)
                            .environmentObject(reward)
                    }, label: {
                        WebImage(url: URL(string: dynamicVM.wallpapers.first?.path.first?.path.small ?? ""))
                        
                           .onSuccess { image, data, cacheType in
                           
                           }
                           .resizable()
                           .placeholder {
                               placeHolderImage()
                                   .frame(width: 160, height: 320)
                           }
                           .indicator(.activity) // Activity Indicator
                           .transition(.fade(duration: 0.5)) // Fade Transition with duration
                           .scaledToFill()
                            .frame(width: 160, height: 320)
                            .cornerRadius(8)
                            .overlay(
                                Image("dynamic")
                                    .resizable()
                                    .frame(width: 160, height: 320)
                                    .cornerRadius(8)
                            )
                            .overlay(
                                
                                ZStack{
                                    if !store.isPro(){
                                        Image("crown")
                                            .resizable()
                                            .frame(width: 16, height: 16, alignment: .center)
                                            .padding(8)
                                    }
                                }
                               
                                , alignment: .topTrailing
                            )
                        
                        
                          
                    })
                    
               
             
                    LazyHGrid(rows: [GridItem.init(spacing : 8), GridItem.init()], spacing: 8, content: {
                        ForEach(1..<9, content: {
                            i in
                            
                            let string = dynamicVM.wallpapers[i].path.first?.path.extraSmall ?? ""
                            
                            NavigationLink(destination: {
                                SpWLDetailView(index: i)
                                    .environmentObject(dynamicVM as SpViewModel)
                                    .environmentObject(store)
                                    .environmentObject(interAd)
                                    .environmentObject(favViewModel)
                            }, label: {
                                WebImage(url: URL(string: string))
                                   .onSuccess { image, data, cacheType in
                                   
                                   }
                                   .resizable()
                                   .placeholder {
                                       placeHolderImage()
                                           .frame(width: 78, height: 156)
                                   }
                                   .indicator(.activity) // Activity Indicator
                                   .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                   .scaledToFill()
                                   .frame(width: 78, height: 156)
                                   .cornerRadius(8)
                                   .overlay(
                                       Image("dynamic")
                                           .resizable()
                                           .frame(width: 78, height: 156)
                                           .cornerRadius(8)
                                   )
                                   .overlay(
                                    
                                    ZStack{
                                        if !store.isPro(){
                                            Image("crown")
                                                .resizable()
                                                .frame(width: 16, height: 16, alignment: .center)
                                                .padding(8)
                                        }
                                    }
                                      
                                       , alignment: .topTrailing
                                   )
                            })
                            
                            
                            
                          
                               
                        })
                    })
                }
               
                
            }
            .frame(height: 320)
            .padding(.horizontal, 16)
        }
        
       
        
    }
}
