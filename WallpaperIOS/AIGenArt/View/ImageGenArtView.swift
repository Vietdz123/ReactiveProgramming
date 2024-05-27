//
//  StyleGenImageView.swift
//  WallpaperIOS
//
//  Created by Duc on 18/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageGenArtView: View {
 
    @Environment(\.presentationMode) var  presentationMode
    
    @State var showImagePicker : Bool = false
    @State var uiImagePicker : UIImage?
    @State var navigateToEditFrame : Bool = false
    
    
    @EnvironmentObject var genArtVM : GenArtMainViewModel
    @EnvironmentObject var rewardAd : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    @EnvironmentObject var store : MyStore
    
    @State var genArtModelSelected : GenArtModel?
    @State var adStatus : AdStatus  = .loading
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
                    Text("Add Image")
                        .mfont(20, .bold)
                      .foregroundColor(.white)
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .padding(.top, 16)
                      .padding(.leading, 16)
                    
                    ZStack{
                       
                        
                       RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(.clear)
                        .frame(width: 343, height: 120)
                        .background(.white.opacity(0.1))
                        .cornerRadius(24)
                        .overlay(
                        RoundedRectangle(cornerRadius: 24)
                        .stroke(.white.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4, 6]))

                        )
                        .onTapGesture {
                            showImagePicker.toggle()
                        }
                        
                        if let uiImagePicker , let genArtModelSelected {
                            NavigationLink(
                                destination: ImageGenArtHanlderView(genArtModel: genArtModelSelected, uiImage: uiImagePicker)
                                    .environmentObject(genArtVM)
                                    .environmentObject(store)
                                    .environmentObject(rewardAd)
                                    .environmentObject(interAd)
                                
                                ,
                                isActive: $navigateToEditFrame,
                                label: {
                                   EmptyView()
                                })
                            
                            Image(uiImage: uiImagePicker)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: .infinity)
                                .cornerRadius(4)
                                .overlay(alignment: .topTrailing){
                                    Button(action: {
                                        self.uiImagePicker = nil
                                    }, label: {
                                        Image("close.circle.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }).offset(x : 10, y : -10)
                                   
                                       
                                }
                                .padding(8)
                        }
                        else{
                            VStack(spacing: 12, content: {
                                Image("upload")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                
                                Text("Upload Image")
                                    .mfont(15, .regular)
                                    .foregroundColor(.white.opacity(0.6))
                            }) .onTapGesture {
                                showImagePicker.toggle()
                            }
                            
                        }
                        
                    }.frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .fullScreenCover(isPresented: $showImagePicker, content: {
                            ImagePickerView(showImagePicker: $showImagePicker, onTakePhotoSuccess: {
                                uiimageRes in
                                self.uiImagePicker = uiimageRes
                                
                            })
                        })
                        
                    
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
                                                dismissKeyboard()
                                                self.genArtModelSelected = genArtModel
                                            }
                                          
                                    }
                                })
                                
                                
                            }
                        }
                    }
                    .frame(height: 320)
                    
                   
                 
                    
                   Spacer()
                        .frame(height : 200)
                }
            }
            
       
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .overlay(alignment: .bottom, content: {
            VStack(spacing : 0){
                
            
            
            Button(action: {
                if uiImagePicker != nil{
                    navigateToEditFrame.toggle()
                }
            }, label: {
                Text("Generate")
                    .mfont(16, .bold)
                    .foregroundColor(.black)
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                  .frame(width: 240, height: 48)
                  .background(Capsule()
                    .fill( uiImagePicker == nil ? Color.gray : Color.main))
            }) .disabled(uiImagePicker == nil)
                
                if !store.isPro(){
                    BannerAdViewMain(adStatus: $adStatus)
                        .padding(.top, 16)
                }
                
            }.padding(.top, 16)
                .padding(.bottom, getSafeArea().bottom - 10)
        })
       
        .edgesIgnoringSafeArea(.bottom)
        .addBackground()
        .onAppear(perform: {
            if genArtModelSelected == nil{
                if let genARt = genArtVM.genArtModelList.first{
                    genArtModelSelected = genARt
                }
            }
        })
    }
}

#Preview {
    ImageGenArtView()
}
