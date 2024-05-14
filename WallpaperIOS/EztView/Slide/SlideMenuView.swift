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
    
    
    @State var showNotificationOpt : Bool = false
    @State var showRateView : Bool = false
    
    
    var body: some View {
        ZStack{
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            
            HStack(spacing : 0){
                VStack(spacing : 0){
                    

                    
                    ZStack{
                        if !store.isPro(){
                            NavigationLink(destination: {
                                EztSubcriptionView()
                                    .environmentObject(store)
                                    .navigationBarTitle("", displayMode: .inline)
                                    .navigationBarHidden(true)
                            }, label: {
                                Image("slide_banner_v")
                                    .resizable()
                                    .scaledToFit()
                            })
                        }else{
                            Image("slide_banner_vip")
                                .resizable()
                                .scaledToFit()
                        }
                        
                    } .frame(maxWidth: .infinity)
                
                    

                    
                        
                    
                    Text("Settings")
                        .mfont(20, .bold)
                      .foregroundColor(.white)
                      .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment : .leading)
                      .padding(.leading, 16)
                      .padding(.top, 8)
                      .padding(.bottom, 16)
                      .onAppear(perform: {
                          NotificationHelper.share.requestNotificationPermission(onComplete: {
                              status in
                              if !status {
                                  showNotificationOpt = true
                              }
                          })
                      })
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(spacing : 0){

                            if showNotificationOpt {
                                Button(action: {
                                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                                        UIApplication.shared.open(appSettings)
                                    }
                                   }, label: {
                                       HStack{
                                           Image("slide_noti")
                                               .resizable()
                                               .frame(width: 24, height: 24)
                                               .padding(16)
                                           
                                           Text("Notification")
                                               .mfont(17, .regular)
                                               .foregroundColor(.white)
                                           
                                           Spacer()
                                           
                                           ZStack{
                                               Image("uncheck")
                                                   .resizable()
                                                   
                                           }
                                           .frame(width: 44, height: 24)
                                           .padding(.trailing, 16)
                                           
                                       }.frame(maxWidth: .infinity, alignment: .leading)
                                           .frame(height: 56)
                                       
                                   })
                            }
                         
                            
                            
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
                            
                            if UserDefaults.standard.bool(forKey: "user_click_button_submit_in_rateview") == false{
                                Button(action: {
                                    showRateView.toggle()
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
                            }
                         
                            
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
                            
                            
                            NavigationLink(destination: {
                              PosterContactTutoView()
                            }, label: {
                                HStack{
                                    Image("slide_tutorial")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(16)
                                    
                                    Text("How to Add Poster Contact")
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
                                        .mfont(13, .regular, line : 3)
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
        .overlay{
            if showRateView{
                EztRateView(onClickSubmit5star: {
                    showRateView = false
                    rateApp()
                }, onClickNoThanksOrlessthan5: {
                    showRateView = false
                })
            }
        }
        
        
        
    }
    

  
}

