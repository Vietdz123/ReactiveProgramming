//
//  HomeView.swift
//  WallpaperIOS
//
//  Created by Mac on 26/04/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import StoreKit

struct HomeView: View {

    @EnvironmentObject var viewModel : HomeViewModel
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var store : MyStore
    @EnvironmentObject var favViewModel : FavoriteViewModel
    @EnvironmentObject var interAd : InterstitialAdLoader
  
    
 
    
    @StateObject var tagViewModel : TagViewModel = .init()
    
    var body: some View {
        
        ZStack{
//            NavigationLink(isActive: $categotyVM.navigateAtHome, destination: {
//                CategoryPageView()
//                    .environmentObject(categoryPageViewModel)
//                    .environmentObject(reward)
//                    .environmentObject(store)
//                    .environmentObject(favViewModel)
//                    .environmentObject(interAd)
                
//            }, label: {
//                EmptyView()
//            })
            
            
            if !viewModel.wallpapers.isEmpty{
                VStack(spacing : 0){
                    Spacer()
                        .frame(height:  44)
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
                                        .indicator(.activity) // Activity Indicator
                                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                        .scaledToFill()
                                    
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                        .cornerRadius(8)
                                        .overlay(
                                            ZStack{
                                                if !store.isPro() && wallpaper.content_type == "private"{
                                                    
                                                    
                                                    Image("coin")
                                                        .resizable()
                                                        .frame(width: 13.33, height: 13.33, alignment: .center)
                                                    
                                                    
                                                        .frame(width: 16, height: 16, alignment: .center)
                                                        .background(
                                                            Capsule()
                                                                .fill(Color.black.opacity(0.7))
                                                        )
                                                        .padding(8)
                                                }
                                            }
                                            
                                            , alignment: .topTrailing
                                        )
                                     
                                    //
                                    
                                })
                                .overlay(
                                    ZStack{
                                        if index == 2 && !store.isPro() && UserDefaults.standard.bool(forKey: "user_exit_app") == false {
                                            if let weekPro = store.weekProduct{
                                                SubInHome(size: size, product : weekPro)
                                                    .cornerRadius(8)
                                            }
                                          
                                            
                                        }
                                    }

                                )
                                
                                .onAppear(perform: {
                                    if viewModel.shouldLoadData(id: index){
                                        viewModel.getWallpapers()
                                        
                                    }
                                })
                                
                            }
                         
                            
                        }, content2: { index in
                            if !viewModel.tags.isEmpty && index < viewModel.tags.count{
                                TagViewBuilder(tag: viewModel.tags[index])
                            }
                           
                            
//                            if categotyVM.current < categotyVM.categorieWithData.count - 1{
//                                if let categoryWithData = categotyVM.categorieWithData[categotyVM.current]  {
//
//
//                                    Categoryyyy(categoryWithData: categoryWithData)
//
//                                }
//                            }
                        }).padding(16)
                        
                        
                        
                        
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                
                
                
            }

            
        }
        .refreshable {
            viewModel.wallpapers.removeAll()
            viewModel.getWallpapers()
        }

    }
    
    @ViewBuilder
    func SubInHome(size : CGSize, product : Product) -> some View{
        VStack(spacing : 0){
            
          
                ResizableLottieView(filename: "premimujson")
           
            
                .frame(width: 85.65, height: 24)
               
                .clipShape(Capsule())
                .padding(.top, 24)
            
            Spacer()
            
            Image("allfeatures")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            
            Text("ONLY \(decimaPriceToStr(price: product.price , chia: 7))\(removeDigits(string: product.displayPrice ))/DAY.")
                .mfont(15, .regular)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 16)
            

            
            HStack(spacing : 0){
                Text("Total \(product.displayPrice)/week ")
                    .mfont(13, .regular)
                    .foregroundColor(.white)
                Text("(\(decimaPriceToStr(price: product.price , chia: 0.5))\(removeDigits(string: product.displayPrice ))/week)")
                    .mfont(13, .regular)
                    .foregroundColor(.white)
                    .overlay(
                        Rectangle()
                            .fill(Color.white.opacity(0.8))
                            .frame(height: 1)

                    )
            }
            
         
                .padding(.top, 4)
            
            
            Button(action: {
                store.isPurchasing = true
                store.purchase(product: product, onBuySuccess: {
                    b in
                       if b {
                           DispatchQueue.main.async{
                               store.isPurchasing = false
                               showToastWithContent(image: "checkmark", color: .green, mess: "Purchase successful!")
                              
                           }
                          
                       }else{
                           DispatchQueue.main.async{
                               store.isPurchasing = false
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
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                
                    .overlay(
                        HStack{
                            
                      
                        
                       
                        
                        Text("Claim Offer!")
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
                    .padding(.horizontal, 33)
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
            .padding(.top, 8)
            .padding(.bottom, 16)
            
        }.frame(width : size.width, height: size.height)
            .background(
                Image("sub_inhome")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
            )
            .onTapGesture {
                
            }
    }
    
    
   
    func TagViewBuilder(tag : Tag) -> some View{
        Button(action: {
            
          
            
        }, label: {
            
        
            
            HStack(spacing : 8){
                VStack(alignment: .leading, spacing : 0){
                    Text("\(tag.title)")
                        .mfont(17, .bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    Text("Awesome category for you!")
                        .mfont(11, .regular)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(width: 120, alignment: .leading)
                        .padding(.top, 4)
                    Spacer()
                    HStack(spacing : 12){
                        Text("Discover")
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
                    WebImage(url: URL(string: tag.preview_small_url ?? ""))
                             
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
