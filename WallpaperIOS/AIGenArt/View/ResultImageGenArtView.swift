//
//  ResultStyleGenImageView.swift
//  WallpaperIOS
//
//  Created by Duc on 19/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ResultImageGenArtView: View {
    @Environment(\.presentationMode) var prensentationMode
    
    @State var eztValueCurrent : EztValue
    @State var eztListValue : [EztValue]
    
    let uiImageBefore : UIImage
    let genArtModelSelected : GenArtModel
    
    
    @State var allowGenMore : Bool = true
    @State var showDialogLimit : Bool = false
    @State var showSubView : Bool = false
    @State var showDialogGenArt : Bool = false
    @State var isDownloading : Bool = false
    
    
    @EnvironmentObject var genArtVM : GenArtMainViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    
    @State var showDiaglogLoading : Bool = false
    @StateObject var handlerVM : HandlerViewModel = .init()
    @StateObject var textFieldVM : TextFieldViewModel = .init()
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(spacing : 0){
            Text("AI Wallpaper")
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
                    })
                })
                .overlay(alignment: .trailing, content: {
                    Button(action: {
                        shareLinkApp()
                    }, label: {
                        Image("share2")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .frame(width: 56, height: 44)
                    })
                })
                .padding(.bottom, 16)
            
            ScrollView(.vertical, showsIndicators : false ){
                VStack(spacing : 0){
                    
         
            
            
            ZStack{
                WebImage(url: URL(string: eztValueCurrent.url))
                    .resizable()
                    .placeholder {
                        placeHolderImage()
                    }
                    .scaledToFit()
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(eztGradientHori, lineWidth : 3)
                    )
                  
            }.frame(width: getRect().width - 48, height: getRect().width - 48)
                        .clipped()
                     
            
            
            Text("Result")
                .mfont(20, .bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .padding(.top, 24)
            
            ScrollView(.horizontal, showsIndicators : false){
                HStack(spacing : 0){
                    ForEach(eztListValue, id : \.url){
                        value in
                        WebImage(url: URL(string: value.url))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(16)
                            .overlay{
                                if value.url == eztValueCurrent.url{
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(eztGradientHori, lineWidth : 2)
                                }
                            }
                            .onTapGesture {
                                self.eztValueCurrent = value
                                textFieldVM.text = eztValueCurrent.prompt ?? ""
                            }
                            .padding(.leading, 16)
                    }
                }
            }.frame(maxWidth: .infinity)
                .frame(height: 84)
                .padding(.top, 8)
            
                    Text("Prompt")
                        .mfont(20, .bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.top, 24)
                    
            ZStack(alignment : .top){

                
               RoundedRectangle(cornerRadius: 24)
                .foregroundColor(.clear)
              
                .background(.white.opacity(0.1))
                .cornerRadius(24)
                .overlay(
                RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4, 6]))
                )
                
                VStack{
                    TextField(text: $textFieldVM.text, axis: .vertical, label: {
                
                        
                    }).font(Font.custom("SVN-Avo", size: 13))
                        .lineLimit(10)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .focused($isFocused)
                        .toolbar {
                                       ToolbarItemGroup(placement: .keyboard) {
                                           HStack{
                                               Button("Cancel") {
                                                  isFocused = false
                                               }
                                               Spacer()
                                               Button("Done") {
                                                  isFocused = false
                                               }
                                           }
                                          
                                       }
                                   }
                }
                .frame(maxWidth: .infinity, maxHeight : .infinity, alignment : .topLeading)
                .padding(12)
                .ignoresSafeArea(.keyboard, edges : .bottom)
                
                  
                    
               
            
            }.frame(maxWidth: .infinity)
                        .frame(height: 80)
                .padding(16)
                    
                    
                    HStack(spacing : 16){
                        Button(action: {
                         isFocused = false
                            if !textFieldVM.text.isEmpty{
                                if GenArtConfig.checkKeyWord(text: textFieldVM.text) {
                                    DispatchQueue.main.async {
                                        showToastWithContent(image: "xmark", color: .red, mess: "Prompt not allowed!")
                                        showDiaglogLoading = false
                                    }
                                    return
                                }
                                
                                if store.isPro(){
                                    handlerImage()
                                }else{
                                    if !allowGenMore{
                                        showDialogLimit.toggle()
                                    }else{
                                    
                                            handlerImage()
                                     
                                    }
                                    
                                  
                                }
                                
                                
                            }
                         
                        }, label: {
                            Text("Generate More")
                                .mfont(15, .bold)
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                              .frame(maxWidth: .infinity, maxHeight : .infinity)
                              .background(
                                Capsule().fill(Color.white)
                              )
                              .overlay(alignment : .topTrailing ){
                                  if allowGenMore && !store.isPro(){
                                      Text("1")
                                      .font(
                                      Font.custom("SVN-Avo", size: 11)
                                      .weight(.bold)
                                      )
                                      .multilineTextAlignment(.center)
                                      .foregroundColor(.white)
                                      .frame(width: 16, height: 16, alignment: .center)
                                      .background(
                                        Circle()
                                            .fill(
                                                eztGradientHori
                                            )
                                      )
                                  }
                               
                              }
                        })
                        
                        Button(action: {
                           
                            downloadImageToGallery(title: UUID().uuidString, urlStr: eztValueCurrent.url)
                        }, label: {
                            HStack{
                                Text("Save")
                                    .mfont(15, .bold)
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                  .overlay(alignment: .trailing, content: {
                                      if isDownloading{
                                          ProgressView()
                                              .frame(width: 20, height: 20, alignment: .center)
                                              .offset(x : -42)
                                      }
                                   
                                  })
                            }
                           
                              .frame(maxWidth: .infinity, maxHeight : .infinity)
                              .background(
                                Capsule().fill(isDownloading ? Color.gray :  Color.white)
                              )
                        }).disabled(isDownloading)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .padding(.bottom , 16)
                    
                }
            }.keyboardAware()
            
           
            
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .topLeading)
            .edgesIgnoringSafeArea(.bottom)
            .addBackground()
          
            .onTapGesture {
                isFocused = false
              
            }
          
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
                if showDialogLimit {
                    RemoveLimitView(show: $showDialogLimit, onClickBuySub: {
                        showSubView.toggle()
                    })
                }
            }
            .fullScreenCover(isPresented: $showSubView, content: {
                EztSubcriptionView()
                    .environmentObject(store)
            })
            .onAppear(perform: {
               if textFieldVM.text.isEmpty{
                   textFieldVM.text = eztValueCurrent.prompt ?? ""
                }
            })
    }
    
    func handlerImage(){
       
            self.showDiaglogLoading = true
            uiImageToUrlSanbox(uiImage: uiImageBefore , onSuccess: {
                urlSanbox in
                print(urlSanbox.absoluteString)
                
                TokenHelper.genToken(onSuccess: {
                    token in
                    handlerVM.sendImageDataToServer(token: token ,idModel:  genArtModelSelected.id, prompt: textFieldVM.text ,fileURL: urlSanbox, onSuccess: {
                        idProcess in
                        handlerVM.getImageFromServer(genFree : true ,token: token, id: idProcess, onSuccess: {
                            eztValue in
                            allowGenMore = false
                            self.showDiaglogLoading = false
                            print(eztValue.url)
                            eztListValue.append(eztValue)
                            if let eztValueLast = eztListValue.last{
                                eztValueCurrent = eztValueLast
                                textFieldVM.text = eztValueCurrent.prompt ?? ""
                            }
                          
                         
                         
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
                DispatchQueue.main.async {
                    showToastWithContent(image: "xmark", color: .red, mess: GenArtConfig.errorToast)
                    showDiaglogLoading = false
                }
            })
                
       
    }
    
    func downloadImageToGallery(title : String, urlStr : String){
        
        DispatchQueue.main.async {
            isDownloading = true
        }
        
        DownloadFileHelper.downloadFromUrlToSanbox(fileName: title, urlImage: URL(string: urlStr), onCompleted: {
            url in
            if let url{
                DownloadFileHelper.saveImageToLibFromURLSanbox(url: url, onComplete: {
                    success in
                    if success{
                        isDownloading = false

                        DispatchQueue.main.async {
                            showToastWithContent(image: "checkmark", color: .green, mess: "Saved to gallery!")
                        }

                    }else{
                        isDownloading = false
                        showToastWithContent(image: "xmark", color: .red, mess: "Download Failure")
                    }
                })
            }else{
                isDownloading = false
                showToastWithContent(image: "xmark", color: .red, mess: "Download Failure")
            }
        })
        
        
        
    }
}


