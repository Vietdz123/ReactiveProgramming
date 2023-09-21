//
//  OnboardingVerTwoSubView.swift
//  WallpaperIOS
//
//  Created by Duc on 21/09/2023.
//

import SwiftUI
import AVKit
#Preview {
    OnboardingVerTwoSubView()
}


struct OnboardingVerTwoSubView: View {
    @State var currentPage : Int =  1
    
    var body: some View {
        TabView(selection: $currentPage )  {
            Screen_1()
                .tag(1)
            Screen_2()
                .tag(2)
            Screen_3()
                .tag(3)
            Screen_4()
                .tag(4)
            Screen_5()
                .tag(5)
            Screen_6()
                .tag(6)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .background(Color.black)
            .overlay(
                content()
            )
            .overlay(
                ZStack{
                    if currentPage >= 5 {
                        Button(action: {
                            if currentPage == 5 {
                                currentPage = 6
                            }
                        }, label: {
                            Image("close.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }).padding(16)
                    }
                 
                }, alignment: .topTrailing
            )
            
    
    }
}

extension OnboardingVerTwoSubView{
    
    
    func content() -> some View{
        VStack(spacing : 0){
            
            ZStack{
                if currentPage < 5 {
                    
                    VStack(spacing : 0){
                        
                        Text(getTextTitle(page:currentPage))
                        .mfont(32, .bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.main)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 48)
                        
                        Text(getTextSubTitle(page:currentPage))
                        .mfont(24, .regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 48)
                        
                        
                    }.frame(maxWidth: .infinity, maxHeight : .infinity, alignment : .bottom)
                        .padding(.bottom, 24)
                    
                    
                }else if currentPage == 5 {
                    
                }else{
                    
                }
                      
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: {
                withAnimation(.linear){
                    if currentPage < 5 {
                        currentPage += 1
                    }
                   
                }
                
            }, label: {
                HStack{
                    
                  
                    Text("CONTINUE")
                    .mfont(16, .bold)
                    .foregroundColor(.black)
                    
                
                }
                    .frame(maxWidth: .infinity)
                    .frame(height : 56)
                    .contentShape(Rectangle())
                    .overlay(
                        ZStack{
                            ResizableLottieView(filename: "arrow")
                                .frame(width: 32, height: 32 )
                                .padding(.trailing , 24)
                        }
                        
                        
                        , alignment: .trailing
                    )
            })
            .background(
                Capsule().fill(Color.main)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 64)
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .background(
                VStack(spacing : 0){
                    Spacer()
                    LinearGradient(colors: [Color("black_bg").opacity(0), Color("black_bg")], startPoint: .top, endPoint: .bottom)
                        .frame(height : 120)
                    Color("black_bg")
                        .frame(height : 180)
                }.ignoresSafeArea()
            )
            .overlay(
                ZStack{
                    if currentPage == 5 || currentPage == 6 {
                        HStack(spacing : 4){
                            Button(action: {
                                if let url = URL(string: "https://docs.google.com/document/d/1SmR-gcwA_QaOTCEOTRcSacZGkPPbxZQO1Ze_1nVro_M") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("Privacy Policy").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            })
                            
                            Text("|").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            
                            Button(action: {
//                                Task{
//                                    let b = await store.restore()
//                                    if b {
//                                        showToastWithContent(image: "checkmark", color: .green, mess: "Restore Successful")
//                                    }else{
//                                        showToastWithContent(image: "xmark", color: .red, mess: "Cannot restore purchase")
//                                    }
//                                }
                                
                            }, label: {
                                Text("Restore").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            })
                            
                            Text("|").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            
                            Button(action: {
                                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("Term of use").mfont(10, .regular).foregroundColor(.white.opacity(0.7))
                            })
                            
                          
                            
                        }.edgesIgnoringSafeArea(.bottom)
                    }
                }
                    
                   
                    
               
                , alignment: .bottom
            )
    }
    
    
    
    func getTextTitle(page : Int) -> String{
        if page == 1 {
            return "100000+"
        }else if page == 2 {
            return "Live Wallpapers"
        }else if page == 3 {
            return "Depth Effect"
        }else if page == 4 {
            return "Shuffle Packs"
        }else{
            return ""
        }
    }
    
    func getTextSubTitle(page : Int) -> String{
        if page == 1 {
            return "4K Wallpapers"
        }else if page == 2 {
            return "Vivid every detail"
        }else if page == 3 {
            return "Amazing 3D effects"
        }else if page == 4 {
            return "Automatically change exciting wallpapers"
        }else{
            return ""
        }
    }
    
  
    
    func Screen_1() -> some View{
        VideoOnboarding(video_name: "video1")
    }
    
    func Screen_2() -> some View{
        VideoOnboarding(video_name: "video2")
    }
    func Screen_3() -> some View{
        VideoOnboarding(video_name: "video3")
    }
    func Screen_4() -> some View{
        VideoOnboarding(video_name: "video1")
    }
    
    func Screen_5() -> some View{
        VideoOnboarding(video_name: "video4")
    }
    
    func Screen_6() -> some View{
        Image("bg_sc6")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .clipped()
            .gesture(DragGesture())
    }
    
}

struct VideoOnboarding : View{
    @State var avPlayer : AVPlayer?
    let video_name : String
    var body: some View{
        ZStack{
            if  avPlayer != nil{
                MyVideoPlayer(player: avPlayer!)
                    .ignoresSafeArea()
                    .gesture(DragGesture())
            }
        }
        
        .onAppear(perform: {
            avPlayer = AVPlayer(url:  Bundle.main.url(forResource: video_name, withExtension: "mp4")!)
            avPlayer!.play()
        })
        .onDisappear(perform: {
            if avPlayer != nil{
                avPlayer!.pause()
            }
            avPlayer = nil
        })
        
        
    }
}
