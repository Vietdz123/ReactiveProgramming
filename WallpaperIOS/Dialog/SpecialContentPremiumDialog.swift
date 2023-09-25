//
//  SpecialContentPremiumDialog.swift
//  WallpaperIOS
//
//  Created by Duc on 25/09/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SpecialContentPremiumDialog: View {
    
    
    let width : CGFloat = UIScreen.main.bounds.width - 56
    let height : CGFloat =  UIScreen.main.bounds.width * 1.2
    
    @Binding var show : Bool
    let urlStr : String
    let onClickBuyPro : () -> ()
    var body: some View {
        ZStack{
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .ignoresSafeArea()
            WebImage(url: URL(string: urlStr))
            
               .onSuccess { image, data, cacheType in
                   // Success
                   // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
               }
               .resizable()
               .placeholder {
                   EZProgressView()
               }
               .indicator(.activity) // Activity Indicator
               .transition(.fade(duration: 0.5)) // Fade Transition with duration
               .scaledToFill()
               .frame(width: width, height: height)
               .clipped()
               
           
            .overlay(
                VStack(spacing : 0){
   
                    
                    Text("Premium contents.")
                        .mfont(20, .bold)
                        .foregroundColor(.main)
                    
                    Text("Bringing you a wonderful experience!")
                        .mfont(15, .regular)
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                    
                    Button(action: {
                        
                       onClickBuyPro()
                    }, label: {
                        HStack{
                            
                            ResizableLottieView(filename: "star")
                                .frame(width: 32, height: 32)
                            
                            Text("Unlock all Features")
                                .mfont(16, .bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 14.67)
                            
                            
                            
                        }.frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 0, leading: 26.67, bottom: 0, trailing: 0))
                            .frame(height: 56)
                            .background(
                                ZStack{
                                   
                                    Color.main
                                    .frame(height: 56)
                                
                                   
                                }.frame(height: 56)
                                    .clipShape(Capsule())
                            )
                            .padding(.horizontal, 20)
                    })
                    .padding(.bottom , 24)
                }
                    .background(
                        LinearGradient(colors: [Color.clear,  Color.mblack_bg.opacity(0.5), Color.mblack_bg.opacity(0.7), Color.mblack_bg.opacity(0.9) ], startPoint: .top, endPoint: .bottom)
                    )
                
                , alignment: .bottom
            )
            .overlay(
                Button(action: {
                    
                    withAnimation{
                        show.toggle()
                    }
                    
                }, label: {
                    Image("close.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                .padding(.all, 8)
                , alignment: .topTrailing
            )
            .cornerRadius(8)
            
        }
    }
}
