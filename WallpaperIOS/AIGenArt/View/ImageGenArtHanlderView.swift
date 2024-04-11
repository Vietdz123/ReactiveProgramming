//
//  EditFrameSizeView.swift
//  WallpaperIOS
//
//  Created by Duc on 18/12/2023.
//

import SwiftUI

struct ImageGenArtHanlderView: View {
    @Environment(\.presentationMode) var prensentationMode
    
    let genArtModel : GenArtModel
    var uiImage : UIImage
    @State var uiimageCropped : UIImage?
    @StateObject var handlerVM : HandlerViewModel = .init()
    
  
    @State var showDialogGenArt : Bool = false
    @State var showDiaglogLoading : Bool = false
    @State var showLimitDialog : Bool = false
    @State var navigateToResView : Bool = false
    @State var showSubView : Bool = false
    @State var eztValueRes : EztValue?
    
    
    @EnvironmentObject var genArtVM : GenArtMainViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    
    
    @AppStorage("show_lottie_json_firsttime", store: .standard) var showLottieJson : Bool = false
    
    var body: some View {
        VStack(spacing : 0){
            Text("Select the Frame")
                .mfont(20, .bold)
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .overlay(alignment: .leading, content: {
                  Button(action: {
                      prensentationMode.wrappedValue.dismiss()
                  }, label: {
                      Image("back")
                          .resizable()
                          .frame(width: 24, height: 24)
                          .frame(width: 56, height: 44)
                  }).zIndex(1)
              }) .zIndex(100)
            
            Spacer()
            generateView()
           
            Button(action: {
                if store.isPro()
                {
                    handlerImage()
                }else
                {
                    if GenArtLimitHelper.canGenArtToday(){
                        showDialogGenArt.toggle()
                    }else{
                        showLimitDialog.toggle()
                    }
                   
                }
                
         
            }, label: {
                Text("Generate")
                    .mfont(16, .bold)
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(width: 240, height: 48)
                  .background(
                        Capsule()
                            .fill(
                                Color(red: 1, green: 0.87, blue: 0.19)
                            )
                )
            })
            .zIndex(100)
            .padding(.bottom, 48)
            
            if let eztValueRes, let uiimageCropped{
                NavigationLink(
                    destination: ResultImageGenArtView(eztValueCurrent: eztValueRes ,eztListValue: [eztValueRes], uiImageBefore: uiimageCropped, genArtModelSelected: genArtModel)
                        .environmentObject(genArtVM)
                        .environmentObject(store)
                        .environmentObject(rewardAd)
                        .environmentObject(interAd)
                    ,
                    isActive: $navigateToResView,
                    label: {
                        EmptyView()
                    })
                
            }
         
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform: {
                if uiimageCropped == nil{
                    uiimageCropped = uiImage
                }
            })
            .background(
                ZStack{
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .ignoresSafeArea()
                }
              
                
                
            )
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .overlay{
                if showDialogGenArt{
                    DialogShowGenArt(show: $showDialogGenArt, onClickBuySub: {
                        showSubView.toggle()
                    }, onClickWatchAds: {
                        handlerImage()
                        rewardAd.presentRewardedVideo(onCommit: {
                            b in
                           
                        })
                    })
                }
            }
            .overlay{
                if showDiaglogLoading{
                    LoadingGenArtView()
                }
            }
            .overlay{
                if showLimitDialog{
                RemoveLimitView(show: $showLimitDialog, onClickBuySub: {
                    showSubView = true
                })
            }
            }
            .fullScreenCover(isPresented: $showSubView, content: {
                EztSubcriptionView()
            })
    }
    
    func generateView() -> some View{
        GeometryReader{
            proxy in
            let size = proxy.size
            ZStack{
                CropView(image: uiImage, onEdit: {
                    uiimageCroped in
                    self.uiimageCropped = uiimageCroped
                    print("self.uiimageCropped = uiimageCroped")
                }).frame(width: (proxy.size.height - 48) / 2.2 , height: proxy.size.height - 48)
                
                
                if !showLottieJson{
                    VStack(spacing : 0){
                        ResizableLottieView(filename: "zoom")
                            .frame(width: 120, height: 96)
                      
                        Text("Zoom and Move to select the frame you want")
                          .font(
                            Font.custom("SVN-Avo", size: 11)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(.white)
                          .frame(width: 160, alignment: .top)
                         
                    } .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
                        .background(
                            VisualEffectView(effect: UIBlurEffect(style: .dark)).opacity(0.8)
                        )
                        .cornerRadius(12)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showLottieJson = true
                        }
                }
                
                
               
                
                  
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .clipped()
        
    }
}

extension ImageGenArtHanlderView {
    func handlerImage(){
        if let uiimageCropped {
            self.showDiaglogLoading = true
            uiImageToUrlSanbox(uiImage: uiimageCropped , onSuccess: {
                urlSanbox in
                print(urlSanbox.absoluteString)
                
                TokenHelper.genToken(onSuccess: {
                    token in
                    handlerVM.sendImageDataToServer(token: token ,idModel:  genArtModel.id, prompt: nil ,fileURL: urlSanbox, onSuccess: {
                        idProcess in
                        handlerVM.getImageFromServer(token: token, id: idProcess, onSuccess: {
                            eztValue in
                            self.showDiaglogLoading = false
                            print(eztValue.url)
                            self.eztValueRes = eztValue
                            self.navigateToResView.toggle()
                         
                        }, onFailure: {
                            DispatchQueue.main.async {
                                showToastWithContent(image: "xmark", color: .red, mess: GenArtConfig.errorToast)
                                showDiaglogLoading = false
                            }
                        })
                    }, onFailure: {
                        DispatchQueue.main.async {
                            showToastWithContent(image: "xmark", color: .red, mess: GenArtConfig.errorToast)
                            showDiaglogLoading = false
                        }
                    })
                }, onFailure: {
                    DispatchQueue.main.async {
                        showToastWithContent(image: "xmark", color: .red, mess: GenArtConfig.errorToast)
                        showDiaglogLoading = false
                    }
                })
                
               
                
                
            }, onFailure: {
                self.showDiaglogLoading = false
            })
                
        }
    }
   
}
