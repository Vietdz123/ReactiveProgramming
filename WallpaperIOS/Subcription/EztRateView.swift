//
//  EztRateView.swift
//  WallpaperIOS
//
//  Created by Duc on 10/05/2024.
//

import SwiftUI

struct EztRateView: View {
    
    @State var currentStar : Int = 0
    let onClickSubmit5star : () -> ()
    let onClickNoThanksOrlessthan5 : () -> ()
    
    @State var showLottieFile : Bool = true
    
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            
            VStack(spacing : 0){
                Image("rate_hand")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 120)
                    .padding(.top, 24)
                
                Text("How would you rate Our\nApp Experience?")
                  .font(
                    Font.custom("SVN-Avo", size: 17)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .frame(width: 272, height: 52, alignment: .top)
                  .padding(.top, 16)
                  .padding(.bottom, 24)
                
                
                HStack(spacing : 16){
                    ForEach(1...5, id: \.self){
                        index in
                        Image( currentStar >= index ? "rate_star" : "rate_star_unactive")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 40)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                currentStar = index
                            }
                        
                    }
                }.overlay(alignment: .trailing, content: {
                    if showLottieFile{
                        ResizableLottieView(filename: "preview_wg")
                            .frame(width: 160, height: 160, alignment: .center)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showLottieFile = false
                                currentStar = 5
                            }
                            .offset(x : 60)
                            .onAppear(perform: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0,  execute: {
                                    showLottieFile = false
                                })
                            })
                    }
                
                })
                
                Button(action: {
                    
                    if currentStar == 0 {
                        showToastWithContent(image: "xmark", color: .red, mess: "Please vote before submitting")
                        return
                    }
                    
                    UserDefaults.standard.set(true, forKey: "user_click_button_submit_in_rateview")
                    if currentStar ==  5 {
                        onClickSubmit5star()
                    }else{
                        onClickNoThanksOrlessthan5()
                    }
                }, label: {
                    Text("Submit")
                      .font(
                        Font.custom("SVN-Avo", size: 17)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                      .frame(maxWidth: .infinity)
                      .frame(height: 48)
                      .background(Color(red: 1, green: 0.87, blue: 0.19))
                      .cornerRadius(40)
                      .padding(.horizontal, 40)
                      .padding(.top, 40)
                })
                
                Button(action: {
                    onClickNoThanksOrlessthan5()
                }, label: {
                    Text("No, Thanks!")
                      .font(Font.custom("SVN-Avo", size: 13))
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .opacity(0.7)
                      .padding(.top, 16)
                      .padding(.bottom, 22)
                })
          
                
            }.frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.2))
                .cornerRadius(16)
                .padding(.horizontal, 27)
            
            
        }
    }
}

