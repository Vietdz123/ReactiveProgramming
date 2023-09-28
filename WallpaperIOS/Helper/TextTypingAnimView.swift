//
//  TextTypingAnimView.swift
//  WallpaperIOS
//
//  Created by Duc on 26/09/2023.
//

import SwiftUI

struct TextTypingAnimView: View {
    let text : String
    let color : Color
    let fontSize : CGFloat
    let weight : K2D
    
    var delay : CGFloat = 0.0
    
    @State var animText : String = ""
    @State var index : Int = 0
    var body: some View {
        
        
            Text(text)
                .mfont(fontSize, weight)
                .foregroundColor(.white)
                .opacity(0.0)
                .overlay(
                    Text(animText)
                        .mfont(fontSize, weight)
                        .foregroundColor(color)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .shadow(color: color.opacity(0.1), radius: 2)
                        .shadow(color: color.opacity(0.8), radius: 2)
                        .shadow(color: color.opacity(0.6), radius: 2)
                                  
                        .onAppear(perform: {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                                Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true, block: {
                                    timer in
                                    if index < text.count{
                                    
                                            animText += String(text[text.index(text.startIndex, offsetBy: index)])
                                     
                                    index += 1
                                    }else{
                                        timer.invalidate()
                                    }
                                })
                            })
                            
                           
                        })
                
                    ,alignment: .leading
                )
         
        
        
      
    }
}

#Preview {
    //TextTypingAnimView(text: "Wallive", color: .blue, fontSize: 30, weight: .bold)
    SplashScreenView()
}
