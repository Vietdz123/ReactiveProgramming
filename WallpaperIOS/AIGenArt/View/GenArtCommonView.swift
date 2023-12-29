//
//  GenArtCommonView.swift
//  WallpaperIOS
//
//  Created by Duc on 19/12/2023.
//

import SwiftUI

struct GenArtLimitHelper{
    
    static func  canGenArtToday() -> Bool {
        setLimitGenArtIfNeeded()
        
        let genArtTimesKey : String = "gen_art_time"
        let genArtTimes : Int = UserDefaults.standard.integer(forKey: genArtTimesKey)
        
        print("GenArtLimitHelper checkLimitToday \(genArtTimes)")
        
        if genArtTimes < 3 {
            return true
        }
        return false
    }
    
    static func increaseLimitGenArt(){
        let genArtTimesKey : String = "gen_art_time"
        let times = UserDefaults.standard.integer(forKey: genArtTimesKey)
        UserDefaults.standard.setValue(times + 1, forKey: genArtTimesKey)
    }
    
    static func setLimitGenArtIfNeeded(){
        let genArtTimesKey : String = "gen_art_time"
        let dateSaveForGenArtKey : String = "date_save_for_gen_art"
        
        let currentDate = Date().toString(format: "dd/MM/yyyy")
        let dateSave = UserDefaults.standard.string(forKey: dateSaveForGenArtKey) ?? ""
        
        print("GenArtLimitHelper setLimitGenArtIfNeeded currentDate \(currentDate)")
        print("GenArtLimitHelper setLimitGenArtIfNeeded dateSave \(dateSave)")

        if currentDate != dateSave{
            UserDefaults.standard.setValue( currentDate, forKey: dateSaveForGenArtKey)
            UserDefaults.standard.setValue(0, forKey: genArtTimesKey)
        }
    }
}

struct DialogShowGenArt: View {
    @Binding var show : Bool
    var onClickBuySub : () -> ()
    var onClickWatchAds : () -> ()
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
                .onTapGesture {
                    show = false
                }
            
            VStack(spacing : 0){
                HStack{
                 Spacer()
                    Button(action: {
                        show = false
                    }, label: {
                        Image("close.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                    })
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                }
                
                
                Image("genart_buyvip1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .offset(y : -8)
                
                Text("One last step before creating\nyour AI Wallpaper")
                    .mfont(20, .bold, line: 2)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .padding(.horizontal, 24)
                  .padding(.top, 16)
                
                Text("You can Unlock Wallive PRO or \nwatch an ad to continue")
                    .mfont(13, .regular, line: 2)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .padding(.horizontal, 24)
                  .padding(.top, 16)
                
                
                Button(action: {
                    show = false
                    onClickBuySub()
                }, label: {
                    Text("Unlock Premium")
                        .mfont(17, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                      .frame(width: 240, height: 48)
                      .background(
                        Capsule()
                            .fill(Color.main)
                      )
                })   .padding(.top, 24)
                
                   Button(action: {
                       show = false
                    onClickWatchAds()
                }, label: {
                    Text("Watch an Ad")
                        .mfont(17, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color.black)
                      .frame(width: 240, height: 48)
                      .background(
                        Capsule()
                            .fill(Color.white)
                      )
                })
                   .padding(.top, 16)
                   .padding(.bottom, 48)
              
                
            }
            .frame(maxWidth: .infinity)
            .background(
                Image("bg_dialog_genart")
                    .resizable()
                    .scaledToFill()
            )
                .cornerRadius(16)
               
        }
        .ignoresSafeArea()
    }
}


struct LoadingGenArtView : View {
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            
            VStack(spacing : 0){
                Text("AI wallpaper is being initialized...")
                    .mfont(15, .bold)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
               
                ResizableLottieView(filename: "loading_gen_art")
                    .frame(width: 48, height: 24)
                
            }.frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 16, leading: 12, bottom: 12, trailing: 12))
                .background(
                    Image("bg_loading_genart")
                        .resizable()
                        .scaledToFill()

                )
                .clipped()
                .cornerRadius(16)
                .padding(.horizontal, 48)
            
        }
    }
}


struct RemoveLimitView : View {
    
    @Binding var show : Bool
    var onClickBuySub : () -> ()
    
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
                .onTapGesture {
                    show = false
                }
          
            
            VStack(spacing : 0){
                Image("content_remove_limit")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 20)
                    .padding(.top, 25)
                
                Text("The number of times generate today has reached the limit!")
                    .mfont(20, .bold, line: 3)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .shadow(color: .black.opacity(0.25), radius: 0, x: 0, y: 1)
                  .frame(maxWidth: .infinity)
                  .padding(.horizontal, 24)
                
                
                Text("You can Remove the limits with\nWallive Premium ")
                    .mfont(13, .regular, line: 3)
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .padding(.horizontal, 24)
                  .padding(.vertical, 16)
                
                Button(action: {
                    show = false
                    onClickBuySub()
                }, label: {
                    Text("Remove Limits")
                        .mfont(17, .bold)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                      .frame(maxWidth: .infinity)
                      .frame(height: 48)
                      .background(
                        Capsule()
                            .fill(Color.main)
                      )
                }).padding(.horizontal, 24)
                    .padding(.bottom, 16)
            }.frame(maxWidth: .infinity)
                .background(
                    Image("bg_remove_limit")
                        .resizable()
                        .scaledToFill()
                )
                .overlay(alignment: .topTrailing){
                    Button(action: {
                        show = false
                    }, label: {
                      
                                Image("close.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .opacity(0.7)
                           
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 12)
                        
                    })
                }
                .padding(.horizontal, 40)
            
        }
    }
}

#Preview{
    RemoveLimitView(show: .constant(true), onClickBuySub: {})
}
