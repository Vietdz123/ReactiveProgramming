//
//  DownloadFileView.swift
//  WallpaperIOS
//
//  Created by Mac on 09/05/2023.
//

import SwiftUI

struct DownloadFileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel : FileSaveViewModel
    @State var index : Int
    @State var isHome : Bool = false
    @State var showControll : Bool = true
    @State var showPreview : Bool = false
    
    var body: some View{
        ZStack(alignment: .top){
            TabView(selection: $index, content: {
                ForEach(0..<viewModel.imageDownloadeds.count, id: \.self){ i in
                    let url = viewModel.imageDownloadeds[i]
                    AsyncImage(url: url){
                        phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: getRect().width, height: getRect().height)
                                .clipped()

                        } else if phase.error != nil {
                            Color.red
                        } else {
                            Color.blue
                        }


                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .tag(i)
               
                }
            })
            .background(Color.cyan)
            .tabViewStyle(.page(indexDisplayMode: .never))
           
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation{
                    showControll.toggle()
                }
            }
      
            if showControll{
                VStack(spacing : 0){
                    HStack{
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("back")
                                .resizable()
                                .aspectRatio( contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .contentShape(Rectangle())
                        })
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                
                       
                        
                    }.frame(maxWidth: .infinity)
                        .frame(height: 44)
                        
                      
                    
                    Spacer()
                    Button(action: {
                        withAnimation{
                            showControll = false
                            showPreview = true
                        }
                    }, label: {
                        Image("preview")
                            .resizable()
                            .foregroundColor(.white)
                            .aspectRatio( contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .background(
                                Circle()
                                    .fill(Color.mblack_bg.opacity(0.7))
                                    .frame(width: 48, height: 48)
                            )
                    }) .frame(width: 48, height: 48)
                        .containerShape(Circle())
                        
                }
            }
         
            if showPreview{
                Preview()
            }
           
            
            
            
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
    }
    
    @ViewBuilder
    func Preview() -> some View{
        TabView(selection: $isHome){

            Image("preview_lock")
                .resizable()
                .scaledToFill()
               
                .onTapGesture {
                    withAnimation{
                        showPreview = false
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        withAnimation{
                          showControll = true
                        }
                    })
                }.tag(true)
            
            
            Image("preview_home")
                .resizable()
                .scaledToFill()
                .onTapGesture {
                    withAnimation{
                        showPreview = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        withAnimation{
                          showControll = true
                        }
                    })
                }.tag(false)
            
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background{
            Color.clear
        }
        .ignoresSafeArea()
    }
   
}

