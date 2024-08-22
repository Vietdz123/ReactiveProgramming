//
//  EztCategoryView.swift
//  WallpaperIOS
//
//  Created by Duc on 17/10/2023.
//

import SwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct EztCategoryView: View {
    
  
    @StateObject var viewModel : CategoryViewModel = .init()
    
    @StateObject var categoryPageViewModel : CategoryPageViewModel = .init()
    @EnvironmentObject var reward : RewardAd
    @State var store : MyStore = .shared
  
    @EnvironmentObject var interAd : InterstitialAdLoader
    var body: some View {
        VStack(spacing : 0){
           
            ScrollView(.vertical, showsIndicators: false){
                //MARK: - Viet
//                NavigationLink(isActive: $viewModel.navigate, destination: {
//                    CategoryPageView()
//                        .environmentObject(categoryPageViewModel)
//                        .environmentObject(reward)
//                        .environmentObject(store)
//                      
//                        .environmentObject(interAd)
//                    
//                }, label: {
//                    EmptyView()
//                })
                
                
             
                
                
                if store.isHasEvent() && !store.isPro(){

                    GeometryReader{
                        proxy in
                        let size = proxy.size
                        ZStack(alignment: .bottomLeading){
                            WebImage(url: URL(string: UserDefaults.standard.string(forKey: "sub_event_banner_image_url") ?? ""))

                                .onSuccess { image, data, cacheType in

                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)


                            if let productEv =  store.getYearSale50UsingProduct() {

                                VStack(spacing : 0){

                                    Text("Just \(productEv.displayPrice)/year")
                                        .mfont(13, .regular)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)


                                    Button(action: {

                                        if store.purchasedIds.isEmpty{
                                            store.isPurchasing = true
                                            showProgressSubView()
                                          
                                                Firebase_log("Click_Buy_Sub_In_Ev_Banner_Year_Sale")
                                         

                                            store.purchase(product: productEv, onBuySuccess: { b in
                                                if b {
                                                    DispatchQueue.main.async{
                                                        store.isPurchasing = false
                                                        hideProgressSubView()
                                                      
                                                            Firebase_log("Buy_Sub_In_Success_Ev_Banner_Year_Sale")
                                                      
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
                                        }

                                    }, label: {
                                        Text("Claim!")
                                            .mfont(17, .bold)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                            .frame(width: 92, height: 32)
                                            .background(
                                                Capsule()
                                                    .fill(Color(red: 1, green: 0.87, blue: 0.19))
                                            )
                                    }).padding(.top, 4)


                                    HStack(spacing : 4){
                                        Button(action: {
                                            if let url = URL(string: "https://docs.google.com/document/d/1EY8f5f5Z_-5QfqAeG2oYdUxlu-1sBc-mgfco2qdRMaU") {
                                                UIApplication.shared.open(url)
                                            }
                                        }, label: {
                                            Text("Privacy Policy")
                                                .underline()
                                                .foregroundColor(.white)
                                                .mfont(8, .regular)

                                        })

                                        Text("|")
                                            .mfont(12, .regular)
                                            .foregroundColor(.white)

                                        Button(action: {

                                            if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                                UIApplication.shared.open(url)
                                            }
                                        }, label: {
                                            Text("Terms of Use")
                                                .underline()
                                                .foregroundColor(.white)
                                                .mfont(8, .regular)

                                        })

                                        Text("|")
                                            .mfont(12, .regular)
                                            .foregroundColor(.white)
                                        Button(action: {
                                            Task{
                                                let b = await store.restore()
                                                if b {
                                                    store.fetchProducts()
                                                    showToastWithContent(image: "checkmark", color: .green, mess: "Restore Successful")
                                                }else{
                                                    showToastWithContent(image: "xmark", color: .red, mess: "Cannot restore purchase")
                                                }
                                            }

                                        }, label: {
                                            Text("Restore")
                                                .underline()
                                                .foregroundColor(.white)
                                                .mfont(8, .regular)

                                        })

                                    }
                                    .padding(.top, 8)


                                }  .padding(.bottom, 8)
                                    .padding(.leading, 16)


                            }



                        }




                    }.frame(width: getRect().width - 32 , height: ( getRect().width - 32 ) * 504 / 1080 )
                        .cornerRadius(8)


               }
                
                LazyVStack(spacing : 0){
                    ForEach(0..<viewModel.categorieWithData.count, id: \.self){
                        stt in
                        let categoryData  = viewModel.categorieWithData[stt]
                        VStack(spacing : 0){
                            HStack(spacing : 0){
                                Text(categoryData.category.title )
                                    .mfont(20, .bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                  
                                    .onAppear(perform: {
                                        if viewModel.checkIfLoadData(i: stt){
                                            viewModel.getCategoryWithData()
                                        }
                                    })
                                Spacer()
                                Button(action: {
                                    
                                    categoryPageViewModel.category = categoryData.category
                                    viewModel.navigate.toggle()
                                }, label: {
                                    HStack(spacing : 0){
                                        Text("See All")
                                            .mfont(11, .regular)
                                            .foregroundColor(.white)
                                        Image("arrow.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 18, height: 18, alignment: .center)
                                    }
                                })
                                
                                
                            }.frame(height: 36)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 8)
                            
                            
                            
                            ZStack{
                                if !categoryData.wallpapers.isEmpty{
                                    ScrollView(.horizontal, showsIndicators: false){
                                        HStack(spacing : 8){
                                            Spacer().frame(width: 8)
                                            ForEach(0..<categoryData.wallpapers.count, id: \.self){
                                                i in
                                                let wallpaper = categoryData.wallpapers[i]
                                                let string : String = wallpaper.variations.preview_small.url.replacingOccurrences(of: "\"", with: "")
                                                
                                                //MARK: - Viet
//                                                NavigationLink(destination: {
//                                                    
//                                                    WallpaperOnePageDetails(wallpapers: categoryData.wallpapers, index : i)
//                                                        .environmentObject(reward)
//                                                        .environmentObject(store)
//                                                        .environmentObject(interAd)
//                                                    
//                                                }, label: {
//                                                    
//                                                    WebImage(url: URL(string: string))
//                                                        .onSuccess { image, data, cacheType in
//                                                            
//                                                        }
//                                                        .resizable()
//                                                        .placeholder {
//                                                            placeHolderImage()
//                                                                .frame(width: 108, height: 216)
//                                                            
//                                                        }
// 
//                                                        .scaledToFill()
//                                                        .frame(width: 108, height: 216)
//                                                        .cornerRadius(8)
//                                                        .clipped()
//                                                        .showCrownIfNeeded(!store.isPro() && wallpaper.content_type == "private")
//
//                                                })
                                                
                                            }
                                            Spacer().frame(width: 16)
                                        }
                                    }
                                }
                                else{
                                    CategoryPlaceHolder()
                                }
                                
                                
                            }.frame(height : 216)
                                .onAppear(perform : {
                                    if categoryData.wallpapers.isEmpty {
                                        viewModel.loadDataWhenAppear(index: stt)
                                    }
                                })
                            
                            
                        }
                        .padding(.bottom, 16)
                        
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                
                Spacer()
                    .frame(height : 112)
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .refreshable {
                viewModel.categorieWithData.removeAll()
                viewModel.getAllCategory()
          //      viewModel.getCategoryWithData()
            }
        }
    }
    
    
}

