//
//  SlideMenuView.swift
//  WallpaperIOS
//
//  Created by Mac on 27/04/2023.
//

import SwiftUI

struct SlideMenuView: View {

    let appId = "6449699978"
    
    @Binding var showMenu : Bool
    @State var runAnim : Bool = false
    @EnvironmentObject var store : MyStore
   
    @EnvironmentObject var reward : RewardAd
    @EnvironmentObject var interAd : InterstitialAdLoader
    
    var body: some View {
        ZStack{
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            
            HStack(spacing : 0){
                VStack(spacing : 0){
                    
                    
                    HStack(spacing : 0){
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .padding(16)
                        
                        Text(AppConfig.APP_NAME)
                            .mfont(20, .bold)
                            .foregroundColor(.main)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)){
                                    runAnim.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                    self.showMenu = false
                                })
                            }
                    }.frame(maxWidth: .infinity)
                        .frame(height: 80)
                    
                    Divider().background(.white.opacity(0.1))
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(spacing : 0){
                            if !store.isPro(){
                                NavigationLink(destination: {
                                    EztSubcriptionView()
                                        .environmentObject(store)
                                        .navigationBarTitle("", displayMode: .inline)
                                        .navigationBarHidden(true)
                                }, label: {
                                    HStack{
                                        ResizableLottieView(filename: "star")
                                            .frame(width: 24, height: 24)
                                            .padding(16)
                                        
                                        Text("Unlock all Features")
                                            .mfont(17, .bold, line : 1)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image("off")
                                            .resizable()
                                            .frame(width: 44, height: 24)
                                            .padding(.trailing, 20)
                                        
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                        .frame(height: 56)
                                })
                                
                                NavigationLink(destination: {
                                    EztSubcriptionView()
                                        .environmentObject(store)
                                        .navigationBarTitle("", displayMode: .inline)
                                        .navigationBarHidden(true)
                                }, label: {
                                    HStack{
                                        Image("removeads")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .padding(16)
                                        
                                        Text("Remove Ads")
                                            .mfont(17, .bold)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image("off")
                                            .resizable()
                                            .frame(width: 44, height: 24)
                                            .padding(.trailing, 20)
                                        
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                        .frame(height: 56)
                                })
                                
                            }

                            Divider().background(.white.opacity(0.1))
                            

                            
                         Button(action: {
                              shareLinkApp()
                            }, label: {
                                HStack{
                                    Image("slide_share")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(16)
                                    
                                    Text("Share Wallive")
                                        .mfont(17, .regular)
                                        .foregroundColor(.white)
                                    
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 56)
                                
                            })
                            
                            
                            Button(action: {
                                
                                
                              rateApp()
                            }, label: {
                                HStack{
                                    Image("slide_star")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(16)
                                    
                                    Text("Rating Wallive")
                                        .mfont(17, .regular)
                                        .foregroundColor(.white)
                                    
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 56)
                                
                            })
                            
                            NavigationLink(destination: {
                                TutorialContentView()
                                    .navigationBarTitle("", displayMode: .inline)
                                    .navigationBarHidden(true)
                            }, label: {
                                HStack{
                                    Image("slide_tutorial")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(16)
                                    
                                    Text("How to Add Wallpaper")
                                        .mfont(17, .regular)
                                        .foregroundColor(.white)
                                    
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 56)
                                
                            })
                            
                            NavigationLink(destination: {
                                TutorialShuffleView()
                            }, label: {
                                HStack{
                                    Image("slide_tutorial")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(16)
                                    
                                    Text("How to Add Shuffle Packs")
                                        .mfont(17, .regular)
                                        .foregroundColor(.white)
                                    
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 56)
                                
                            })
                            
                            
                            NavigationLink(destination: {
                             WatchFaceTutorialView()
                            }, label: {
                                HStack{
                                    Image("slide_tutorial")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(16)
                                    
                                    Text("How to Add Watch Face")
                                    
                                        .mfont(17, .regular)
                                        .foregroundColor(.white)
                                    
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 56)
                                
                            })
                            
                            NavigationLink(destination: {
                              WidgetTutorialView()
                            }, label: {
                                HStack{
                                    Image("slide_tutorial")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(16)
                                    
                                    Text("How to Add Widget")
                                        .mfont(17, .regular)
                                        .foregroundColor(.white)
                                    
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 56)
                                
                            })
                            
                            
                            Button(action: {
                                if let url = URL(string: "https://forms.gle/DNj79sZUQxm2BrHx6") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                HStack{
                                    Image("slide_support")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .padding(16)
                                    
                                    Text("Support")
                                        .mfont(17, .regular)
                                        .foregroundColor(.white)
                                    
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 56)
                            })
                            
                            
                            
                            Divider().background(.white.opacity(0.1))
                            
                            Text("Terms & Privacy")
                                .mfont(17, .bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 56)
                                .padding(.leading, 16)
                            Button(action: {
                                guard let url = URL(string: "https://docs.google.com/document/d/1EY8f5f5Z_-5QfqAeG2oYdUxlu-1sBc-mgfco2qdRMaU") else {
                                    return
                                }
                                
                                UIApplication.shared.open(url)
                            }, label: {
                                Text("Terms of use")
                                    .mfont(17, .regular)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 56)
                                    .padding(.leading, 16)
                            })
                            
                       
                            NavigationLink(destination: {
                                PolicyView()
                                
                            }, label: {
                                Text("Privacy Policy")
                                    .mfont(17, .regular)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 56)
                                    .padding(.leading, 16)
                            })
                            
                            
                            if store.isNewVeriosn(){
                                VStack(alignment : .leading ,spacing : 8){
                                    Text("We've got an app version with a better experience for you, update the app to enjoy!")
                                        .mfont(13, .regular)
                                      .foregroundColor(.white)
                                      .frame(maxWidth: .infinity, alignment: .topLeading)
                                    
                                    Button(action: {
                                        rateApp()
                                    }, label: {
                                        
                                        Text("Update app")
                                            .mfont(15, .bold)
                                          .multilineTextAlignment(.center)
                                          .foregroundColor(.white)
                                          .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                          .background(
                                            Capsule()
                                                .fill( LinearGradient(
                                                    stops: [
                                                      Gradient.Stop(color: Color(red: 0.15, green: 0.7, blue: 1), location: 0.00),
                                                      Gradient.Stop(color: Color(red: 0.46, green: 0.37, blue: 1), location: 0.52),
                                                      Gradient.Stop(color: Color(red: 0.9, green: 0.2, blue: 0.87), location: 1.00),
                                                    ],
                                                    startPoint: UnitPoint(x: 0, y: 1.38),
                                                    endPoint: UnitPoint(x: 1, y: -0.22)
                                                  ))
                                          )
                                        
                                    })
                                }
                                .padding(EdgeInsets(top: 12, leading: 16, bottom: 16, trailing: 16))
                                .background(
                                    VisualEffectView(effect: UIBlurEffect(style: .light))
                                )
                                .cornerRadius(8)
                                .padding(.horizontal, 16)
                            }
                            
                            
                           
                            
                          
                               
                            
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .frame(width: getRect().width - 55)
                .background(
                    Color.white.opacity(0.1)
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)){
                        runAnim.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.showMenu = false
                    })
                }
                
                
                Rectangle()
                    .fill(Color.white.opacity(0.01))
                    .ignoresSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)){
                            runAnim.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            self.showMenu = false
                        })
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(x : runAnim ? 0 : -getRect().width)
            .onAppear(perform: {
                withAnimation(.linear){
                    runAnim.toggle()
                }
            })
        }
        
        
        
    }
    
    func rateApp() {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id\(appId)?mt=8&action=write-review") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
  
}

