//
//  PromptGenArtStyleView.swift
//  WallpaperIOS
//
//  Created by Duc on 18/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI


struct PromptGenArtView: View {
    @Environment(\.presentationMode) var  presentationMode
    @StateObject var textFieldVM : TextFieldViewModel = .init()
    @StateObject var handlerVM : HandlerViewModel  = .init()
    @State var eztCurrentValue : EztValue?
    @State var navigateToRes : Bool = false
    
    let placeHolderText : String = "Image type, object, any details E.g. Portrait of a Cat in a hat"
    @State var showDialogGenArt : Bool = false
    @State var showDiaglogLoading : Bool = false
    @State var showSubView : Bool = false
    @State var showLimitDialog : Bool = false
    @EnvironmentObject var genArtVM : GenArtMainViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    @State var genArtModelSelected : GenArtModel?
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing : 0){
            Text("Image -> AI Wallpaper")
                .mfont(20, .bold)
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .frame(height: 44)
              .overlay(alignment : .leading){
                  Button(action: {
                      presentationMode.wrappedValue.dismiss()
                  }, label: {
                      Image("back")
                          .resizable()
                          .aspectRatio(contentMode: .fit)
                          .frame(width: 24, height: 24)
                          .frame(width: 56, height: 24)
                  })
              }
            
            ScrollView(.vertical, showsIndicators : false){
                VStack(spacing : 0){
                    
          
            
            Text("Enter Your Prompt")
                .mfont(20, .bold)
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.top, 16)
              .padding(.leading, 16)
            
            ZStack(alignment : .top){
                if let eztCurrentValue, let genArtModelSelected{
                    NavigationLink(
                        destination: ResultPromptGenArtView( promptBefore: textFieldVM.text, eztValueCurrent: eztCurrentValue, eztListValue : [eztCurrentValue], genArtModelSelected : genArtModelSelected)
                            .environmentObject(store)
                            .environmentObject(rewardAd)
                            .environmentObject(interAd)
                        
                        ,
                        isActive: $navigateToRes,
                        label: {
                          EmptyView()
                        })
                }
               
                
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
                            Text(placeHolderText)
                                .font(Font.custom("SVN-Avo", size: 13))
                                .foregroundColor(.white.opacity(0.6))
                               
                        })

                        .fixedSize(horizontal: false, vertical: true)
                            .font(Font.custom("SVN-Avo", size: 13))
                            .submitLabel(SubmitLabel.return)
                            .lineLimit(nil)
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
                .clipped()
                .padding(16)
                
                  
                    
               
            
            }.frame(maxWidth: .infinity)
                .frame(height: 120)
                .padding(.horizontal, 16)
                .padding(.top, 16)
               
             
                
            
            Text("Select Style")
                .mfont(20, .bold)
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.top, 24)
              .padding(.leading, 16)
              .padding(.bottom, 16)
            
            ZStack{
                ScrollView(.horizontal, showsIndicators : false){
                    HStack(spacing : 0){
                        Spacer()
                            .frame(width: 16)
                        LazyHStack(spacing : 16 ,content: {
                            ForEach(genArtVM.genArtModelList.indices, id: \.self) { index in
                                let genArtModel = genArtVM.genArtModelList[index]
                                WebImage(url: URL(string: genArtModel.thumbnails.first?.path.preview ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 144, height: 316)
                                    .clipped()
                                    .overlay(alignment : .bottom){
                                        LinearGradient(colors: [.clear, .clear, .clear, .black], startPoint: .top, endPoint: .bottom)
                                    }
                                    .cornerRadius(12)
                                    .overlay{
                                        if let genArtModelSelected{
                                            if genArtModelSelected.id == genArtModel.id{
                                                RoundedRectangle(cornerRadius: 12)
                                                .stroke(eztGradientHori, lineWidth: 2)
                                            }
                                        }
                                           
                                        
                                          

                                       
                                    }
                               
                                    
                                    .overlay(alignment : .bottom){
                                        Text(genArtModel.name)
                                            .mfont(17, .bold, line: 2)
                                          .multilineTextAlignment(.center)
                                          .foregroundColor(.white)
                                          .padding(.bottom, 12)
                                          .padding(.horizontal, 8)
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                     
                                        self.genArtModelSelected = genArtModel
                                    }
                                  
                            }
                        })
                        
                        
                    }
                }
            }
            .frame(height: 320)
            
            Spacer()
            
            Button(action: {
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
                       if GenArtLimitHelper.canGenArtToday(){
                           showDialogGenArt.toggle()
                       }else{
                           showLimitDialog.toggle()
                       }
                   }
                }
               
            }, label: {
                Text("Generate")
                    .mfont(16, .bold)
                    .foregroundColor(.black)
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(width: 240, height: 48)
                  .background(Capsule()
                    .fill( textFieldVM.text.isEmpty ? Color.gray : Color.main))
            }).padding(.top, 32)
                .disabled(textFieldVM.text.isEmpty)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .edgesIgnoringSafeArea(.bottom)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
           
        }
        .overlay{
            if showDialogGenArt {
                DialogShowGenArt(show: $showDialogGenArt, onClickBuySub: {
                    showSubView.toggle()
                }, onClickWatchAds: {
                    handlerImage()
                    rewardAd.presentRewardedVideo(onCommit: { _ in })
                })
            }
        }
        .addBackground()
        .onAppear(perform: {
            if genArtModelSelected == nil{
                if let genARt = genArtVM.genArtModelList.first{
                    genArtModelSelected = genARt
                }
            }
        })
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
    
    func handlerImage() {
        showDiaglogLoading = true
       
        TokenHelper.genToken(onSuccess: {
            token in
            
            handlerVM.sendPromptDataToServer(token: token, idModel: genArtModelSelected?.id ?? 1 , prompt: textFieldVM.text, onSuccess: {
                idProcess in
                handlerVM.getImageFromServer(token: token, id: idProcess, onSuccess: {
                    eztVl in
                    self.eztCurrentValue = eztVl
                    showDiaglogLoading = false
                    navigateToRes.toggle()
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
    
}


